import 'util.dart';
import 'types.dart';
import 'board.dart';

class GameState {
  final _files = [
    ChessFile('a'),
    ChessFile('b'),
    ChessFile('c'),
    ChessFile('d'),
    ChessFile('e'),
    ChessFile('f'),
    ChessFile('g'),
    ChessFile('h'),
  ];

  var board = Board();
  var turnPlayer = Player.white;
  List<Move> whiteMoves = [];
  List<Move> blackMoves = [];

  List<Move> candidateMoves = [];
  List<Move> legalMoves = [];

  bool _isCalculatingCheck = false;

  GameState() {
    _calcAllLegalMoves();
  }
  GameState.raw(this.turnPlayer, this.board, {bool isCalculatingCheck = false})
      : _isCalculatingCheck = isCalculatingCheck;

  bool isKingInCheck([Player? player]) {
    if (_isCalculatingCheck) return false;
    final targetPlayer = player ?? turnPlayer;
    final opponent = targetPlayer * (-1);
    final opponentState = GameState.raw(opponent, board, isCalculatingCheck: true);
    opponentState._calcAllCandidateMoves();
    for (var move in opponentState.candidateMoves) {
      final piece = board[move.endSquare];
      if (piece?.type == PieceType.king && piece?.player == targetPlayer) {
        return true;
      }
    }
    return false;
  }

  GameState.atPosition(
    this.turnPlayer,
    List<List<Piece?>> grid
  ) {
    board = Board.position(grid);
    _calcAllLegalMoves();
  }

  GameState.next(GameState current, Move move) {
    board = current.board.clone();
    turnPlayer = current.turnPlayer;
    whiteMoves = current.whiteMoves;
    blackMoves = current.blackMoves;

    board.applyMove(move);
    turnPlayer = current.turnPlayer * (-1);
  }

  bool hasFriendlyPiece(String square) => board[square]?.player == turnPlayer;


  void applyMove(Move move) {
    if (!legalMoves.contains(move)) {
      throw StateError("Cannot apply illegal move to gamestate.");
    }
    board.applyMove(move);
    if (turnPlayer == Player.white) {
      whiteMoves.add(move);
    } else {
      blackMoves.add(move);
    }
    turnPlayer *= -1;
    _calcAllLegalMoves();
  }

  void calculateLegalMoves() => _calcAllLegalMoves();

  void _calcAllLegalMoves() {
    candidateMoves = [];
    _calcAllCandidateMoves();
    candidateMoves.removeWhere((move) {
      var next = GameState.next(this, move);
      next._calcAllCandidateMoves();

      for (var nextMove in next.candidateMoves) {
        final piece = next.board[nextMove.endSquare];
        if (piece?.type == PieceType.king && piece?.player == turnPlayer) {
          return true;
        }
      }
      return false;
    });

    legalMoves = candidateMoves;
  }

  void _calcAllCandidateMoves() {
    for (var file in _files) {
      for (int rank = 1; rank <= 8; rank++) {
        _calcPieceMoves(file, rank);
      }
    }
  }

  void _calcPieceMoves(ChessFile file, int rank) {
    final square = '$file$rank';
    final piece = board[square];

    if (piece == null) {
      return;
    }
    if (piece.player != turnPlayer) {
      return;
    }

    if (piece.type == PieceType.pawn) {
      _calcPawnMoves(file, rank, turnPlayer);
    } else if (piece.type == PieceType.knight) {
      _calcKnightMoves(file, rank);
    } else if (piece.type == PieceType.rook) {
      _calcRookMoves(file, rank);
    } else if (piece.type == PieceType.bishop) {
      _calcBishopMoves(file, rank);
    } else if (piece.type == PieceType.queen) {
      _calcQueenMoves(file, rank);
    } else if (piece.type == PieceType.king) {
      _calcKingMoves(file, rank);
    }
  }

  void _addCandidateMove(PieceType type, String startSquare, String endSquare) {
    candidateMoves.add(Move(type, startSquare, endSquare));
  }

  bool _addDirectionalCandidateMove(PieceType type, String targetSquare, String square) {
    var validTypes = [PieceType.queen, PieceType.rook, PieceType.bishop];
    if (!validTypes.contains(type)) {
      throw ArgumentError("Invalid piece type for directional move");
    }
    if (board[targetSquare] == null) {
      _addCandidateMove(type, square, targetSquare);
      return true;
    }
    if (hasFriendlyPiece(targetSquare)) {
      return false;
    } else {
      // Has Enemy Piece
      _addCandidateMove(type, square, targetSquare);
      return false;
    }
  }

