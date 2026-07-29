import 'util.dart';
import 'types.dart';
import 'board.dart';


class GameState {
  final _files = [
    ChessFile('a'), ChessFile('b'), ChessFile('c'), ChessFile('d'),
    ChessFile('e'), ChessFile('f'), ChessFile('g'), ChessFile('h')
  ];

  var board = Board();
  var turnPlayer = Player.white;
  List<Move> legalMoves = [];

  GameState();
  GameState.atPosition(this.turnPlayer, List<List<Piece?>> grid) {
    board = Board.position(grid);
  }
  
  bool hasFriendlyPiece(String sqr) => board[sqr]?.player == turnPlayer;

  void calculateLegalMoves() {
    for (var file in _files) {
      for (int rank = 1; rank <= 8; rank++) {
        _pieceLegalMoves(file, rank);
      }
    }
  }

  void _pieceLegalMoves(ChessFile file, int rank) {
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

  void _addLegalMove(PieceType type, String startSquare, String endSquare) {
    legalMoves.add(Move(type, startSquare, endSquare));
  }

  bool _addDirectionalMove(PieceType type, String targetSquare, String square) {
    var validTypes = [PieceType.queen, PieceType.rook, PieceType.bishop];
    if (!validTypes.contains(type)) {
      throw ArgumentError("Invalid piece type for directional move");
    }
    if (board[targetSquare] == null ) {
      _addLegalMove(type, square, targetSquare);
      return true;
    }
    if(hasFriendlyPiece(targetSquare)) {
      return false;
    } else {  // Has Enemy Piece
      _addLegalMove(type, square, targetSquare);
      return false;
    }
  }

  void _pawnMoves(ChessFile file, int rank, Player player) {
    final square = '$file$rank';
    var targetSquare = '$file${rank + turnPlayer.number}';
    if (board[targetSquare] == null) {
      _addLegalMove(PieceType.pawn, square, targetSquare);
      if (rank*turnPlayer.number == 2 || rank*turnPlayer.number == -7) {
        targetSquare = '$file${rank + 2*turnPlayer.number}';
        if (board[targetSquare] == null) {
          _addLegalMove(PieceType.pawn, square, targetSquare);
        }
      }
    }
    targetSquare = '${file - 1}${rank + turnPlayer.number}';
    if (board[targetSquare]?.player == turnPlayer*(-1)) {
      _addLegalMove(PieceType.pawn, square, targetSquare);
    }
    targetSquare = '${file + 1}${rank + turnPlayer.number}';
    if (board[targetSquare]?.player == turnPlayer*(-1)) {
      _addLegalMove(PieceType.pawn, square, targetSquare);
    }
  }

  void _knightMoves(ChessFile file, int rank) {
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
      targetSquare = '${file + a}${rank + b}';
      if (Board.isValidSquare(targetSquare) &&
          !hasFriendlyPiece(targetSquare)) {
        _addLegalMove(PieceType.knight, square, targetSquare);
      }
    }
  }

  void _rookMoves(ChessFile file, int rank) {
    // Up
    final square = '$file$rank';
    var targetSquare = '';
    for (int checkRank = rank + 1; checkRank <= 8; checkRank++) {
      targetSquare = '$file$checkRank';
      if(!_addDirectionalMove(PieceType.rook, targetSquare, square)) {
        break;
      }
    }
    //Down
    for (int checkRank = rank - 1; checkRank >= 1; checkRank--) {
      targetSquare = '$file$checkRank';
      if(!_addDirectionalMove(PieceType.rook, targetSquare, square)) {
        break;
      }
    }
    //Right
    for (int filePos = _files.indexOf(file) + 1; filePos < _files.length; filePos++) {
      targetSquare = '${_files[filePos]}$rank';
      if(!_addDirectionalMove(PieceType.rook, targetSquare, square)) {
        break;
      }
    } 
    //Left
    for (int filePos = _files.indexOf(file) - 1; filePos >= 0; filePos--) {
      targetSquare = '${_files[filePos]}$rank';
      if(!_addDirectionalMove(PieceType.rook, targetSquare, square)) {
        break;
      }
    } 
  }

  void _bishopMoves(ChessFile file, int rank) {
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
      if(!_addDirectionalMove(PieceType.bishop, targetSquare, square)) {
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
      if(!_addDirectionalMove(PieceType.bishop, targetSquare, square)) {
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
      if(!_addDirectionalMove(PieceType.bishop, targetSquare, square)) {
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
      if(!_addDirectionalMove(PieceType.bishop, targetSquare, square)) {
        break;
      }
    }
  }

  void _queenMoves(ChessFile file, int rank) {
    final square = '$file$rank';
    var targetSquare = '';
    //Right Top-Right
    int checkRank = rank;
    bool stopVertical, stopHorizontal = false, stopDiagonal = false;
    for (int filePos = _files.indexOf(file) + 1; filePos < _files.length; filePos++) {
      //horizontal right
      if(!stopHorizontal) {
        targetSquare = '${_files[filePos]}$rank';
        if(!_addDirectionalMove(PieceType.queen, targetSquare, square)) {
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
        if(!_addDirectionalMove(PieceType.queen, targetSquare, square)) {
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
        if(!_addDirectionalMove(PieceType.queen, targetSquare, square)) {
          stopVertical = true;
        }
      }
      //diagonal top left
      targetSquare = '${file + (rank-checkRank)}$checkRank';
      if (!Board.isValidSquare(targetSquare)) {
        continue;
      }
      if(!stopDiagonal) {
        if(!_addDirectionalMove(PieceType.queen, targetSquare, square)) {
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
        if(!_addDirectionalMove(PieceType.queen, targetSquare, square)) {
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
        if(!_addDirectionalMove(PieceType.queen, targetSquare, square)) {
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
        if(!_addDirectionalMove(PieceType.queen, targetSquare, square)) {
          stopVertical = true;
        }
      }
      //diagonal bottom right
      targetSquare = '${file + (rank-checkRank)}$checkRank';
      if (!Board.isValidSquare(targetSquare)) {
        continue;
      }
      if(!stopDiagonal) {  
        if(!_addDirectionalMove(PieceType.queen, targetSquare, square) || !Board.isValidSquare(targetSquare)) {
          stopDiagonal = true; 
        }
      }
      if (stopVertical && stopDiagonal) {
        break;
      }
    }
  }
}
