import 'package:flutter/material.dart';
import 'dart:math';

class ColorMatchGameScreen extends StatefulWidget {
  const ColorMatchGameScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ColorMatchGameScreenState createState() => _ColorMatchGameScreenState();
}

class _ColorMatchGameScreenState extends State<ColorMatchGameScreen> {
  final List<Color> colors = [
    Colors.red,
    Colors.blue,
    Colors.green,
    Colors.yellow,
  ];
  final List<String> colorNames = ['Qizil', 'Ko\'k', 'Yashil', 'Sariq'];
  int _correctIndex = 0;
  int _score = 0;
  bool _isGameOver = false;
  final Random _random = Random();

  void _nextRound() {
    if (!_isGameOver) {
      setState(() {
        _correctIndex = _random.nextInt(colors.length);
      });
    }
  }

  void _checkColor(int index) {
    if (_isGameOver) return;
    setState(() {
      if (index == _correctIndex) {
        _score += 10;
        _nextRound();
      } else {
        _isGameOver = true;
        _showGameOverDialog('Xato! O\'yin tugadi. Ball: $_score');
      }
    });
  }

  void _restartGame() {
    setState(() {
      _score = 0;
      _isGameOver = false;
    });
    _nextRound();
  }

  void _showGameOverDialog(String message) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (context) => AlertDialog(
            title: const Text('O\'yin tugadi'),
            content: Text(message),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  _restartGame();
                },
                child: const Text('Qayta boshlash'),
              ),
            ],
          ),
    );
  }

  @override
  void initState() {
    super.initState();
    _nextRound();
  }

  @override
  Widget build(BuildContext context) {
    double gridSize = MediaQuery.of(context).size.width * 0.4;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Rang Topish'),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.orange, Colors.yellow],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.orange, Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Rang: ${colorNames[_correctIndex]}',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            Text(
              'Ball: $_score',
              style: const TextStyle(fontSize: 20, color: Colors.white),
            ),
            const SizedBox(height: 20),
            Center(
              child: Container(
                width: gridSize,
                height: gridSize,
                decoration: BoxDecoration(
                  // ignore: deprecated_member_use
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 10,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: GridView.count(
                  shrinkWrap: true,
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  padding: const EdgeInsets.all(8),
                  children: List.generate(colors.length, (index) {
                    return GestureDetector(
                      onTap: () => _checkColor(index),
                      child: Container(
                        decoration: BoxDecoration(
                          color: colors[index],
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 5,
                              spreadRadius: 1,
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
