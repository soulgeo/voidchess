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
    final piece = board[square];
    var targetSquare = '';

    if (piece == null) {
      return;
    }

    if (piece == wp) {
      // White pawn
      targetSquare = '$file${rank + 1}';
      if (board[targetSquare] == null) {
        legalMoves.add('p_${square}_$targetSquare');
        if (rank == 2) {
          targetSquare = '$file${rank + 2}';
          if (board[targetSquare] == null) {
            legalMoves.add('p_${square}_$targetSquare');
          }
        }
      }
    } else if (piece == bp) {
      // Black pawn
      targetSquare = '$file${rank - 1}';
      if (board[targetSquare] == null) {
        legalMoves.add('p_${square}_$targetSquare');
        if (rank == 7) {
          targetSquare = '$file${rank - 2}';
          if (board[targetSquare] == null) {
            legalMoves.add('p_${square}_$targetSquare');
          }
        }
      }
    } else if (piece.type == PieceType.knight) {
      // Knight
      bool hasFriendlyPiece(sqr) =>
          board[sqr]?.player == turnPlayer;

      targetSquare = '${file.shiftFile(-1)}${rank - 2}';
      if (Board.isValidSquare(targetSquare) && !hasFriendlyPiece(targetSquare)) {
        legalMoves.add('N_${square}_$targetSquare');
      }
      targetSquare = '${file.shiftFile(1)}${rank - 2}';
      if (Board.isValidSquare(targetSquare) && !hasFriendlyPiece(targetSquare)) {
        legalMoves.add('N_${square}_$targetSquare');
      }
      targetSquare = '${file.shiftFile(-1)}${rank + 2}';
      if (Board.isValidSquare(targetSquare) && !hasFriendlyPiece(targetSquare)) {
        legalMoves.add('N_${square}_$targetSquare');
      }
      targetSquare = '${file.shiftFile(1)}${rank + 2}';
      if (Board.isValidSquare(targetSquare) && !hasFriendlyPiece(targetSquare)) {
        legalMoves.add('N_${square}_$targetSquare');
      }
      targetSquare = '${file.shiftFile(-2)}${rank - 1}';
      if (Board.isValidSquare(targetSquare) && !hasFriendlyPiece(targetSquare)) {
        legalMoves.add('N_${square}_$targetSquare');
      }
      targetSquare = '${file.shiftFile(2)}${rank - 1}';
      if (Board.isValidSquare(targetSquare) && !hasFriendlyPiece(targetSquare)) {
        legalMoves.add('N_${square}_$targetSquare');
      }
      targetSquare = '${file.shiftFile(-2)}${rank + 1}';
      if (Board.isValidSquare(targetSquare) && !hasFriendlyPiece(targetSquare)) {
        legalMoves.add('N_${square}_$targetSquare');
      }
      targetSquare = '${file.shiftFile(2)}${rank + 1}';
      if (Board.isValidSquare(targetSquare) && !hasFriendlyPiece(targetSquare)) {
        legalMoves.add('N_${square}_$targetSquare');
      }
    }
  }
}
