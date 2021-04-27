import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: SizedBox.expand(
          child: Container(
            color: Color(0xFF15202D),
            child: ImplicitAnimationDemo(),
          ),
        ),
      ),
    );
  }
}

class ImplicitAnimationDemo extends StatefulWidget {
  ImplicitAnimationDemo({Key key}) : super(key: key);

  @override
  _ImplicitAnimationDemoState createState() => _ImplicitAnimationDemoState();
}

class _ImplicitAnimationDemoState extends State<ImplicitAnimationDemo> {
  static final _rng = Random();

  Color _color = Colors.red;
  double _width = 100;
  double _height = 100;
  double _radius = 50;
  Alignment _alignment = Alignment(0.5, 0.5);

  int _score = 0;

  void _randomize() {
    _color = Color.fromARGB(
      _rng.nextInt(255),
      _rng.nextInt(255),
      _rng.nextInt(255),
      _rng.nextInt(255),
    );
    _width = _rng.nextDouble() * 120 + 10;
    _height = _rng.nextDouble() * 120 + 10;
    _radius = _rng.nextDouble() * 50 + 10;
    _alignment = Alignment(
      _rng.nextDouble() * 2 - 1,
      _rng.nextDouble() * 2 - 1,
    );
  }

  void _increaseScore() {
    _score++;
  }

  Timer _timer;
  int _countDown = 10;
  bool _isPlaying = false;

  void _startGame() {
    _score = 0;
    _countDown = 10;
    _isPlaying = true;
    _randomize();
    _startTimer();
  }

  void _endGame() {
    _isPlaying = false;
  }

  void _startTimer() {
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
      oneSec,
      (Timer timer) => setState(
        () {
          print(_countDown);
          if (_countDown < 1) {
            _endGame();
            timer.cancel();
          } else {
            _countDown = _countDown - 1;
          }
        },
      ),
    );
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
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'Score: $_score',
                style: TextStyle(color: Colors.white, fontSize: 48),
              ),
              (!_isPlaying)
                  ? GestureDetector(
                      onTap: () => setState(() {
                        _startGame();
                      }),
                      child: Text(
                        'Start',
                        style: TextStyle(color: Colors.white, fontSize: 28),
                      ),
                    )
                  : Text(
                      '$_countDown',
                      style: TextStyle(color: Colors.white, fontSize: 28),
                    ),
            ],
          ),
        ),
        (_isPlaying)
            ? GestureDetector(
                onTap: () => setState(() {
                  _increaseScore();
                  _randomize();
                }),
                // AnimatedAlign : Implicit Animation
                child: AnimatedAlign( 
                  curve: Curves.ease,
                  duration: Duration(milliseconds: 500),
                  alignment: _alignment,
                // AnimatedContainer : Implicit Animation
                  child: AnimatedContainer(
                    duration: Duration(milliseconds: 500),
                    width: _width,
                    height: _height,
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
