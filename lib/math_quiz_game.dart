import 'package:flutter/material.dart';
import 'dart:math';

class MathQuizGameScreen extends StatefulWidget {
  const MathQuizGameScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _MathQuizGameScreenState createState() => _MathQuizGameScreenState();
}

class _MathQuizGameScreenState extends State<MathQuizGameScreen> {
  int _num1 = 0;
  int _num2 = 0;
  String _operator = '+';
  int _correctAnswer = 0;
  int _score = 0;
  bool _isGameOver = false;
  final Random _random = Random();

  void _generateQuestion() {
    if (!_isGameOver) {
      setState(() {
        _num1 = _random.nextInt(10) + 1;
        _num2 = _random.nextInt(10) + 1;
        _operator = ['+', '-', '*'][_random.nextInt(3)];
        _correctAnswer =
            _operator == '+'
                ? _num1 + _num2
                : _operator == '-'
                ? _num1 - _num2
                : _num1 * _num2;
      });
    }
  }

  void _checkAnswer(int answer) {
    if (_isGameOver) return;
    setState(() {
      if (answer == _correctAnswer) {
        _score += 10;
        _generateQuestion(); // To‘g‘ri javob – yangi savol
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
    _generateQuestion();
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
    _generateQuestion();
  }

  @override
  Widget build(BuildContext context) {
    List<int> answers = [
      _correctAnswer,
      _correctAnswer + _random.nextInt(10) + 1,
      _correctAnswer - _random.nextInt(5) - 1,
    ];
    answers = answers.toSet().toList(); // dublikatlar bo'lmasligi uchun
    answers.shuffle();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tez Matematika'),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue, Colors.purple],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue, Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _isGameOver
                  ? 'O\'yin tugadi!'
                  : 'Savol: $_num1 $_operator $_num2 = ?',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Ball: $_score',
              style: const TextStyle(fontSize: 20, color: Colors.white),
            ),
            const SizedBox(height: 20),
            if (!_isGameOver)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children:
                    answers.map((answer) {
                      return ElevatedButton(
                        onPressed: () => _checkAnswer(answer),
                        child: Text(
                          answer.toString(),
                          style: const TextStyle(fontSize: 18),
                        ),
                      );
                    }).toList(),
              ),
          ],
        ),
      ),
    );
  }
}
