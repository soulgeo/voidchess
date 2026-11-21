import 'package:voidchess/engine/util.dart';

import 'types.dart';

// ignore: constant_identifier_names
const __ = null;

class Board {
  List<List<Piece?>> _grid = [
    [bR, bN, bB, bQ, bK, bB, bN, bR], // 8
    [bp, bp, bp, bp, bp, bp, bp, bp], // 7
    [__, __, __, __, __, __, __, __], // 6
    [__, __, __, __, __, __, __, __], // 5
    [__, __, __, __, __, __, __, __], // 4
    [__, __, __, __, __, __, __, __], // 3
    [wp, wp, wp, wp, wp, wp, wp, wp], // 2
    [wR, wN, wB, wQ, wK, wB, wN, wR], // 1
  //  a   b   c   d   e   f   g   h
  ];

  Board();
  Board.position(List<List<Piece?>> grid) {
    _grid = grid;
  }

  List<List<Piece?>> get grid => _grid;

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

  // usage: Piece? p = board['e4'];
  Piece? operator [](String square) {
    final (row, col) = _squareToCoords(square);
    if (row == -1) return null; // Invalid square
    return _grid[row][col];
  }

  // usage: board['e4'] = wp;
  void operator []=(String square, Piece? piece) {
    final (row, col) = _squareToCoords(square);
    if (row != -1) {
      _grid[row][col] = piece;
    }
  }

  void applyMove(Move move) {
    final piece = this[move.startSquare];

    // En passant capture
    if (piece?.type == PieceType.pawn &&
        move.startSquare[0] != move.endSquare[0] &&
        this[move.endSquare] == null) {
      // Remove pawn captured en passant
      final capturedSquare = '${move.endSquare[0]}${move.startSquare[1]}';
      this[capturedSquare] = null;
    }

    // Castling
    final startFile = ChessFile(move.startSquare[0]);
    final endFile = ChessFile(move.endSquare[0]);
    final rank = move.startSquare[1];
    if (piece?.type == PieceType.king && endFile.value == startFile + 2) {
      // Perform short castle
      final rook = this['h$rank'];
      this['h$rank'] = null;
      this['f$rank'] = rook;
    }
    if (piece?.type == PieceType.king && endFile.value == startFile - 2) {
      // Perform long castle
      final rook = this['a$rank'];
      this['a$rank'] = null;
      this['d$rank'] = rook;
    }

    // Promotion
    if (move.promotingType != null) {
      this[move.startSquare] = null;
      this[move.endSquare] = pieces[piece?.player]?[move.promotingType];
    }

    // Other moves
    this[move.startSquare] = null;
    this[move.endSquare] = piece;
  }
}
