import 'package:flutter/material.dart';
import 'package:oxoai/widgets/modalSheet.dart';

class MultiPlayerScreen extends StatefulWidget {
  MultiPlayerScreen({super.key});

  @override
  _MultiPlayerScreenState createState() => _MultiPlayerScreenState();
}

class _MultiPlayerScreenState extends State<MultiPlayerScreen> {
  // 3x3 grid initialized with empty strings
  final List<List<String>> _grid = List.generate(3, (_) => List.filled(3, ''));

  // Tracks the current player (true for player 1 (X), false for player 2 (O))
  bool _isPlayer1Turn = true;

  // Scores for Player 1 and Player 2
  int _player1Score = 0;
  int _player2Score = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          // Top section for player status and scores
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
                  // "Player 1 (X)" section with score
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'YOU',
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
                        child: Center(
                          child: Text(
                            '$_player1Score',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  // "Player 2 (O)" section with score
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'AI',
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
                        child: Center(
                          child: Text(
                            '$_player2Score',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // Middle section for Tic-Tac-Toe grid
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
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Center(
                            child: Text(
                              _grid[row][col], // Show X or O
                              style: TextStyle(
                                fontSize: 48,
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
                    showModalBottomSheet(
                      context: context,
                      builder: (context) => ModalBottomSheetExample(),
                    );
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
            _isPlayer1Turn ? 'X' : 'O'; // Mark X for player 1, O for player 2
        _isPlayer1Turn = !_isPlayer1Turn; // Switch turn
      });

      // Check for win after the move
      String? winner = _checkWin();
      if (winner != null) {
        // Update the score for the winner
        if (winner == 'X') {
          _player1Score++;
        } else if (winner == 'O') {
          _player2Score++;
        }
        _showGameOverDialog(winner);
      } else if (_isGridFull()) {
        // If no winner and the grid is full, it's a draw
        _showGameOverDialog('Draw');
      }
    }
  }

  // Check if the grid is full
  bool _isGridFull() {
    for (var row in _grid) {
      if (row.contains('')) {
        return false;
      }
    }
    return true;
  }

  // Check for a win condition
  String? _checkWin() {
    // Check rows, columns, and diagonals for a win
    for (int i = 0; i < 3; i++) {
      if (_grid[i][0] == _grid[i][1] &&
          _grid[i][1] == _grid[i][2] &&
          _grid[i][0] != '') {
        return _grid[i][0]; // Return the winner ('X' or 'O')
      }
      if (_grid[0][i] == _grid[1][i] &&
          _grid[1][i] == _grid[2][i] &&
          _grid[0][i] != '') {
        return _grid[0][i]; // Return the winner ('X' or 'O')
      }
    }
    // Check diagonals
    if (_grid[0][0] == _grid[1][1] &&
        _grid[1][1] == _grid[2][2] &&
        _grid[0][0] != '') {
      return _grid[0][0];
    }
    if (_grid[0][2] == _grid[1][1] &&
        _grid[1][1] == _grid[2][0] &&
        _grid[0][2] != '') {
      return _grid[0][2];
    }
    return null; // No winner
  }

  // Show a dialog when the game is over
  void _showGameOverDialog(String result) {
    String dialogTitle = result == 'Draw'
        ? 'It\'s a Draw!'
        : 'Player ${result == 'X' ? '1' : '2'} Wins!';

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.grey[900],
          title: Text(
            dialogTitle,
            style: const TextStyle(color: Colors.white),
          ),
          content: const Text(
            'Would you like to play again?',
            style: TextStyle(color: Colors.white70),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text(
                'Yes',
                style: TextStyle(color: Colors.blueAccent),
              ),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                _resetGrid(); // Reset the grid for a new game
              },
            ),
            TextButton(
              child: const Text(
                'No',
                style: TextStyle(color: Colors.redAccent),
              ),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                // Optional: Navigate to another screen or quit the game
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
