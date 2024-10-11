import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class MultiPlayerScreen extends StatefulWidget {
  const MultiPlayerScreen({super.key});

  @override
  _MultiPlayerScreenState createState() => _MultiPlayerScreenState();
}

class _MultiPlayerScreenState extends State<MultiPlayerScreen> {
  final List<List<String>> _grid = List.generate(3, (_) => List.filled(3, ''));
  bool _isPlayer1Turn = true;
  int _player1Score = 0;
  int _player2Score = 0;
  String? _aiSuggestion;
  bool _isLoading = false;

  List<String> _gameHistory = [];




  // Constants
  static const String _apiUrl = 'https://api.openai.com/v1/chat/completions';
  static const String _apiKey =
      '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';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Tic Tac Toe'),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: <Widget>[
          IconButton(
              icon: const Icon(Icons.history),
              tooltip: 'Show History',
              onPressed: _showHistoryModal)
        ],
      ),
      body: Column(
        children: [
          Expanded(
            flex: 1,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.red.withOpacity(0.7),
                    Colors.blue.withOpacity(0.7)
                  ],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildPlayerScore(
                      'Player 1 (X)', _player1Score, Colors.redAccent),
                  _buildPlayerScore(
                      'Player 2 (O)', _player2Score, Colors.blueAccent),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: AspectRatio(
                aspectRatio: 1,
                child: GridView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                  ),
                  itemCount: 9,
                  itemBuilder: _buildGridItem,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Column(
              children: [
                ElevatedButton.icon(
                  onPressed: _isLoading ? null : _getAIHelp,
                  icon: _isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(color: Colors.white))
                      : const Icon(Icons.lightbulb_outline),
                  label: Text(_isLoading ? 'Getting help...' : 'Get AI Help'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 12),
                    backgroundColor: Colors.blue,
                  ),
                ),
                if (_aiSuggestion != null)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'AI Suggestion: $_aiSuggestion',
                      style: const TextStyle(color: Colors.white70),
                      textAlign: TextAlign.center,
                    ),
                  ),
              ],
            ),
          ),
          Padding(
  padding: const EdgeInsets.symmetric(vertical: 16.0),
  child: Row(
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    children: [
      ElevatedButton.icon(
        onPressed: () {
          _saveGameState(context);  // Pass context to the function
        },
        icon: const Icon(Icons.save),
        label: const Text('Save'),
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          backgroundColor: Colors.green,
        ),
      ),
      ElevatedButton.icon(
        onPressed: () {
          _loadGameState(context);  // Pass context to the function
        },
        icon: const Icon(Icons.play_arrow),
        label: const Text('Continue'),
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          backgroundColor: Colors.orange,
        ),
      ),
      // ElevatedButton.icon(
      //   onPressed: () {
      //     _clearSavedGame(context);  // Pass context to the function
      //   },
      //   icon: const Icon(Icons.clear),
      //   label: const Text('Clear Game'),
      //   style: ElevatedButton.styleFrom(
      //     padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      //     backgroundColor: Colors.red,
      //   ),
      // ),
    ],
  ),
),

          TextButton(
            onPressed: _resetGame,
            child: const Text('Reset Game'),
          ),
        ],
        
      ),
    );
  }
