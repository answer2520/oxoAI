import 'package:flutter/material.dart';
import 'package:oxoai/GamePage.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tic-Tac-Toe Home')),
      body: Center(
        child: ElevatedButton(
          child: const Text('Open Route'),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => TicTacToeScreen()),
            );
          },
        ),
      ),
    );
  }
}
