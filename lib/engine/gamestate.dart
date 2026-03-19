import 'util.dart';
import 'pieces.dart';
import 'board.dart';

class GameState {
  static const files = ['a', 'b', 'c', 'd', 'e', 'f', 'g', 'h'];

  var board = Board();
  var turnPlayer = Player.white;
  List<String> legalMoves = [];

  GameState();
  GameState.atPosition(this.turnPlayer, List<List<Piece?>> grid) {
    board = Board.position(grid);
  }

  void calculateLegalMoves() {
    for (String file in files) {
      for (int rank = 1; rank <= 8; rank++) {
        pieceLegalMoves(file, rank);
      }
    }
  }

  void pieceLegalMoves(String file, int rank) {
    final square = '$file$rank';
    var newSquare = '';

    if (board[square] == null) {
      return;
    }

    if (board[square] == wp) {
      // White pawn
      newSquare = '$file${rank + 1}';
      if (board[newSquare] == null) {
        legalMoves.add('p_${square}_$newSquare');
        if (rank == 2) {
          newSquare = '$file${rank + 2}';
          if (board[newSquare] == null) {
            legalMoves.add('p_${square}_$newSquare');
          }
        }
      }
    } else if (board[square] == bp) {
      // Black pawn
      newSquare = '$file${rank - 1}';
      if (board[newSquare] == null) {
        legalMoves.add('p_${square}_$newSquare');
        if (rank == 7) {
          newSquare = '$file${rank - 2}';
          if (board[newSquare] == null) {
            legalMoves.add('p_${square}_$newSquare');
          }
        }
      }
    } else if (board[square]?.type == PieceType.knight) {
      // Knight
      bool hasFriendlyPiece(targetSquare) =>
          board[targetSquare]?.player == turnPlayer;

      newSquare = '${file.shiftFile(-1)}${rank - 2}';
      if (Board.isValidSquare(newSquare) && !hasFriendlyPiece(newSquare)) {
        legalMoves.add('N_${square}_$newSquare');
      }
      newSquare = '${file.shiftFile(1)}${rank - 2}';
      if (Board.isValidSquare(newSquare) && !hasFriendlyPiece(newSquare)) {
        legalMoves.add('N_${square}_$newSquare');
      }
      newSquare = '${file.shiftFile(-1)}${rank + 2}';
      if (Board.isValidSquare(newSquare) && !hasFriendlyPiece(newSquare)) {
        legalMoves.add('N_${square}_$newSquare');
      }
      newSquare = '${file.shiftFile(1)}${rank + 2}';
      if (Board.isValidSquare(newSquare) && !hasFriendlyPiece(newSquare)) {
        legalMoves.add('N_${square}_$newSquare');
      }
      newSquare = '${file.shiftFile(-2)}${rank - 1}';
      if (Board.isValidSquare(newSquare) && !hasFriendlyPiece(newSquare)) {
        legalMoves.add('N_${square}_$newSquare');
      }
      newSquare = '${file.shiftFile(2)}${rank - 1}';
      if (Board.isValidSquare(newSquare) && !hasFriendlyPiece(newSquare)) {
        legalMoves.add('N_${square}_$newSquare');
      }
      newSquare = '${file.shiftFile(-2)}${rank + 1}';
      if (Board.isValidSquare(newSquare) && !hasFriendlyPiece(newSquare)) {
        legalMoves.add('N_${square}_$newSquare');
      }
      newSquare = '${file.shiftFile(2)}${rank + 1}';
      if (Board.isValidSquare(newSquare) && !hasFriendlyPiece(newSquare)) {
        legalMoves.add('N_${square}_$newSquare');
      }
    }
  }
}
