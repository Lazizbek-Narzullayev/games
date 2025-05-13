import 'package:flutter/material.dart';
import 'dart:math';

class MemoryCardsGameScreen extends StatefulWidget {
  const MemoryCardsGameScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _MemoryCardsGameScreenState createState() => _MemoryCardsGameScreenState();
}

class _MemoryCardsGameScreenState extends State<MemoryCardsGameScreen> {
  List<int> cards = [1, 1, 2, 2, 3, 3, 4, 4]; // Juft kartalar
  List<bool> flipped = List.filled(8, false); // Karta ochilganmi
  List<bool> matched = List.filled(8, false); // Karta mos kelganmi
  int? firstCardIndex; // Birinchi ochilgan karta indeksi
  int _moves = 0; // Harakatlar soni
  bool _isChecking = false; // Kartalar tekshirilayotganmi

  @override
  void initState() {
    super.initState();
    cards.shuffle(Random()); // Kartalarni aralashtirish
  }

  void _flipCard(int index) {
    if (_isChecking || flipped[index] || matched[index]) return;

    setState(() {
      flipped[index] = true;
      if (firstCardIndex == null) {
        firstCardIndex = index; // Birinchi kartani saqlash
      } else {
        _moves++;
        _isChecking = true;
        if (cards[firstCardIndex!] == cards[index]) {
          // Kartalar mos keldi
          matched[firstCardIndex!] = true;
          matched[index] = true;
          firstCardIndex = null;
          _isChecking = false;
          // G'alaba shartini tekshirish
          if (matched.every((m) => m)) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Tabriklaymiz! Harakatlar: $_moves'),
                backgroundColor: Colors.green,
              ),
            );
          }
        } else {
          // Kartalar mos kelmadi
          Future.delayed(const Duration(milliseconds: 500), () {
            if (mounted) {
              setState(() {
                flipped[firstCardIndex!] = false;
                flipped[index] = false;
                firstCardIndex = null;
                _isChecking = false;
              });
            }
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Xotira Kartalari'),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.purple, Colors.blue],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.purple, Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        padding: const EdgeInsets.all(16.0),
        child: Column(
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
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemCount: cards.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () => _flipCard(index),
                    child: AnimatedOpacity(
                      opacity: matched[index] ? 0.0 : 1.0,
                      duration: const Duration(milliseconds: 300),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        decoration: BoxDecoration(
                          color:
                              flipped[index] ? Colors.white : Colors.blueAccent,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 5,
                              spreadRadius: 1,
                            ),
                          ],
                        ),
                        child: Center(
                          child: Text(
                            flipped[index] ? cards[index].toString() : '?',
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
