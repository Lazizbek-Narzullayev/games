import 'package:flutter/material.dart';
import 'dart:math';

class ReactionGameScreen extends StatefulWidget {
  const ReactionGameScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ReactionGameScreenState createState() => _ReactionGameScreenState();
}

class _ReactionGameScreenState extends State<ReactionGameScreen> {
  double _circleX = 0;
  double _circleY = 0;
  int _score = 0;
  bool _isGameRunning = false;
  int _timeLeft = 30;
  final Random _random = Random();

  void _startGame() {
    setState(() {
      _isGameRunning = true;
      _score = 0;
      _timeLeft = 30;
    });
    _moveCircle();
    _startTimer();
  }

  void _moveCircle() {
    if (_isGameRunning) {
      setState(() {
        _circleX =
            _random.nextDouble() * (MediaQuery.of(context).size.width - 60);
        _circleY =
            _random.nextDouble() * (MediaQuery.of(context).size.height - 200);
        _score++;
      });
    }
  }

  void _startTimer() {
    Future.delayed(const Duration(seconds: 1), () {
      if (_isGameRunning && _timeLeft > 0) {
        setState(() {
          _timeLeft--;
        });
        _startTimer();
      } else if (_timeLeft == 0) {
        setState(() {
          _isGameRunning = false;
        });
        ScaffoldMessenger.of(
          // ignore: use_build_context_synchronously
          context,
        ).showSnackBar(SnackBar(content: Text('O\'yin tugadi! Ball: $_score')));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reaksiya Tezligi'),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.redAccent, Colors.orange],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.red, Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Stack(
          children: [
            Positioned(
              left: _circleX,
              top: _circleY,
              child: GestureDetector(
                onTap: _isGameRunning ? _moveCircle : null,
                child: Container(
                  width: 60,
                  height: 60,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.blueAccent,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.blue,
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
                  'Ball: $_score | Vaqt: $_timeLeft s',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: ElevatedButton(
                  onPressed: _startGame,
                  child: const Text('Boshlash', style: TextStyle(fontSize: 18)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
