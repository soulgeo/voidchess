import 'util.dart';
import 'pieces.dart';
import 'board.dart';


class GameState {
  final _files = ['a', 'b', 'c', 'd', 'e', 'f', 'g', 'h'];

  var board = Board();
  var turnPlayer = Player.white;
  List<String> legalMoves = [];

  GameState();
  GameState.atPosition(this.turnPlayer, List<List<Piece?>> grid) {
    board = Board.position(grid);
  }
  
  bool hasFriendlyPiece(String sqr) => board[sqr]?.player == turnPlayer;

  void calculateLegalMoves() {
    for (String file in _files) {
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

    if (piece == wp && turnPlayer == Player.white) {
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
    } else if (piece == bp && turnPlayer == Player.black) {
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
    } else if (piece.type == PieceType.knight && piece.player == turnPlayer) {
      // Knight
      var shifts = [
        (-1, -2),
        (1, -2),
        (-1, 2),
        (1, 2),
        (-2, -1),
        (2, -1),
        (-2, 1),
        (2, 1),
      ];

      for (var (a, b) in shifts) {
        targetSquare = '${file.shiftFile(a)}${rank + b}';
        if (Board.isValidSquare(targetSquare) &&
            !hasFriendlyPiece(targetSquare)) {
          legalMoves.add('N_${square}_$targetSquare');
        }
      }
    } else if (piece.type == PieceType.rook && piece.player == turnPlayer) {
      //Rook
      //Moving Up
      for (int checkRank = rank + 1; checkRank <= 8; checkRank++) {
        targetSquare = '$file$checkRank';
        if (board[targetSquare] == null) {
          legalMoves.add('R_${square}_$targetSquare');
          continue;
        }
        if(!hasFriendlyPiece(targetSquare)) {
            legalMoves.add('R_${square}_$targetSquare');
            break;
        } else {
          break;
        }
      }
      //Moving Down
      for (int checkRank = rank - 1; checkRank >= 1; checkRank--) {
        targetSquare = '$file$checkRank';
        if (board[targetSquare] == null) {
          legalMoves.add('R_${square}_$targetSquare');
          continue;
        }
        if(!hasFriendlyPiece(targetSquare)) {
            legalMoves.add('R_${square}_$targetSquare');
            break;
        } else {
          break;
        }
      }
    }
  }
}