void _showPopup(BuildContext context, String message) {
  OverlayEntry overlayEntry;
  
  overlayEntry = OverlayEntry(
    builder: (context) => Positioned(
      top: MediaQuery.of(context).size.height / 2 - 50, // Center vertically
      left: MediaQuery.of(context).size.width / 2 - 100, // Center horizontally
      child: Material(
        color: Colors.transparent,
        child: Container(
          width: 200,
          height: 100,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.8),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            message,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
        ),
      ),
    ),
  );

  Overlay.of(context).insert(overlayEntry);

  // Remove the popup after 1.5 seconds
  Future.delayed(const Duration(seconds: 1, milliseconds: 500), () {
    overlayEntry.remove();
  });
}

  Widget _buildGridItem(BuildContext context, int index) {
    int row = index ~/ 3;
    int col = index % 3;

    return GestureDetector(
      onTap: () => _handleTapAtIndex(row, col),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: Text(
            _grid[row][col],
            style: TextStyle(
              fontSize: 48,
              fontWeight: FontWeight.bold,
              color: _grid[row][col] == 'X' ? Colors.red : Colors.blue,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPlayerScore(String player, int score, Color color) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          player,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          width: 60,
          height: 40,
          decoration: BoxDecoration(
            color: color.withOpacity(0.3),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: Text(
              '$score',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _handleTapAtIndex(int row, int col) {
    if (_grid[row][col].isEmpty) {
      setState(() {
        _grid[row][col] = _isPlayer1Turn ? 'X' : 'O';
        _isPlayer1Turn = !_isPlayer1Turn;
        _aiSuggestion = null; // Clear previous suggestion
      });

      String? winner = _checkWin();
      if (winner != null) {
        _updateScore(winner);
        _showGameOverDialog(winner);
      } else if (_isGridFull()) {
        _showGameOverDialog('Draw');
      }
    }
  }
// Method to save the current game state
Future<void> _saveGameState(BuildContext context) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  
  // Save the grid, player turn, and scores as strings
  String gridState = _grid.map((row) => row.join(',')).join('|');
  await prefs.setString('grid', gridState);
  await prefs.setBool('isPlayer1Turn', _isPlayer1Turn);
  await prefs.setInt('player1Score', _player1Score);
  await prefs.setInt('player2Score', _player2Score);
  await prefs.setStringList('gameHistory', _gameHistory);

  // Show pop-up
  _showPopup(context, 'Game saved!');
}

// Method to load the saved game state
Future<void> _loadGameState(BuildContext context) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  
  String? gridState = prefs.getString('grid');
  if (gridState != null) {
    setState(() {
      List<String> rows = gridState.split('|');
      for (int i = 0; i < 3; i++) {
        _grid[i] = rows[i].split(',');
      }
      _isPlayer1Turn = prefs.getBool('isPlayer1Turn') ?? true;
      _player1Score = prefs.getInt('player1Score') ?? 0;
      _player2Score = prefs.getInt('player2Score') ?? 0;
      _gameHistory = prefs.getStringList('gameHistory') ?? [];
    });
    _showPopup(context, 'Game loaded!');
  } else {
    _showPopup(context, 'No saved game found!');
  }
}

// Method to clear the saved game state
Future<void> _clearSavedGame(BuildContext context) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.remove('grid');
  await prefs.remove('isPlayer1Turn');
  await prefs.remove('player1Score');
  await prefs.remove('player2Score');
  await prefs.remove('gameHistory');
  
  _showPopup(context, 'Game cleared!');
}



  Future<void> _getAIHelp() async {
    setState(() {
      _isLoading = true;
      _aiSuggestion = null;
    });

    try {
      String gridString = _grid.map((row) => row.join(',')).join('|');

      final response = await http.post(
        Uri.parse(_apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_apiKey',
        },
        body: jsonEncode({
          'model': 'gpt-3.5-turbo',
          'messages': [
            {
              'role': 'system',
              'content':
                  'Analyze the Tic-Tac-Toe state and suggest the best move. Respond with the position, e.g., "2nd row, 2nd column.'
            },
            {
              'role': 'user',
              'content':
                  'Current game state: $gridString. What\'s the best move for ${_isPlayer1Turn ? "X" : "O"}?',
            },
          ],
        }),
      );

      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(response.body);
        setState(() {
          _aiSuggestion = jsonResponse['choices'][0]['message']['content'];
        });
      } else {
        throw Exception('Failed to get AI help');
      }
    } catch (e) {
      setState(() {
        _aiSuggestion = "Error: Unable to get AI suggestion.";
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _updateScore(String winner) {
    setState(() {
      if (winner == 'X') {
        _player1Score++;
      } else if (winner == 'O') {
        _player2Score++;
      }
    });
  }

  bool _isGridFull() {
    return !_grid.any((row) => row.contains(''));
  }

  String? _checkWin() {
    // Check rows, columns and diagonals
    for (int i = 0; i < 3; i++) {
      if (_grid[i][0] != '' &&
          _grid[i][0] == _grid[i][1] &&
          _grid[i][1] == _grid[i][2]) {
        return _grid[i][0];
      }
      if (_grid[0][i] != '' &&
          _grid[0][i] == _grid[1][i] &&
          _grid[1][i] == _grid[2][i]) {
        return _grid[0][i];
      }
    }

    if (_grid[0][0] != '' &&
        _grid[0][0] == _grid[1][1] &&
        _grid[1][1] == _grid[2][2]) {
      return _grid[0][0];
    }
    if (_grid[0][2] != '' &&
        _grid[0][2] == _grid[1][1] &&
        _grid[1][1] == _grid[2][0]) {
      return _grid[0][2];
    }

    return null;
  }

  void _showGameOverDialog(String result) {
    String message = result == 'Draw'
        ? "It's a Draw!"
        : "Player ${result == 'X' ? '1' : '2'} Wins!";

    String messageHistoric = result == 'Draw'
        ? "It's a Draw!"
        : "Player ${result == 'X' ? '1' : '2'} Winned!";

    _gameHistory.add(messageHistoric);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.grey[900],
          title: Text(
            message,
            style: const TextStyle(color: Colors.white),
          ),
          content: const Text(
            'Would you like to play again?',
            style: TextStyle(color: Colors.white70),
          ),
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
                _resetGame();
              },
              child: const Text('Reset Score'),
            ),
          ],
        );
      },
    );
  }

  void _resetGrid() {
    setState(() {
      for (int i = 0; i < 3; i++) {
        for (int j = 0; j < 3; j++) {
          _grid[i][j] = '';
        }
      }
      _aiSuggestion = null;
    });
  }

  void _resetGame() {
    setState(() {
      _resetGrid();
      _player1Score = 0;
      _player2Score = 0;
    });
  }

  void _showHistoryModal() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          color: Colors.grey[900],
          child: ListView(
            children: _gameHistory.isEmpty
                ? [
                    const ListTile(
                        title: Text('No history',
                            style: TextStyle(color: Colors.white)))
                  ]
                : _gameHistory
                    .map((result) => ListTile(
                          title: Text(result,
                              style: TextStyle(color: Colors.white)),
                        ))
                    .toList(),
          ),
        );
      },
    );
  }
}
