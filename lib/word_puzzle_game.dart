import 'package:flutter/material.dart';
import 'dart:math';

class WordPuzzleGameScreen extends StatefulWidget {
  const WordPuzzleGameScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _WordPuzzleGameScreenState createState() => _WordPuzzleGameScreenState();
}

class _WordPuzzleGameScreenState extends State<WordPuzzleGameScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, dynamic>> wordData = [
    {'word': 'suv', 'letters': 'S U V'},
    {'word': 'gul', 'letters': 'G U L'},
    {'word': 'kitob', 'letters': 'K I T O B'},
    {'word': 'yul', 'letters': 'Y U L'},
    {'word': 'daraxt', 'letters': 'D A R A X T'},
    {'word': 'oy', 'letters': 'O Y'},
    {'word': 'quyosh', 'letters': 'Q U Y O S H'},
    {'word': 'yomg\'ir', 'letters': 'Y O M G I R'},
    {'word': 'shamol', 'letters': 'S H A M O L'},
    {'word': 'bulut', 'letters': 'B U L U T'},
  ];

  List<String> _currentWords = [];
  String _currentLetters = '';
  int _score = 0;
  bool _isGameOver = false;
  final Random _random = Random();

  void _initializeGame() {
    if (_isGameOver) return;

    List<Map<String, dynamic>> selectedWords = [];
    List<int> selectedIndices = [];

    while (selectedIndices.length < 3) {
      int index = _random.nextInt(wordData.length);
      if (!selectedIndices.contains(index)) {
        selectedIndices.add(index);
        selectedWords.add(wordData[index]);
      }
    }

    List<String> allLetters = [];
    _currentWords = selectedWords.map((e) => e['word'].toString()).toList();
    for (var word in selectedWords) {
      allLetters.addAll(word['letters'].split(' '));
    }
    allLetters.shuffle();

    setState(() {
      _currentLetters = allLetters.join(' ');
    });
  }

  void _checkWord() {
    if (_isGameOver) return;

    String word = _controller.text.toLowerCase();
    if (_currentWords.contains(word)) {
      setState(() {
        _score += word.length * 10;
        _currentWords.remove(word);
        if (_currentWords.isEmpty) {
          _initializeGame(); // next round
        }
      });
    } else {
      setState(() {
        _isGameOver = true;
        _showGameOverDialog('Xato so\'z! O\'yin tugadi. Ball: $_score');
      });
    }

    _controller.clear();
  }

  void _restartGame() {
    setState(() {
      _score = 0;
      _isGameOver = false;
      _currentWords = [];
      _currentLetters = '';
    });
    _initializeGame();
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
    _initializeGame();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('So\'z Topish'),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.cyan, Colors.blue],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.cyan, Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Harflar: $_currentLetters',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            Text(
              'Ball: $_score',
              style: const TextStyle(fontSize: 20, color: Colors.black87),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                labelText: 'So\'z kiriting',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _checkWord,
              child: const Text('Tekshirish', style: TextStyle(fontSize: 18)),
            ),
          ],
        ),
      ),
    );
  }
}
