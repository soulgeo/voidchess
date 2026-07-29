import 'types.dart';

// ignore: constant_identifier_names
const __ = null;

class Board {
  List<List<Piece?>> _grid = [
    [bR, bN, bB, bQ, bK, bB, bN, bR],
    [bp, bp, bp, bp, bp, bp, bp, bp],
    [__, __, __, __, __, __, __, __],
    [__, __, __, __, __, __, __, __],
    [__, __, __, __, __, __, __, __],
    [__, __, __, __, __, __, __, __],
    [wp, wp, wp, wp, wp, wp, wp, wp],
    [wR, wN, wB, wQ, wK, wB, wN, wR],
  ];

  Board();
  Board.position(List<List<Piece?>> grid) {
    _grid = grid;
  }

  Board clone() {
    return Board.position(_grid.map((row) => List<Piece?>.from(row)).toList());
  }

  static bool isValidSquare(String square) {
    final RegExp exp = RegExp(r'^[a-h][1-8]$');
    return exp.hasMatch(square);
  }

  (int, int) _squareToCoords(String square) {
    final RegExp exp = RegExp(r'^[a-h][1-8]$');
    if (!exp.hasMatch(square)) {
      return (-1, -1);
    }
    final x = 8 - int.parse(square[1]);
    final y = square.codeUnitAt(0) - 97;
    return (x, y);
  }

  // OVERRIDE THE READ OPERATOR
  // This lets us do: Piece? p = board['e4'];
  Piece? operator [](String square) {
    final (row, col) = _squareToCoords(square);
    if (row == -1) return null; // Invalid square
    return _grid[row][col];
  }

  // OVERRIDE THE WRITE OPERATOR
  // This lets us do: board['e4'] = wp;
  void operator []=(String square, Piece? piece) {
    final (row, col) = _squareToCoords(square);
    if (row != -1) {
      _grid[row][col] = piece;
    }
  }

  void applyMove(Move move) {
    final piece = this[move.startSquare];
    this[move.startSquare] = null;
    this[move.endSquare] = piece;
  }
}
