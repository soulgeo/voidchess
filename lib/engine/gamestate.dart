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
        _pieceLegalMoves(file, rank);
      }
    }
  }

  void _pieceLegalMoves(String file, int rank) {
    final square = '$file$rank';
    final piece = board[square];

    if (piece == null) { return; }
    if (piece.player != turnPlayer) { return; }

    if (piece.type == PieceType.pawn) {
      _pawnMoves(file, rank, turnPlayer);
    } else if (piece.type == PieceType.knight) {
      _knightMoves(file, rank);
    } else if (piece.type == PieceType.rook) {
      _rookMoves(file, rank);
    } else if (piece.type == PieceType.bishop) {
      _bishopMoves(file, rank);
    } else if (piece.type == PieceType.queen) {
      _queenMoves(file, rank);
    }
  }

  String _pieceToInitial(PieceType type) {
    if (type == PieceType.pawn) return 'p';
    if (type == PieceType.knight) return 'N';
    if (type == PieceType.bishop) return 'B';
    if (type == PieceType.rook) return 'R';
    if (type == PieceType.queen) return 'Q';
    return 'K';
  }

  void _addLegalMove(PieceType type, String startSquare, String endSquare) {
    legalMoves.add('${_pieceToInitial(type)}_${startSquare}_$endSquare');
  }

  bool _isLegalMove(String piece, String targetSquare, String square) {
    if (board[targetSquare] == null ) {
      legalMoves.add('${piece}_${square}_$targetSquare');
      return true;
    }
    if(hasFriendlyPiece(targetSquare)) {
      return false;
    } else {  // Has Enemy Piece
      legalMoves.add('${piece}_${square}_$targetSquare');
      return false;
    }
  }

  void _pawnMoves(String file, int rank, Player player) {
    final square = '$file$rank';
    if (player == Player.white) {
      var targetSquare = '$file${rank + 1}';
      if (board[targetSquare] == null) {
        _addLegalMove(PieceType.pawn, square, targetSquare);
        if (rank == 2) {
          targetSquare = '$file${rank + 2}';
          if (board[targetSquare] == null) {
            _addLegalMove(PieceType.pawn, square, targetSquare);
          }
        }
      }
      targetSquare = '${file.shiftFile(-1)}${rank + 1}';
      if (board[targetSquare]?.player == Player.black) {
        _addLegalMove(PieceType.pawn, square, targetSquare);
      }
      targetSquare = '${file.shiftFile(1)}${rank + 1}';
      if (board[targetSquare]?.player == Player.black) {
        _addLegalMove(PieceType.pawn, square, targetSquare);
      }
    } else {
      var targetSquare = '$file${rank - 1}';
      if (board[targetSquare] == null) {
        _addLegalMove(PieceType.pawn, square, targetSquare);
        if (rank == 7) {
          targetSquare = '$file${rank - 2}';
          if (board[targetSquare] == null) {
            _addLegalMove(PieceType.pawn, square, targetSquare);
          }
        }
      }
      targetSquare = '${file.shiftFile(-1)}${rank - 1}';
      if (board[targetSquare]?.player == Player.white) {
        _addLegalMove(PieceType.pawn, square, targetSquare);
      }
      targetSquare = '${file.shiftFile(1)}${rank - 1}';
      if (board[targetSquare]?.player == Player.white) {
        _addLegalMove(PieceType.pawn, square, targetSquare);
      }
    }
  }

  void _knightMoves(String file, int rank) {
    final square = '$file$rank';
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

    var targetSquare = '';
    for (var (a, b) in shifts) {
      targetSquare = '${file.shiftFile(a)}${rank + b}';
      if (Board.isValidSquare(targetSquare) &&
          !hasFriendlyPiece(targetSquare)) {
        _addLegalMove(PieceType.knight, square, targetSquare);
      }
    }
  }

  void _rookMoves(String file, int rank) {
    // Up
    final square = '$file$rank';
    var targetSquare = '';
    for (int checkRank = rank + 1; checkRank <= 8; checkRank++) {
      targetSquare = '$file$checkRank';
      if(!_isLegalMove('R', targetSquare, square)) {
        break;
      }
    }
    //Down
    for (int checkRank = rank - 1; checkRank >= 1; checkRank--) {
      targetSquare = '$file$checkRank';
      if(!_isLegalMove('R', targetSquare, square)) {
        break;
      }
    }
    //Right
    for (int filePos = _files.indexOf(file) + 1; filePos < _files.length; filePos++) {
      targetSquare = '${_files[filePos]}$rank';
      if(!_isLegalMove('R', targetSquare, square)) {
        break;
      }
    } 
    //Left
    for (int filePos = _files.indexOf(file) - 1; filePos >= 0; filePos--) {
      targetSquare = '${_files[filePos]}$rank';
      if(!_isLegalMove('R', targetSquare, square)) {
        break;
      }
    } 
  }

  void _bishopMoves(String file, int rank) {
    final square = '$file$rank';
    var targetSquare = '';

    //Top-Right
    int checkRank = rank;
    for (int filePos = _files.indexOf(file) + 1; filePos < _files.length; filePos++) {
      checkRank++;
      if (checkRank > 8) {
        break;
      }
      targetSquare = '${_files[filePos]}$checkRank';
      if(!_isLegalMove('B', targetSquare, square)) {
        break;
      }
    }
    //Bottom-Right
    checkRank = rank;
    for (int filePos = _files.indexOf(file) + 1; filePos < _files.length; filePos++) {
      checkRank--;
      if (checkRank <= 0) {
        break;
      }
      targetSquare = '${_files[filePos]}$checkRank';
      if(!_isLegalMove('B', targetSquare, square)) {
        break;
      }
    }
    //Top-Left
    checkRank = rank;
    for (int filePos = _files.indexOf(file) - 1; filePos >= 0; filePos--) {
      checkRank++;
      if (checkRank > 8) {
        break;
      }
      targetSquare = '${_files[filePos]}$checkRank';
      if(!_isLegalMove('B', targetSquare, square)) {
        break;
      }
    }
    //Bottom-Left
    checkRank = rank;
    for (int filePos = _files.indexOf(file) - 1; filePos >= 0; filePos--) {
      checkRank--;
      if (checkRank <= 0) {
        break;
      }
      targetSquare = '${_files[filePos]}$checkRank';
      if(!_isLegalMove('B', targetSquare, square)) {
        break;
      }
    }
  }

  void _queenMoves(String file, int rank) {
    final square = '$file$rank';
    var targetSquare = '';
    //Right Top-Right
    int checkRank = rank;
    bool stopVertical, stopHorizontal = false, stopDiagonal = false;
    for (int filePos = _files.indexOf(file) + 1; filePos < _files.length; filePos++) {
      //horizontal right
      if(!stopHorizontal) {
        targetSquare = '${_files[filePos]}$rank';
        if(!_isLegalMove('Q', targetSquare, square)) {
          stopHorizontal = true;
        }
      }
      //diagonal top right
      checkRank++;
      if (checkRank > 8) {
        continue;
      }
      if(!stopDiagonal) {
        targetSquare = '${_files[filePos]}$checkRank';
        if(!_isLegalMove('Q', targetSquare, square)) {
          stopDiagonal = true; 
        }
      }
      if (stopHorizontal && stopDiagonal) {
        break;
      }
    }
    checkRank = rank;
    stopVertical = false; 
    stopDiagonal = false;
    for (int checkRank = rank + 1; checkRank <= 8; checkRank++) {
      //vertical up
      if(!stopVertical) {
        targetSquare = '$file$checkRank';
        if(!_isLegalMove('Q', targetSquare, square)) {
          stopVertical = true;
        }
      }
      //diagonal top left
      targetSquare = '${file.shiftFile(rank-checkRank)}$checkRank';
      if (!Board.isValidSquare(targetSquare)) {
        continue;
      }
      if(!stopDiagonal) {
        if(!_isLegalMove('Q', targetSquare, square)) {
          stopDiagonal = true; 
        }
      }
      if (stopVertical && stopDiagonal) {
        break;
      }
    }
    checkRank = rank; 
    stopHorizontal = false; 
    stopDiagonal = false;
    for (int filePos = _files.indexOf(file) - 1; filePos >= 0; filePos--) {    
      //horizontal left
      if(!stopHorizontal) {
        targetSquare = '${_files[filePos]}$rank';
        if(!_isLegalMove('Q', targetSquare, square)) {
          stopHorizontal = true;
        }
      }
      //diagonal bottom left
      checkRank--;
      if (checkRank <= 0) {
        continue;
      }
      if(!stopDiagonal) {
        targetSquare = '${_files[filePos]}$checkRank';
        if(!_isLegalMove('Q', targetSquare, square)) {
          stopDiagonal = true; 
        }
      }
      if (stopHorizontal && stopDiagonal) {
        break;
      }
    }
    checkRank = rank;
    stopVertical = false; 
    stopDiagonal = false;
    for (int checkRank = rank - 1; checkRank > 0; checkRank--) {
      //vertical down
      if(!stopVertical) {
        targetSquare = '$file$checkRank';
        if(!_isLegalMove('Q', targetSquare, square)) {
          stopVertical = true;
        }
      }
      //diagonal bottom right
      targetSquare = '${file.shiftFile(rank-checkRank)}$checkRank';
      if (!Board.isValidSquare(targetSquare)) {
        continue;
      }
      if(!stopDiagonal) {  
        if(!_isLegalMove('Q', targetSquare, square) || !Board.isValidSquare(targetSquare)) {
          stopDiagonal = true; 
        }
      }
      if (stopVertical && stopDiagonal) {
        break;
      }
    }
  }
}
