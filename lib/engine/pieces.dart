enum Player { white, black }

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
