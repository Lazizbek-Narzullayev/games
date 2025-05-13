import 'package:flutter/material.dart';

class MazeGameScreen extends StatefulWidget {
  const MazeGameScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _MazeGameScreenState createState() => _MazeGameScreenState();
}

class _MazeGameScreenState extends State<MazeGameScreen> {
  List<List<int>> maze = [
    [0, 1, 0, 0, 0],
    [0, 1, 1, 1, 0],
    [0, 0, 0, 0, 0],
    [1, 1, 1, 1, 0],
    [0, 0, 0, 1, 0],
  ];
  int playerX = 0;
  int playerY = 0;
  int _moves = 0;

  void _movePlayer(int dx, int dy) {
    int newX = playerX + dx;
    int newY = playerY + dy;
    if (newX >= 0 &&
        newX < 5 &&
        newY >= 0 &&
        newY < 5 &&
        maze[newY][newX] == 0) {
      setState(() {
        playerX = newX;
        playerY = newY;
        _moves++;
      });
      if (playerX == 4 && playerY == 4) {
        _showGameOverDialog('Tabriklaymiz! Harakatlar: $_moves');
      }
    }
  }

  void _restartGame() {
    setState(() {
      playerX = 0;
      playerY = 0;
      _moves = 0;
    });
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
  Widget build(BuildContext context) {
    double gridSize = MediaQuery.of(context).size.width * 0.4;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Yo\'l Topish'),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.indigo, Colors.blue],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.indigo, Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Harakatlar: $_moves',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
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
                  crossAxisCount: 5,
                  padding: const EdgeInsets.all(8),
                  children: List.generate(25, (index) {
                    int x = index % 5;
                    int y = index ~/ 5;
                    return Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.grey),
                      ),
                      child: Center(
                        child:
                            x == playerX && y == playerY
                                ? const Icon(
                                  Icons.person,
                                  color: Colors.green,
                                  size: 30,
                                )
                                : x == 4 && y == 4
                                ? const Icon(
                                  Icons.flag,
                                  color: Colors.red,
                                  size: 30,
                                )
                                : maze[y][x] == 1
                                ? const Icon(
                                  Icons.block,
                                  color: Colors.black,
                                  size: 30,
                                )
                                : null,
                      ),
                    );
                  }),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () => _movePlayer(0, -1),
                  child: const Icon(Icons.arrow_upward),
                ),
                ElevatedButton(
                  onPressed: () => _movePlayer(0, 1),
                  child: const Icon(Icons.arrow_downward),
                ),
                ElevatedButton(
                  onPressed: () => _movePlayer(-1, 0),
                  child: const Icon(Icons.arrow_back),
                ),
                ElevatedButton(
                  onPressed: () => _movePlayer(1, 0),
                  child: const Icon(Icons.arrow_forward),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
