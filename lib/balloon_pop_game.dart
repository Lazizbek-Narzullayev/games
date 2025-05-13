import 'package:flutter/material.dart';
import 'dart:math';

class BalloonPopGameScreen extends StatefulWidget {
  const BalloonPopGameScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _BalloonPopGameScreenState createState() => _BalloonPopGameScreenState();
}

class _BalloonPopGameScreenState extends State<BalloonPopGameScreen> {
  List<Map<String, dynamic>> balloons = [];
  int _score = 0;
  bool _isGameOver = false;
  final Random _random = Random();

  void _addBalloon() {
    if (mounted && !_isGameOver) {
      setState(() {
        balloons.add({
          'x': _random.nextDouble() * (MediaQuery.of(context).size.width - 60),
          'y': MediaQuery.of(context).size.height,
          'speed': _random.nextDouble() * 5 + 2,
        });
      });
    }
  }

  void _popBalloon(int index) {
    if (!_isGameOver) {
      setState(() {
        _score += 10;
        balloons.removeAt(index);
      });
    }
  }

  void _updateBalloons() {
    if (mounted && !_isGameOver) {
      setState(() {
        for (int i = 0; i < balloons.length; i++) {
          balloons[i]['y'] -= balloons[i]['speed'];
        }
        if (balloons.any((balloon) => balloon['y'] < -60)) {
          _isGameOver = true;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('& Hamdardman'),
              backgroundColor: Colors.red,
              behavior: SnackBarBehavior.floating,
              margin: const EdgeInsets.symmetric(horizontal: 50, vertical: 250),
            ),
          );
          return;
        }
        balloons.removeWhere((balloon) => balloon['y'] < -60);
        if (_random.nextInt(10) < 1) _addBalloon(); // Balon sekinroq ko'payadi
      });
      Future.delayed(const Duration(milliseconds: 50), _updateBalloons);
    }
  }

  void _restartGame() {
    setState(() {
      balloons.clear();
      _score = 0;
      _isGameOver = false;
    });
    _updateBalloons();
  }

  @override
  void initState() {
    super.initState();
    _updateBalloons();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Balon Yorish'),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.pink, Colors.red],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.pink, Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Stack(
          children: [
            for (int i = 0; i < balloons.length; i++)
              Positioned(
                left: balloons[i]['x'],
                top: balloons[i]['y'],
                child: GestureDetector(
                  onTap: () => _popBalloon(i),
                  child: Container(
                    width: 60,
                    height: 60,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.redAccent,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.red,
                          blurRadius: 10,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Ball: $_score',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            if (_isGameOver)
              Center(
                child: ElevatedButton(
                  onPressed: _restartGame,
                  child: const Text(
                    'Qayta boshlash',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