  void _calcPawnMoves(ChessFile file, int rank, Player player) {
    // Forward Moves
    final square = '$file$rank';
    var targetSquare = '$file${rank + turnPlayer.unit}';
    if (board[targetSquare] == null) {
      _addCandidateMove(PieceType.pawn, square, targetSquare);
      if (rank * turnPlayer.unit == 2 || rank * turnPlayer.unit == -7) {
        targetSquare = '$file${rank + 2 * turnPlayer.unit}';
        if (board[targetSquare] == null) {
          _addCandidateMove(PieceType.pawn, square, targetSquare);
        }
      }
    }
    // Captures
    for (var n in [-1, 1]) {
      targetSquare = '${file + n}${rank + turnPlayer.unit}';
      bool canCaptureDiagonally = board[targetSquare]?.player == turnPlayer * (-1);
      bool canCaptureEnPassant = false;
      try {
        final lastMove = turnPlayer == Player.white ? whiteMoves.last : blackMoves.last ;
        if (
            lastMove.type == PieceType.pawn &&
            lastMove.endSquare == '${file + n}$rank' &&
            lastMove.startSquare == '${file + n}${rank + 2 * turnPlayer.unit}') {
          canCaptureEnPassant = true;
        }
      } on StateError {
        canCaptureEnPassant = false;
      }
      if (canCaptureDiagonally || canCaptureEnPassant) {
        _addCandidateMove(PieceType.pawn, square, targetSquare);
      }
    }
  }

  void _calcKnightMoves(ChessFile file, int rank) {
    final square = '$file$rank';
    var shifts = [(-1, -2), (1, -2), (-1, 2), (1, 2), (-2, -1), (2, -1), (-2, 1), (2, 1)];

    var targetSquare = '';
    for (var (a, b) in shifts) {
      targetSquare = '${file + a}${rank + b}';
      if (Board.isValidSquare(targetSquare) && !hasFriendlyPiece(targetSquare)) {
        _addCandidateMove(PieceType.knight, square, targetSquare);
      }
    }
  }

  void _calcRookMoves(ChessFile file, int rank) {
    // Up
    final square = '$file$rank';
    var targetSquare = '';
    for (int checkRank = rank + 1; checkRank <= 8; checkRank++) {
      targetSquare = '$file$checkRank';
      if (!_addDirectionalCandidateMove(PieceType.rook, targetSquare, square)) {
        break;
      }
    }
    //Down
    for (int checkRank = rank - 1; checkRank >= 1; checkRank--) {
      targetSquare = '$file$checkRank';
      if (!_addDirectionalCandidateMove(PieceType.rook, targetSquare, square)) {
        break;
      }
    }
    //Right
    for (int filePos = _files.indexOf(file) + 1; filePos < _files.length; filePos++) {
      targetSquare = '${_files[filePos]}$rank';
      if (!_addDirectionalCandidateMove(PieceType.rook, targetSquare, square)) {
        break;
      }
    }
    //Left
    for (int filePos = _files.indexOf(file) - 1; filePos >= 0; filePos--) {
      targetSquare = '${_files[filePos]}$rank';
      if (!_addDirectionalCandidateMove(PieceType.rook, targetSquare, square)) {
        break;
      }
    }
  }

