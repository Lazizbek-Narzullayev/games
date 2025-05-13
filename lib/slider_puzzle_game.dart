import 'package:flutter/material.dart';
import 'dart:math';

class SliderPuzzleGameScreen extends StatefulWidget {
  const SliderPuzzleGameScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SliderPuzzleGameScreenState createState() => _SliderPuzzleGameScreenState();
}

class _SliderPuzzleGameScreenState extends State<SliderPuzzleGameScreen> {
  List<int> tiles = [1, 2, 3, 4, 5, 6, 7, 8, 0]; // 1-8 raqamlar, 0 - bo'sh joy
  int _moves = 0;

  @override
  void initState() {
    super.initState();
    tiles.shuffle(Random()); // Raqamlarni aralashtirish
  }

  void _moveTile(int index) {
    int emptyIndex = tiles.indexOf(0); // Bo'sh joyning indeksi
    // Faqat yonidagi kataklar harakatlana oladi
    if ((index % 3 == emptyIndex % 3 &&
            (index - emptyIndex).abs() == 3) || // Vertikal
        (index ~/ 3 == emptyIndex ~/ 3 && (index - emptyIndex).abs() == 1)) {
      // Gorizontal
      setState(() {
        tiles[emptyIndex] = tiles[index]; // Raqamni bo'sh joyga ko'chirish
        tiles[index] = 0; // Oldingi joyni bo'sh qilish
        _moves++;
      });
      // G'alaba shartini tekshirish
      if (tiles.asMap().entries.every((e) => e.value == (e.key + 1) % 9)) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Tabriklaymiz! Harakatlar: $_moves'),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    double gridSize =
        MediaQuery.of(context).size.width * 0.4; // 40% ekran kengligi
    double tileSize = gridSize / 3; // Har bir katak o'lchami

    return Scaffold(
      appBar: AppBar(
        title: const Text('Puzzl'),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.teal, Colors.green],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.teal, Colors.white],
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
                child: Stack(
                  children: List.generate(9, (index) {
                    int row = index ~/ 3;
                    int col = index % 3;
                    return AnimatedPositioned(
                      duration: const Duration(milliseconds: 300),
                      left: col * tileSize,
                      top: row * tileSize,
                      width: tileSize,
                      height: tileSize,
                      child: GestureDetector(
                        onTap: () => _moveTile(index),
                        child: Container(
                          margin: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color:
                                tiles[index] == 0
                                    ? Colors.transparent
                                    : Colors.greenAccent,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow:
                                tiles[index] == 0
                                    ? null
                                    : const [
                                      BoxShadow(
                                        color: Colors.black26,
                                        blurRadius: 5,
                                        spreadRadius: 1,
                                      ),
                                    ],
                          ),
                          child: Center(
                            child: Text(
                              tiles[index] == 0 ? '' : tiles[index].toString(),
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  tiles.shuffle(Random());
                  _moves = 0;
                });
              },
              child: const Text(
                'Qayta boshlash',
                style: TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
