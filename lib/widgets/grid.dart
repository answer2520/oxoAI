import 'package:flutter/material.dart';

class TicTacToePainter extends CustomPainter {
  final List<List<String>> grid;

  TicTacToePainter(this.grid);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..strokeWidth = 4;

    // Draw the Tic-Tac-Toe grid lines
    double cellSize = size.width / 3;
    for (int i = 1; i < 3; i++) {
      // Horizontal lines
      canvas.drawLine(
          Offset(0, cellSize * i), Offset(size.width, cellSize * i), paint);
      // Vertical lines
      canvas.drawLine(
          Offset(cellSize * i, 0), Offset(cellSize * i, size.height), paint);
    }

    // Draw the X's and O's
    for (int row = 0; row < 3; row++) {
      for (int col = 0; col < 3; col++) {
        if (grid[row][col] == 'X') {
          _drawX(canvas, size, row, col);
        } else if (grid[row][col] == 'O') {
          _drawO(canvas, size, row, col);
        }
      }
    }
  }

  void _drawX(Canvas canvas, Size size, int row, int col) {
    final paint = Paint()
      ..color = Colors.redAccent
      ..strokeWidth = 8;

    double cellSize = size.width / 3;
    double padding = 20.0;

    Offset start1 = Offset(col * cellSize + padding, row * cellSize + padding);
    Offset end1 =
        Offset((col + 1) * cellSize - padding, (row + 1) * cellSize - padding);

    Offset start2 =
        Offset((col + 1) * cellSize - padding, row * cellSize + padding);
    Offset end2 =
        Offset(col * cellSize + padding, (row + 1) * cellSize - padding);

    canvas.drawLine(start1, end1, paint);
    canvas.drawLine(start2, end2, paint);
  }

  void _drawO(Canvas canvas, Size size, int row, int col) {
    final paint = Paint()
      ..color = Colors.blueAccent
      ..strokeWidth = 8;

    double cellSize = size.width / 3;
    double padding = 20.0;

    Offset center = Offset((col + 0.5) * cellSize, (row + 0.5) * cellSize);
    double radius = (cellSize / 2) - padding;

    canvas.drawCircle(center, radius, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
