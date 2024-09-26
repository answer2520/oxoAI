import 'package:flutter/material.dart';
import 'package:oxoai/widgets/grid.dart';

class TicTacToeScreen extends StatefulWidget {
  @override
  _TicTacToeScreenState createState() => _TicTacToeScreenState();
}

class _TicTacToeScreenState extends State<TicTacToeScreen> {
  // 3x3 grid initialized with empty strings
  List<List<String>> _grid = List.generate(3, (_) => List.filled(3, ''));

  // Tracks the current player (true for player, false for AI)
  bool _isPlayerTurn = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Background color for the screen
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
                      ),
                    ],
                  ),

                  // "AI" section
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
                  child: GestureDetector(
                    onTapUp: (details) => _handleTap(details, context),
                    child: CustomPaint(
                      painter: TicTacToePainter(_grid),
                    ),
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
  void _handleTap(TapUpDetails details, BuildContext context) {
    // Get the size of the grid
    RenderBox renderBox = context.findRenderObject() as RenderBox;
    Size size = renderBox.size;

    // Calculate the tapped position (row, col)
    double cellSize = size.width / 3;
    int row = (details.localPosition.dy ~/ cellSize);
    int col = (details.localPosition.dx ~/ cellSize);

    // Check if the tapped cell is empty and it's the player's turn
    if (_grid[row][col] == '') {
      setState(() {
        _grid[row][col] =
            _isPlayerTurn ? 'X' : 'O'; // Mark 'X' for player, 'O' for AI
        _isPlayerTurn = !_isPlayerTurn; // Toggle turn
      });
    }
  }
}
