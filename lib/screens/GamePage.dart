import 'package:flutter/material.dart';
// import 'package:audioplayers/audioplayers.dart';
import 'dart:math';

// final AudioPlayer _audioPlayer = AudioPlayer();

// void _playSound() {
//   _audioPlayer.play(AssetSource('../lib/assets/sounds/click.mp3'));
// }

class TicTacToeScreen extends StatefulWidget {
  final String difficulty;

  TicTacToeScreen({Key? key, required this.difficulty}) : super(key: key);

  @override
  _TicTacToeScreenState createState() => _TicTacToeScreenState();
}

class _TicTacToeScreenState extends State<TicTacToeScreen> {
  List<List<String>> _grid = List.generate(3, (_) => List.filled(3, ''));
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
                  child: GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 5,
                      mainAxisSpacing: 5,
                    ),
                    itemCount: 9,
                    itemBuilder: (context, index) {
                      int row = index ~/ 3;
                      int col = index % 3;

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
                              _grid[row][col],
                              style: TextStyle(
                                fontSize: 48,
                                color: _grid[row][col] == 'X' ? Colors.red : Colors.blue,
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
    // _playSound();
    if (_grid[row][col].isEmpty && _isPlayerTurn) {
      setState(() {
        _grid[row][col] = 'X';
        _isPlayerTurn = false;
      });

      if (!checkWin(_grid, 'X') && !checkDraw(_grid)) {
        _aiMove();
      }
    }
  }

  void _aiMove() {
    if (widget.difficulty == 'Easy') {
      _makeRandomMove();
    } else if (widget.difficulty == 'Medium') {
      _makeMoveWithLimitedMinimax();
    } else if (widget.difficulty == 'Difficult') {
      _makeBestMoveWithMinimax();
    }

    setState(() {
      _isPlayerTurn = true;
    });
  }

  void _makeRandomMove() {
    List<List<int>> availableMoves = [];
    for (int i = 0; i < 3; i++) {
      for (int j = 0; j < 3; j++) {
        if (_grid[i][j].isEmpty) {
          availableMoves.add([i, j]);
        }
      }
    }

    if (availableMoves.isNotEmpty) {
      Random random = Random();
      List<int> randomMove = availableMoves[random.nextInt(availableMoves.length)];
      setState(() {
        _grid[randomMove[0]][randomMove[1]] = 'O';
      });
    }
  }

  void _makeMoveWithLimitedMinimax() {
    int bestScore = -1000;
    List<int> bestMove = [-1, -1];
    int depthLimit = 2;

    for (int i = 0; i < 3; i++) {
      for (int j = 0; j < 3; j++) {
        if (_grid[i][j].isEmpty) {
          _grid[i][j] = 'O';
          int score = minimaxWithDepthLimit(_grid, false, 0, depthLimit);
          _grid[i][j] = '';
          if (score > bestScore) {
            bestScore = score;
            bestMove = [i, j];
          }
        }
      }
    }

    if (bestMove[0] != -1 && bestMove[1] != -1) {
      setState(() {
        _grid[bestMove[0]][bestMove[1]] = 'O';
      });
    }
  }

  void _makeBestMoveWithMinimax() {
    int bestScore = -1000;
    List<int> bestMove = [-1, -1];

    for (int i = 0; i < 3; i++) {
      for (int j = 0; j < 3; j++) {
        if (_grid[i][j].isEmpty) {
          _grid[i][j] = 'O';
          int score = minimax(_grid, false);
          _grid[i][j] = '';
          if (score > bestScore) {
            bestScore = score;
            bestMove = [i, j];
          }
        }
      }
    }

    if (bestMove[0] != -1 && bestMove[1] != -1) {
      setState(() {
        _grid[bestMove[0]][bestMove[1]] = 'O';
      });
    }
  }

  int minimaxWithDepthLimit(List<List<String>> board, bool isMaximizing, int depth, int maxDepth) {
    if (checkWin(board, 'O')) return 1;
    if (checkWin(board, 'X')) return -1;
    if (checkDraw(board)) return 0;

    if (depth == maxDepth) return 0;

    if (isMaximizing) {
      int bestScore = -1000;
      for (int i = 0; i < 3; i++) {
        for (int j = 0; j < 3; j++) {
          if (board[i][j].isEmpty) {
            board[i][j] = 'O';
            int score = minimaxWithDepthLimit(board, false, depth + 1, maxDepth);
            board[i][j] = '';
            bestScore = max(score, bestScore);
          }
        }
      }
      return bestScore;
    } else {
      int bestScore = 1000;
      for (int i = 0; i < 3; i++) {
        for (int j = 0; j < 3; j++) {
          if (board[i][j].isEmpty) {
            board[i][j] = 'X';
            int score = minimaxWithDepthLimit(board, true, depth + 1, maxDepth);
            board[i][j] = '';
            bestScore = min(score, bestScore);
          }
        }
      }
      return bestScore;
    }
  }

  int minimax(List<List<String>> board, bool isMaximizing) {
    if (checkWin(board, 'O')) return 1;
    if (checkWin(board, 'X')) return -1;
    if (checkDraw(board)) return 0;

    if (isMaximizing) {
      int bestScore = -1000;
      for (int i = 0; i < 3; i++) {
        for (int j = 0; j < 3; j++) {
          if (board[i][j].isEmpty) {
            board[i][j] = 'O';
            int score = minimax(board, false);
            board[i][j] = '';
            bestScore = max(score, bestScore);
          }
        }
      }
      return bestScore;
    } else {
      int bestScore = 1000;
      for (int i = 0; i < 3; i++) {
        for (int j = 0; j < 3; j++) {
          if (board[i][j].isEmpty) {
            board[i][j] = 'X';
            int score = minimax(board, true);
            board[i][j] = '';
            bestScore = min(score, bestScore);
          }
        }
      }
      return bestScore;
    }
  }

  bool checkWin(List<List<String>> board, String player) {
    // Check rows, columns, and diagonals
    for (int i = 0; i < 3; i++) {
      if ((board[i][0] == player && board[i][1] == player && board[i][2] == player) ||
          (board[0][i] == player && board[1][i] == player && board[2][i] == player)) {
        return true;
      }
    }
    if ((board[0][0] == player && board[1][1] == player && board[2][2] == player) ||
        (board[0][2] == player && board[1][1] == player && board[2][0] == player)) {
      return true;
    }
    return false;
  }

  bool checkDraw(List<List<String>> board) {
    for (var row in board) {
      if (row.contains('')) {
        return false;
      }
    }
    return true;
  }
}
