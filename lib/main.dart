import 'package:flutter/material.dart';
import 'reaction_game.dart';
import 'memory_cards_game.dart';
import 'number_sort_game.dart';
import 'color_match_game.dart';
import 'word_puzzle_game.dart';
import 'balloon_pop_game.dart';
import 'slider_puzzle_game.dart';
import 'math_quiz_game.dart';
import 'maze_game.dart';

void main() {
  runApp(const GameHubApp());
}

class GameHubApp extends StatelessWidget {
  const GameHubApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.blue[50],
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blueAccent,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            // ignore: deprecated_member_use
            shadowColor: Colors.blue.withOpacity(0.5),
            elevation: 5,
          ),
        ),
      ),
      home: const GameListScreen(),
    );
  }
}

class GameListScreen extends StatelessWidget {
  const GameListScreen({super.key});

  final List<Map<String, dynamic>> games = const [
    {
      'title': 'Reaksiya Tezligi',
      'screen': ReactionGameScreen(),
      'icon': Icons.flash_on,
    },
    {
      'title': 'Xotira Kartalari',
      'screen': MemoryCardsGameScreen(),
      'icon': Icons.memory,
    },
    {
      'title': 'Raqamlarni Tartiblash',
      'screen': NumberSortGameScreen(),
      'icon': Icons.sort,
    },
    {
      'title': 'Rang Topish',
      'screen': ColorMatchGameScreen(),
      'icon': Icons.color_lens,
    },
    {
      'title': 'So\'z Topish',
      'screen': WordPuzzleGameScreen(),
      'icon': Icons.text_fields,
    },
    {
      'title': 'Balon Yorish',
      'screen': BalloonPopGameScreen(),
      'icon': Icons.circle,
    },
    {
      'title': 'Puzzl',
      'screen': SliderPuzzleGameScreen(),
      'icon': Icons.extension,
    },
    {
      'title': 'Tez Matematika',
      'screen': MathQuizGameScreen(),
      'icon': Icons.calculate,
    },
    {
      'title': 'Yo\'l Topish',
      'screen': MazeGameScreen(),
      'icon': Icons.explore,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('O\'yinlar Markazi'),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blueAccent, Colors.cyan],
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
        child: ListView.builder(
          itemCount: games.length,
          itemBuilder: (context, index) {
            return Card(
              elevation: 8,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              // ignore: deprecated_member_use
              color: Colors.white.withOpacity(0.9),
              margin: const EdgeInsets.symmetric(vertical: 8),
              child: ListTile(
                leading: Icon(
                  games[index]['icon'],
                  color: Colors.blueAccent,
                  size: 40,
                ),
                title: Text(
                  games[index]['title'],
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                trailing: const Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.blueAccent,
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => games[index]['screen'],
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
