import 'package:flutter/material.dart';

class MultiPlayerScreen extends StatefulWidget {
  MultiPlayerScreen({super.key});

  @override
  _MultiPlayerScreenState createState() => _MultiPlayerScreenState();
}

class _MultiPlayerScreenState extends State<MultiPlayerScreen> {
  // 3x3 grid initialized with empty strings
  final List<List<String>> _grid = List.generate(3, (_) => List.filled(3, ''));

  // Tracks the current player (true for player, false for AI)
  bool _isPlayerTurn = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          // Top section for player status
          Expanded(
            flex: 2,
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.red, Colors.blue],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // "YOU" section
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Player 1',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        width: 80,
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.redAccent,
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ],
                  ),

                  // "AI" section
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Player 2',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        width: 80,
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.blueAccent,
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // Middle section for Tic-Tac-Toe grid (using GridView)
          Expanded(
            flex: 3,
            child: Center(
              child: Container(
                padding: const EdgeInsets.all(20.0),
                child: AspectRatio(
                  aspectRatio: 1,
                  child: GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3, // 3 columns for Tic-Tac-Toe
                      crossAxisSpacing: 5, // spacing between the cells
                      mainAxisSpacing: 5, // spacing between rows
                    ),
                    itemCount: 9, // 3x3 grid = 9 cells
                    itemBuilder: (context, index) {
                      int row = index ~/ 3; // Get row by integer division
                      int col = index % 3; // Get column by remainder

                      return GestureDetector(
                        onTap: () => _handleTapAtIndex(row, col),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: Colors.black),
                            borderRadius:
                                BorderRadius.circular(15), // Rounded corners
                          ),
                          child: Center(
                            child: Text(
                              _grid[row][col], // Show X or O
                              style: TextStyle(
                                fontSize: 48, // Font size for X and O
                                color: _grid[row][col] == 'X'
                                    ? Colors.red
                                    : Colors.blue, // Color based on player
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ),

          // Bottom right help button
          Expanded(
            flex: 1,
            child: Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: FloatingActionButton(
                  onPressed: () {
                    // Add functionality for help button
                  },
                  backgroundColor: Colors.blueAccent,
                  child: const Icon(Icons.help_outline, color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Handle the tap on the Tic-Tac-Toe grid
  void _handleTapAtIndex(int row, int col) {
    if (_grid[row][col] == '') {
      setState(() {
        _grid[row][col] =
            _isPlayerTurn ? 'X' : 'O'; // Mark X for player, O for AI
        _isPlayerTurn = !_isPlayerTurn; // Switch turn
      });

      // Check if the grid is full after each move
      if (_isGridFull()) {
        _showGameOverDialog(); // Show game over dialog when grid is full
      }
    }
  }

  // Check if the grid is full
  bool _isGridFull() {
    for (var row in _grid) {
      if (row.contains('')) {
        return false; // If any cell is empty, the grid is not full
      }
    }
    return true; // Grid is full
  }

  // Show a dialog when the game is over
  void _showGameOverDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.red.withOpacity(0.7),
          title: const Text('The player X won!'),
          content: const Text('Would you like to play again?'),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                _resetGrid(); // Reset the grid to start a new game
              },
            ),
          ],
        );
      },
    );
  }

  // Reset the grid to an empty state
  void _resetGrid() {
    setState(() {
      _grid.setAll(0, List.generate(3, (_) => List.filled(3, '')));
    });
  }
}
