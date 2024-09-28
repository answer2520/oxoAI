import 'package:flutter/material.dart';
import 'package:oxoai/screens/HomePage.dart';
import 'package:oxoai/screens/MultiGamePage.dart';
import 'package:oxoai/screens/AiGamePage.dart';

class SingleOrMulti extends StatefulWidget {
  const SingleOrMulti({Key? key}) : super(key: key);

  @override
  _SingleOrMultiState createState() => _SingleOrMultiState();
}

class _SingleOrMultiState extends State<SingleOrMulti> {
  String _selectedPartner = 'Ai'; // Default selection is AI

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
                      // Button for Multiplayer
                      _buildPlayerButton('Multiplayer', Colors.green.shade300),
                      const SizedBox(height: 10),
                      // Button for AI
                      _buildPlayerButton('Ai', Colors.blue.shade300),
                      const SizedBox(height: 10),
                      // Go Button to navigate
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 50, vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        onPressed: () {
                          // Conditional navigation based on selected partner
                          if (_selectedPartner == 'Multiplayer') {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MultiPlayerScreen(),
                              ),
                            );
                          } else {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    HomePage(), // Navigate to AI screen
                              ),
                            );
                          }
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

  // Helper function to build the player selection buttons
  Widget _buildPlayerButton(String text, Color color) {
    return Container(
      width: 250,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: _selectedPartner == text ? color : null,
          padding: const EdgeInsets.symmetric(vertical: 15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        onPressed: () {
          setState(() {
            _selectedPartner = text; // Update selected partner
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
