import 'package:flutter/material.dart';
import 'package:oxoai/screens/GamePage.dart';
// import 'package:audioplayers/audioplayers.dart';

class SingleOrMulti extends StatefulWidget {
  const SingleOrMulti({Key? key}) : super(key: key);

  @override
  _SingleOrMultiState createState() => _SingleOrMultiState();
}

class _SingleOrMultiState extends State<SingleOrMulti> {
  String _selectedPartener = 'Ai'; // Default value

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.red.shade900,
              Colors.blue.shade900,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 20),
              const Text(
                'oxoAI',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Play with',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 20),
                      _buildPlayerButton('Multiplayer', Colors.green.shade300),
                      const SizedBox(height: 10),
                      _buildPlayerButton('Ai', Colors.blue.shade300),
                      const SizedBox(height: 10),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 50, vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => TicTacToeScreen(difficulty: _selectedPartener),
                            ),
                          );
                        },
                        child: const Text(
                          'Go!',
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPlayerButton(String text, Color color) {
    return Container(
      width: 250,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: _selectedPartener == text ? color : null,
          padding: const EdgeInsets.symmetric(vertical: 15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        onPressed: () {
          setState(() {
            _selectedPartener = text; // Set selected difficulty
          });
        },
        child: Text(
          text,
          style: const TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
