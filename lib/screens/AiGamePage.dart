import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:developer' as developer;
import 'package:oxoai/screens/AiOrMulti.dart';

class TicTacToeScreen extends StatefulWidget {
  final String difficulty;

  const TicTacToeScreen({Key? key, required this.difficulty}) : super(key: key);

  @override
  _TicTacToeScreenState createState() => _TicTacToeScreenState();
}

class _TicTacToeScreenState extends State<TicTacToeScreen> {
  List<List<String>> _grid = List.generate(3, (_) => List.filled(3, ''));
  bool _isPlayerTurn = true;
  int playerScore = 0;
  int aiScore = 0;
  bool _isAiThinking = false;

  static const String _apiKey = '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'; 

  @override
  Widget build(BuildContext context) {
    // Keep your existing build method, but add an AI thinking indicator
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Column(
            children: [
                        // Top section for player and AI score
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
                        child: Center(
                          child: Text(
                            '$playerScore',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
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
                        child: Center(
                          child: Text(
                            '$aiScore',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
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


              // Update the grid section to show loading indicator when AI is thinking
              Flexible(
                flex: 3,
                child: Stack(
                  children: [
                    Center(
                      child: Container(
                        padding: const EdgeInsets.all(20.0),
                        child: GridView.builder(
                          physics: const NeverScrollableScrollPhysics(),
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
                                      color: _grid[row][col] == 'X'
                                          ? Colors.red
                                          : Colors.blue,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    if (_isAiThinking)
                      Container(
                        color: Colors.black54,
                        child: const Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CircularProgressIndicator(),
                              SizedBox(height: 16),
                              Text(
                                'AI is thinking...',
                                style: TextStyle(color: Colors.white, fontSize: 18),
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _makeAiMove() async {
    setState(() {
      _isAiThinking = true;
    });

    try {
      String gridString = _gridToString();
      String difficulty = widget.difficulty.toLowerCase();
      
      final response = await http.post(
        Uri.parse('https://api.openai.com/v1/chat/completions'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_apiKey',
        },
        body: jsonEncode({
          'model': 'gpt-3.5-turbo',
          'messages': [
            {
              'role': 'system',
              'content': '''You are playing Tic-Tac-Toe at ${widget.difficulty} difficulty. 
              You play as 'O', and the human plays as 'X'. 
              Respond only with two numbers: the row (0-2) and column (0-2) for your move.
              ${_getDifficultyInstruction()}'''
            },
            {
              'role': 'user',
              'content': 'Current board state (empty spaces are "", X for human, O for you):\n$gridString\nMake your move.'
            }
          ],
          'temperature': _getDifficultyTemperature(),
          'max_tokens': 50,
        }),
      );

      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(response.body);
        String aiResponse = jsonResponse['choices'][0]['message']['content'];
        
        // Parse the AI's move
        List<int> move = _parseAiMove(aiResponse);
        
        if (move.length == 2 && _isValidMove(move[0], move[1])) {
          setState(() {
            _grid[move[0]][move[1]] = 'O';
            _isPlayerTurn = true;
          });

          // Check for game end conditions
          if (checkWin(_grid, 'O')) {
            aiScore++;
            _showEndDialog('AI Won!');
          } else if (checkDraw(_grid)) {
            _showEndDialog('It\'s a Draw!');
          }
        } else {
          // If AI provides invalid move, make a random move
          _makeRandomMove();
        }
      } else {
        developer.log('API Error: ${response.statusCode} - ${response.body}');
        _makeRandomMove();
      }
    } catch (e) {
      developer.log('Error in AI move: $e');
      _makeRandomMove();
    } finally {
      setState(() {
        _isAiThinking = false;
      });
    }
  }

  String _getDifficultyInstruction() {
    switch (widget.difficulty.toLowerCase()) {
      case 'easy':
        return 'Make obvious mistakes and don\'t block the player\'s winning moves.';
      case 'medium':
        return 'Play at an intermediate level, occasionally making mistakes.';
      case 'difficult':
        return 'Play optimally, always choosing the best possible move.';
      default:
        return 'Play at an intermediate level.';
    }
  }

  double _getDifficultyTemperature() {
    switch (widget.difficulty.toLowerCase()) {
      case 'easy':
        return 1.0;
      case 'medium':
        return 0.7;
      case 'difficult':
        return 0.2;
      default:
        return 0.7;
    }
  }

  String _gridToString() {
    return _grid.map((row) => row.join(',')).join('\n');
  }

  List<int> _parseAiMove(String aiResponse) {
    try {
      // Extract numbers from the AI's response
      RegExp regex = RegExp(r'\d');
      List<int> numbers = regex.allMatches(aiResponse)
          .map((match) => int.parse(match.group(0)!))
          .take(2)
          .toList();
      
      if (numbers.length == 2) {
        return numbers;
      }
    } catch (e) {
      developer.log('Error parsing AI move: $e');
    }
    return [];
  }

  bool _isValidMove(int row, int col) {
    return row >= 0 && row < 3 && col >= 0 && col < 3 && _grid[row][col].isEmpty;
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
      availableMoves.shuffle();
      setState(() {
        _grid[availableMoves[0][0]][availableMoves[0][1]] = 'O';
      });
    }
  }

  // Update your _handleTapAtIndex method
  void _handleTapAtIndex(int row, int col) {
    if (_grid[row][col].isEmpty && _isPlayerTurn && !_isAiThinking) {
      setState(() {
        _grid[row][col] = 'X';
        _isPlayerTurn = false;
      });

      if (checkWin(_grid, 'X')) {
        playerScore++;
        _showEndDialog('You Won!');
      } else if (checkDraw(_grid)) {
        _showEndDialog('It\'s a Draw!');
      } else {
        _makeAiMove();
      }
    }
  }

  // Keep your existing helper methods (checkWin, checkDraw, _showEndDialog, _resetGrid)
  // ...
  bool checkWin(List<List<String>> board, String player) {
    // Check rows, columns, and diagonals
    for (int i = 0; i < 3; i++) {
      if ((board[i][0] == player &&
              board[i][1] == player &&
              board[i][2] == player) ||
          (board[0][i] == player &&
              board[1][i] == player &&
              board[2][i] == player)) {
        return true;
      }
    }
    if ((board[0][0] == player &&
            board[1][1] == player &&
            board[2][2] == player) ||
        (board[0][2] == player &&
            board[1][1] == player &&
            board[2][0] == player)) {
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
    void _showEndDialog(String title) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title, textAlign: TextAlign.center),
          content: const Text('Do you want to play again?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _resetGrid();
              },
              child: const Text('Yes'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          SingleOrMulti()), // Navigate to the AiOrMulti screen
                );
              },
              child: const Text('No'),
            ),
          ],
        );
      },
    );
  }
    void _resetGrid() {
    setState(() {
      _grid = List.generate(3, (_) => List.filled(3, ''));
      _isPlayerTurn = true;
    });
  }

}