import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hold My Box',
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: SizedBox.expand(
          child: Container(
            color: Color(0xFF15202D),
            child: Animation(),
          ),
        ),
      ),
    );
  }
}

class Animation extends StatefulWidget {
  Animation({Key key}) : super(key: key);

  @override
  _AnimationState createState() => _AnimationState();
}

class _AnimationState extends State<Animation> {
  static final _rand = Random();

  Color _color = Colors.blueAccent;
  double _width = 100.0;
  double _height = 100.0;
  double _radius = 50.0;
  Alignment _alignment = Alignment(0.5, 0.5);

  int _score = 0;

  void _randomize() {
    _color = Color.fromARGB(
      _rand.nextInt(255),
      _rand.nextInt(255),
      _rand.nextInt(255),
      _rand.nextInt(255),
    );
    _width = _rand.nextDouble() * 120 + 10;
    _height = _rand.nextDouble() * 120 + 10;
    _radius = _rand.nextDouble() * 50 + 10;
    _alignment =
        Alignment(_rand.nextDouble() * 2 - 1, _rand.nextDouble() * 2 - 1);
  }

  void _scoreIncrease() {
    _score++;
  }

  Timer _timer;
  int _countdown = 10;
  bool _gameStatus = false;

  void _gameBegin() {
    _countdown = 10;
    _score = 0;
    _gameStatus = true;
    _randomize();
    _timerStart();
  }

  void _gameOver() {
    _gameStatus = false;
  }

  void _timerStart() {
    const perSecond = const Duration(seconds: 1);
    _timer = new Timer.periodic(
        perSecond,
        (timer) => setState(() {
              if (_countdown < 1) {
                _gameOver();
                timer.cancel();
              } else {
                _countdown -= 1;
              }
            }));
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(top: 20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'Hold my box'.toUpperCase(),
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 40.0,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              (!_gameStatus)
                  ? GestureDetector(
                      onTap: () => setState(() {
                        _gameBegin();
                      }),
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Text(
                          'Start'.toUpperCase(),
                          style: TextStyle(
                              color: Color(0x99FFFFFF), fontSize: 70.0),
                        ),
                      ),
                    )
                  : Text(
                      '$_countdown',
                      style:
                          TextStyle(color: Color(0x99FFFFFF), fontSize: 30.0),
                    ),
              Text(
                'Score : $_score',
                style: TextStyle(
                  fontSize: 30.0,
                  color: Color(0x99FFFFFF),
                ),
              ),
            ],
          ),
        ),
        (_gameStatus)
            ? GestureDetector(
                onTap: () => setState(
                  () {
                    _scoreIncrease();
                    _randomize();
                  },
                ),
                child: AnimatedAlign(
                  curve: Curves.ease,
                  duration: Duration(milliseconds: 500),
                  alignment: _alignment,
                  child: AnimatedContainer(
                    duration: Duration(milliseconds: 500),
                    height: _height,
                    width: _width,
                    decoration: BoxDecoration(
                      color: _color,
                      borderRadius: BorderRadius.circular(_radius),
                    ),
                  ),
                ),
              )
            : Container(),
      ],
    );
  }
}