  void _calcBishopMoves(ChessFile file, int rank) {
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
      if (!_addDirectionalCandidateMove(PieceType.bishop, targetSquare, square)) {
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
      if (!_addDirectionalCandidateMove(PieceType.bishop, targetSquare, square)) {
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
      if (!_addDirectionalCandidateMove(PieceType.bishop, targetSquare, square)) {
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
      if (!_addDirectionalCandidateMove(PieceType.bishop, targetSquare, square)) {
        break;
      }
    }
  }

  void _calcQueenMoves(ChessFile file, int rank) {
    final square = '$file$rank';
    var targetSquare = '';
    //Right Top-Right
    int checkRank = rank;
    bool stopVertical, stopHorizontal = false, stopDiagonal = false;
    for (int filePos = _files.indexOf(file) + 1; filePos < _files.length; filePos++) {
      //horizontal right
      if (!stopHorizontal) {
        targetSquare = '${_files[filePos]}$rank';
        if (!_addDirectionalCandidateMove(PieceType.queen, targetSquare, square)) {
          stopHorizontal = true;
        }
      }
      //diagonal top right
      checkRank++;
      if (checkRank > 8) {
        continue;
      }
      if (!stopDiagonal) {
        targetSquare = '${_files[filePos]}$checkRank';
        if (!_addDirectionalCandidateMove(PieceType.queen, targetSquare, square)) {
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
      if (!stopVertical) {
        targetSquare = '$file$checkRank';
        if (!_addDirectionalCandidateMove(PieceType.queen, targetSquare, square)) {
          stopVertical = true;
        }
      }
      //diagonal top left
      targetSquare = '${file + (rank - checkRank)}$checkRank';
      if (!Board.isValidSquare(targetSquare)) {
        continue;
      }
      if (!stopDiagonal) {
        if (!_addDirectionalCandidateMove(PieceType.queen, targetSquare, square)) {
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
      if (!stopHorizontal) {
        targetSquare = '${_files[filePos]}$rank';
        if (!_addDirectionalCandidateMove(PieceType.queen, targetSquare, square)) {
          stopHorizontal = true;
        }
      }
      //diagonal bottom left
      checkRank--;
      if (checkRank <= 0) {
        continue;
      }
      if (!stopDiagonal) {
        targetSquare = '${_files[filePos]}$checkRank';
        if (!_addDirectionalCandidateMove(PieceType.queen, targetSquare, square)) {
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
      if (!stopVertical) {
        targetSquare = '$file$checkRank';
        if (!_addDirectionalCandidateMove(PieceType.queen, targetSquare, square)) {
          stopVertical = true;
        }
      }
      //diagonal bottom right
      targetSquare = '${file + (rank - checkRank)}$checkRank';
      if (!Board.isValidSquare(targetSquare)) {
        continue;
      }
      if (!stopDiagonal) {
        if (!_addDirectionalCandidateMove(PieceType.queen, targetSquare, square) ||
            !Board.isValidSquare(targetSquare)) {
          stopDiagonal = true;
        }
      }
      if (stopVertical && stopDiagonal) {
        break;
      }
    }
  }

  bool _isCandidateMoveLegal(Move move) {
    var next = GameState.next(this, move);
    next._calcAllCandidateMoves();
    for (var nextMove in next.candidateMoves) {
      final piece = next.board[nextMove.endSquare];
      if (piece?.type == PieceType.king && piece?.player == turnPlayer) {
        return false;
      }
    }
    return true;
  }

  void _calcKingMoves(ChessFile file, int rank) {
    final square = '$file$rank';
    final shifts = [(-1, -1), (-1, 0), (-1, 1), (0, -1), (0, 1), (1, -1), (1, 0), (1, 1)];
    var targetSquare = '';
    for (var (a, b) in shifts) {
      targetSquare = '${file + a}${rank + b}';
      if (Board.isValidSquare(targetSquare) && !hasFriendlyPiece(targetSquare)) {
        _addCandidateMove(PieceType.king, square, targetSquare);
      }
    }

    _calcCastlingMoves(file, rank);
  }

  void _calcCastlingMoves(ChessFile file, int rank) {
    final expectedRank = turnPlayer == Player.white ? 1 : 8;
    if (file.value != 'e' || rank != expectedRank) return;

    final whiteKingMoved2 = 
        whiteMoves.where((m) => m.type == PieceType.king).isNotEmpty;
    final blackKingMoved2 = 
        blackMoves.where((m) => m.type == PieceType.king).isNotEmpty;

    final kingMoved = turnPlayer == Player.white ? whiteKingMoved2 : blackKingMoved2;
    if (kingMoved) return;

    if (isKingInCheck()) return;

    final wkRookMoved = 
        whiteMoves.where((m) => m.type == PieceType.rook && m.startSquare == "h1").isNotEmpty;
    final bkRookMoved = 
        blackMoves.where((m) => m.type == PieceType.rook && m.startSquare == "h8").isNotEmpty;
    final wqRookMoved = 
        whiteMoves.where((m) => m.type == PieceType.rook && m.startSquare == "a1").isNotEmpty;
    final bqRookMoved = 
        blackMoves.where((m) => m.type == PieceType.rook && m.startSquare == "a8").isNotEmpty;

    final kRookMoved = turnPlayer == Player.white ? wkRookMoved : bkRookMoved;
    final qRookMoved = turnPlayer == Player.white ? wqRookMoved : bqRookMoved;

    // Short Castling
    if (!kRookMoved &&
        board['h$rank']?.type == PieceType.rook &&
        board['h$rank']?.player == turnPlayer &&
        board['f$rank'] == null &&
        board['g$rank'] == null) {
      final kfMove = Move(PieceType.king, 'e$rank', 'f$rank');
      if (candidateMoves.contains(kfMove) && _isCandidateMoveLegal(kfMove)) {
        _addCandidateMove(PieceType.king, 'e$rank', 'g$rank');
      }
    }

    // Long Castling
    if (!qRookMoved &&
        board['a$rank']?.type == PieceType.rook &&
        board['a$rank']?.player == turnPlayer &&
        board['b$rank'] == null &&
        board['c$rank'] == null &&
        board['d$rank'] == null) {
      final kdMove = Move(PieceType.king, 'e$rank', 'd$rank');
      if (candidateMoves.contains(kdMove) && _isCandidateMoveLegal(kdMove)) {
        _addCandidateMove(PieceType.king, 'e$rank', 'c$rank');
      }
    }
  }
}
