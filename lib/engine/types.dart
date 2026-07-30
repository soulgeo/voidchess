enum Player {
  white(1),
  black(-1);

  final int unit;
  const Player(this.unit);

  Player operator *(int multiplier) {
    final resultValue = unit * multiplier;
    
    return Player.values.firstWhere(
      (e) => e.unit == resultValue,
      orElse: () => throw ArgumentError('No enum matches that value.'),
    );
  }
}

enum PieceType { pawn, knight, bishop, rook, queen, king }

class Piece {
  final Player player;
  final PieceType type;

  const Piece(this.player, this.type);
}

const wp = Piece(Player.white, PieceType.pawn);
const wR = Piece(Player.white, PieceType.rook);
const wN = Piece(Player.white, PieceType.knight);
const wB = Piece(Player.white, PieceType.bishop);
const wQ = Piece(Player.white, PieceType.queen);
const wK = Piece(Player.white, PieceType.king);

const bp = Piece(Player.black, PieceType.pawn);
const bR = Piece(Player.black, PieceType.rook);
const bN = Piece(Player.black, PieceType.knight);
const bB = Piece(Player.black, PieceType.bishop);
const bQ = Piece(Player.black, PieceType.queen);
const bK = Piece(Player.black, PieceType.king);

class Move {
  final PieceType type;
  final String startSquare;
  final String endSquare;

  const Move(this.type, this.startSquare, this.endSquare);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Move &&
          runtimeType == other.runtimeType &&
          type == other.type &&
          startSquare == other.startSquare &&
          endSquare == other.endSquare;

  @override
  int get hashCode => Object.hash(type, startSquare, endSquare);

  @override
  String toString() => 'Move($type, $startSquare, $endSquare)';
}
