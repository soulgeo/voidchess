import 'package:voidchess/engine/gamestate.dart';
import 'package:voidchess/engine/types.dart';
import 'package:test/test.dart';

// ignore: constant_identifier_names
const __ = null;

void main() {
  group('Default Starting Position Legal Moves', () {
    test('White default starting position has 20 legal moves according to chess rules', () {
      final gamestate = GameState();
      gamestate.calculateLegalMoves();

      expect(gamestate.legalMoves.length, equals(20));

      final pawnMoves = gamestate.legalMoves.where((m) => m.type == PieceType.pawn).toList();
      expect(pawnMoves.length, equals(16));
      expect(
        pawnMoves,
        containsAll([
          const Move(PieceType.pawn, 'a2', 'a3'), const Move(PieceType.pawn, 'a2', 'a4'),
          const Move(PieceType.pawn, 'b2', 'b3'), const Move(PieceType.pawn, 'b2', 'b4'),
          const Move(PieceType.pawn, 'c2', 'c3'), const Move(PieceType.pawn, 'c2', 'c4'),
          const Move(PieceType.pawn, 'd2', 'd3'), const Move(PieceType.pawn, 'd2', 'd4'),
          const Move(PieceType.pawn, 'e2', 'e3'), const Move(PieceType.pawn, 'e2', 'e4'),
          const Move(PieceType.pawn, 'f2', 'f3'), const Move(PieceType.pawn, 'f2', 'f4'),
          const Move(PieceType.pawn, 'g2', 'g3'), const Move(PieceType.pawn, 'g2', 'g4'),
          const Move(PieceType.pawn, 'h2', 'h3'), const Move(PieceType.pawn, 'h2', 'h4'),
        ]),
      );

      final knightMoves = gamestate.legalMoves.where((m) => m.type == PieceType.knight).toList();
      expect(knightMoves.length, equals(4));
      expect(
        knightMoves,
        containsAll([
          const Move(PieceType.knight, 'b1', 'a3'),
          const Move(PieceType.knight, 'b1', 'c3'),
          const Move(PieceType.knight, 'g1', 'f3'),
          const Move(PieceType.knight, 'g1', 'h3'),
        ]),
      );
    });

    test('Black default starting position has 20 legal moves according to chess rules', () {
      final gamestate = GameState.atPosition(Player.black, [
        [bR, bN, bB, bQ, bK, bB, bN, bR],
        [bp, bp, bp, bp, bp, bp, bp, bp],
        [__, __, __, __, __, __, __, __],
        [__, __, __, __, __, __, __, __],
        [__, __, __, __, __, __, __, __],
        [__, __, __, __, __, __, __, __],
        [wp, wp, wp, wp, wp, wp, wp, wp],
        [wR, wN, wB, wQ, wK, wB, wN, wR],
      ]);
      gamestate.calculateLegalMoves();

      expect(gamestate.legalMoves.length, equals(20));

      final pawnMoves = gamestate.legalMoves.where((m) => m.type == PieceType.pawn).toList();
      expect(pawnMoves.length, equals(16));
      expect(
        pawnMoves,
        containsAll([
          const Move(PieceType.pawn, 'a7', 'a6'), const Move(PieceType.pawn, 'a7', 'a5'),
          const Move(PieceType.pawn, 'b7', 'b6'), const Move(PieceType.pawn, 'b7', 'b5'),
          const Move(PieceType.pawn, 'c7', 'c6'), const Move(PieceType.pawn, 'c7', 'c5'),
          const Move(PieceType.pawn, 'd7', 'd6'), const Move(PieceType.pawn, 'd7', 'd5'),
          const Move(PieceType.pawn, 'e7', 'e6'), const Move(PieceType.pawn, 'e7', 'e5'),
          const Move(PieceType.pawn, 'f7', 'f6'), const Move(PieceType.pawn, 'f7', 'f5'),
          const Move(PieceType.pawn, 'g7', 'g6'), const Move(PieceType.pawn, 'g7', 'g5'),
          const Move(PieceType.pawn, 'h7', 'h6'), const Move(PieceType.pawn, 'h7', 'h5'),
        ]),
      );

      final knightMoves = gamestate.legalMoves.where((m) => m.type == PieceType.knight).toList();
      expect(knightMoves.length, equals(4));
      expect(
        knightMoves,
        containsAll([
          const Move(PieceType.knight, 'b8', 'a6'),
          const Move(PieceType.knight, 'b8', 'c6'),
          const Move(PieceType.knight, 'g8', 'f6'),
          const Move(PieceType.knight, 'g8', 'h6'),
        ]),
      );
    });
  });

  group('Pawn Legal Moves (Chess Rules)', () {
    test('White pawn single and double step on initial rank when clear', () {
      final gamestate = GameState.atPosition(Player.white, [
        [__, __, __, __, __, __, __, bK], // R0 = Rank 8 (bK at h8)
        [__, __, __, __, __, __, __, __], // R1 = Rank 7
        [__, __, __, __, __, __, __, __], // R2 = Rank 6
        [__, __, __, __, __, __, __, __], // R3 = Rank 5
        [__, __, __, __, __, __, __, __], // R4 = Rank 4
        [__, __, __, __, __, __, __, __], // R5 = Rank 3
        [__, __, __, __, wp, __, __, __], // R6 = Rank 2 (e2)
        [wK, __, __, __, __, __, __, __], // R7 = Rank 1 (wK at a1)
      ]);
      gamestate.calculateLegalMoves();
      final pawnMoves = gamestate.legalMoves.where((m) => m.type == PieceType.pawn).toList();
      expect(pawnMoves, unorderedEquals([
        const Move(PieceType.pawn, 'e2', 'e3'),
        const Move(PieceType.pawn, 'e2', 'e4'),
      ]));
    });

    test('White pawn single step only on non-initial rank', () {
      final gamestate = GameState.atPosition(Player.white, [
        [__, __, __, __, __, __, __, bK], // R0 = Rank 8 (bK at h8)
        [__, __, __, __, __, __, __, __], // R1 = Rank 7
        [__, __, __, __, __, __, __, __], // R2 = Rank 6
        [__, __, __, __, wp, __, __, __], // R3 = Rank 5 (e5)
        [__, __, __, __, __, __, __, __], // R4 = Rank 4
        [__, __, __, __, __, __, __, __], // R5 = Rank 3
        [__, __, __, __, __, __, __, __], // R6 = Rank 2
        [wK, __, __, __, __, __, __, __], // R7 = Rank 1 (wK at a1)
      ]);
      gamestate.calculateLegalMoves();
      final pawnMoves = gamestate.legalMoves.where((m) => m.type == PieceType.pawn).toList();
      expect(pawnMoves, equals([const Move(PieceType.pawn, 'e5', 'e6')]));
    });

    test('White pawn blocked forward by enemy piece cannot move forward', () {
      final gamestate = GameState.atPosition(Player.white, [
        [__, __, __, __, __, __, __, bK], // R0 = Rank 8 (bK at h8)
        [__, __, __, __, __, __, __, __], // R1 = Rank 7
        [__, __, __, __, __, __, __, __], // R2 = Rank 6
        [__, __, __, __, __, __, __, __], // R3 = Rank 5
        [__, __, __, __, __, __, __, __], // R4 = Rank 4
        [__, __, __, __, bp, __, __, __], // R5 = Rank 3 (e3 - enemy piece)
        [__, __, __, __, wp, __, __, __], // R6 = Rank 2 (e2)
        [wK, __, __, __, __, __, __, __], // R7 = Rank 1 (wK at a1)
      ]);
      gamestate.calculateLegalMoves();
      expect(gamestate.legalMoves, isNot(contains(const Move(PieceType.pawn, 'e2', 'e3'))));
      expect(gamestate.legalMoves, isNot(contains(const Move(PieceType.pawn, 'e2', 'e4'))));
    });

    test('White pawn diagonal capture of enemy pieces', () {
      final gamestate = GameState.atPosition(Player.white, [
        [__, __, __, __, __, __, __, bK], // R0 = Rank 8 (bK at h8)
        [__, __, __, __, __, __, __, __], // R1 = Rank 7
        [__, __, __, __, __, __, __, __], // R2 = Rank 6
        [__, __, __, bp, __, bp, __, __], // R3 = Rank 5: d5 (bp), f5 (bp)
        [__, __, __, __, wp, __, __, __], // R4 = Rank 4: e4 (wp)
        [__, __, __, __, __, __, __, __], // R5 = Rank 3
        [__, __, __, __, __, __, __, __], // R6 = Rank 2
        [wK, __, __, __, __, __, __, __], // R7 = Rank 1 (wK at a1)
      ]);
      gamestate.calculateLegalMoves();

      expect(gamestate.legalMoves, contains(const Move(PieceType.pawn, 'e4', 'd5')));
      expect(gamestate.legalMoves, contains(const Move(PieceType.pawn, 'e4', 'f5')));
      expect(gamestate.legalMoves, contains(const Move(PieceType.pawn, 'e4', 'e5')));
    });

    test('White pawn cannot move diagonally to empty or friendly squares', () {
      final gamestate = GameState.atPosition(Player.white, [
        [__, __, __, __, __, __, __, bK], // R0 = Rank 8 (bK at h8)
        [__, __, __, __, __, __, __, __], // R1 = Rank 7
        [__, __, __, __, __, __, __, __], // R2 = Rank 6
        [__, __, __, wp, __, __, __, __], // R3 = Rank 5: d5 (friendly wp), f5 is empty
        [__, __, __, __, wp, __, __, __], // R4 = Rank 4: e4 (wp)
        [__, __, __, __, __, __, __, __], // R5 = Rank 3
        [__, __, __, __, __, __, __, __], // R6 = Rank 2
        [wK, __, __, __, __, __, __, __], // R7 = Rank 1 (wK at a1)
      ]);
      gamestate.calculateLegalMoves();

      expect(gamestate.legalMoves, isNot(contains(const Move(PieceType.pawn, 'e4', 'd5')))); // friendly square
      expect(gamestate.legalMoves, isNot(contains(const Move(PieceType.pawn, 'e4', 'f5')))); // empty square
    });

    test('Black pawn diagonal capture of enemy piece', () {
      final gamestate = GameState.atPosition(Player.black, [
        [__, __, __, __, __, __, __, bK], // R0 = Rank 8 (bK at h8)
        [__, __, __, __, __, __, __, __], // R1 = Rank 7
        [__, __, __, bp, __, __, __, __], // R2 = Rank 6: d6 (bp)
        [__, __, wp, __, __, __, __, __], // R3 = Rank 5: c5 (enemy wp)
        [__, __, __, __, __, __, __, __], // R4 = Rank 4
        [__, __, __, __, __, __, __, __], // R5 = Rank 3
        [__, __, __, __, __, __, __, __], // R6 = Rank 2
        [wK, __, __, __, __, __, __, __], // R7 = Rank 1 (wK at a1)
      ]);
      gamestate.calculateLegalMoves();

      expect(gamestate.legalMoves, contains(const Move(PieceType.pawn, 'd6', 'c5')));
      expect(gamestate.legalMoves, contains(const Move(PieceType.pawn, 'd6', 'd5')));
    });
  });

  group('En Passant Legal Moves (Chess Rules)', () {
    test('White pawn can capture enemy pawn en passant after two-square pawn advance', () {
      final gamestate = GameState.atPosition(
        Player.white,
        [
          [__, __, __, __, __, __, __, bK], // R0 = Rank 8 (bK at h8)
          [__, __, __, __, __, __, __, __], // R1 = Rank 7
          [__, __, __, __, __, __, __, __], // R2 = Rank 6
          [__, __, __, bp, wp, __, __, __], // R3 = Rank 5: d5 (bp), e5 (wp)
          [__, __, __, __, __, __, __, __], // R4 = Rank 4
          [__, __, __, __, __, __, __, __], // R5 = Rank 3
          [__, __, __, __, __, __, __, __], // R6 = Rank 2
          [wK, __, __, __, __, __, __, __], // R7 = Rank 1 (wK at a1)
        ],
        lastMove: const Move(PieceType.pawn, 'd7', 'd5'),
      );

      final enPassantMove = const Move(PieceType.pawn, 'e5', 'd6');
      expect(gamestate.legalMoves, contains(enPassantMove));

      gamestate.applyMove(enPassantMove);

      expect(gamestate.board['e5'], isNull);
      expect(gamestate.board['d5'], isNull); // Captured pawn removed
      expect(gamestate.board['d6'], equals(wp));
    });

    test('Black pawn can capture enemy pawn en passant after two-square pawn advance', () {
      final gamestate = GameState.atPosition(
        Player.black,
        [
          [__, __, __, __, __, __, __, bK], // R0 = Rank 8 (bK at h8)
          [__, __, __, __, __, __, __, __], // R1 = Rank 7
          [__, __, __, __, __, __, __, __], // R2 = Rank 6
          [__, __, __, __, __, __, __, __], // R3 = Rank 5
          [__, __, __, bp, wp, __, __, __], // R4 = Rank 4: d4 (bp), e4 (wp)
          [__, __, __, __, __, __, __, __], // R5 = Rank 3
          [__, __, __, __, __, __, __, __], // R6 = Rank 2
          [wK, __, __, __, __, __, __, __], // R7 = Rank 1 (wK at a1)
        ],
        lastMove: const Move(PieceType.pawn, 'e2', 'e4'),
      );

      final enPassantMove = const Move(PieceType.pawn, 'd4', 'e3');
      expect(gamestate.legalMoves, contains(enPassantMove));

      gamestate.applyMove(enPassantMove);

      expect(gamestate.board['d4'], isNull);
      expect(gamestate.board['e4'], isNull); // Captured pawn removed
      expect(gamestate.board['e3'], equals(bp));
    });

    test('En passant capture is not allowed if pawn advanced only one square', () {
      final gamestate = GameState.atPosition(
        Player.white,
        [
          [__, __, __, __, __, __, __, bK], // R0 = Rank 8
          [__, __, __, __, __, __, __, __], // R1 = Rank 7
          [__, __, __, __, __, __, __, __], // R2 = Rank 6
          [__, __, __, bp, wp, __, __, __], // R3 = Rank 5: d5 (bp), e5 (wp)
          [__, __, __, __, __, __, __, __], // R4 = Rank 4
          [__, __, __, __, __, __, __, __], // R5 = Rank 3
          [__, __, __, __, __, __, __, __], // R6 = Rank 2
          [wK, __, __, __, __, __, __, __], // R7 = Rank 1
        ],
        lastMove: const Move(PieceType.pawn, 'd6', 'd5'), // single step from d6
      );

      expect(gamestate.legalMoves, isNot(contains(const Move(PieceType.pawn, 'e5', 'd6'))));
    });

    test('En passant capture is illegal if it exposes King to check', () {
      final gamestate = GameState.atPosition(
        Player.white,
        [
          [__, __, __, __, __, __, __, bK], // R0 = Rank 8
          [__, __, __, __, __, __, __, __], // R1 = Rank 7
          [__, __, __, __, __, __, __, __], // R2 = Rank 6
          [wK, __, __, bp, wp, __, __, bR], // R3 = Rank 5: a5 (wK), d5 (bp), e5 (wp), h5 (bR)
          [__, __, __, __, __, __, __, __], // R4 = Rank 4
          [__, __, __, __, __, __, __, __], // R5 = Rank 3
          [__, __, __, __, __, __, __, __], // R6 = Rank 2
          [__, __, __, __, __, __, __, __], // R7 = Rank 1
        ],
        lastMove: const Move(PieceType.pawn, 'd7', 'd5'),
      );

      // Capturing en passant removes both d5 (bp) and e5 (wp) from rank 5, leaving wK at a5 exposed to bR at h5.
      expect(gamestate.legalMoves, isNot(contains(const Move(PieceType.pawn, 'e5', 'd6'))));
    });
  });

  group('Castling Legal Moves (Chess Rules)', () {
    test('White short and long castling are legal when requirements are met', () {
      final gamestate = GameState.atPosition(Player.white, [
        [bR, __, __, __, bK, __, __, bR], // R0 = Rank 8
        [bp, bp, bp, bp, bp, bp, bp, bp], // R1 = Rank 7
        [__, __, __, __, __, __, __, __], // R2 = Rank 6
        [__, __, __, __, __, __, __, __], // R3 = Rank 5
        [__, __, __, __, __, __, __, __], // R4 = Rank 4
        [__, __, __, __, __, __, __, __], // R5 = Rank 3
        [wp, wp, wp, wp, wp, wp, wp, wp], // R6 = Rank 2
        [wR, __, __, __, wK, __, __, wR], // R7 = Rank 1: wR (a1), wK (e1), wR (h1)
      ]);

      expect(gamestate.legalMoves, contains(const Move(PieceType.king, 'e1', 'g1'))); // Short castle
      expect(gamestate.legalMoves, contains(const Move(PieceType.king, 'e1', 'c1'))); // Long castle
    });

    test('Castling disallowed if King has moved', () {
      final gamestate = GameState.atPosition(
        Player.white,
        [
          [bR, __, __, __, bK, __, __, bR],
          [bp, bp, bp, bp, bp, bp, bp, bp],
          [__, __, __, __, __, __, __, __],
          [__, __, __, __, __, __, __, __],
          [__, __, __, __, __, __, __, __],
          [__, __, __, __, __, __, __, __],
          [wp, wp, wp, wp, wp, wp, wp, wp],
          [wR, __, __, __, wK, __, __, wR],
        ],
        whiteKingMoved: true,
      );

      expect(gamestate.legalMoves, isNot(contains(const Move(PieceType.king, 'e1', 'g1'))));
      expect(gamestate.legalMoves, isNot(contains(const Move(PieceType.king, 'e1', 'c1'))));
    });

    test('Short castling disallowed if transit square f1 is attacked by enemy piece', () {
      final gamestate = GameState.atPosition(Player.white, [
        [bR, __, __, __, bK, __, __, bR],
        [bp, bp, bp, bp, __, bp, bp, bp], // f7 empty
        [__, __, __, __, __, __, __, __],
        [__, __, __, __, __, __, __, __],
        [__, __, bB, __, __, __, __, __], // bB at c4 attacking f1
        [__, __, __, __, __, __, __, __],
        [wp, wp, wp, wp, __, wp, wp, wp], // e2 empty so c4 bishop reaches f1
        [wR, __, __, __, wK, __, __, wR],
      ]);

      // Transit square f1 is attacked by bB on c4
      expect(gamestate.legalMoves, isNot(contains(const Move(PieceType.king, 'e1', 'g1'))));
    });

    test('Castling disallowed if King is currently in check', () {
      final gamestate = GameState.atPosition(Player.white, [
        [bR, __, __, __, bK, __, __, bR],
        [bp, bp, bp, bp, __, bp, bp, bp],
        [__, __, __, __, __, __, __, __],
        [__, __, __, __, __, __, __, __],
        [__, __, __, __, bR, __, __, __], // bR at e4 checking wK on e1
        [__, __, __, __, __, __, __, __],
        [wp, wp, wp, wp, __, wp, wp, wp], // e2 empty so e4 rook checks e1 king
        [wR, __, __, __, wK, __, __, wR],
      ]);

      expect(gamestate.legalMoves, isNot(contains(const Move(PieceType.king, 'e1', 'g1'))));
      expect(gamestate.legalMoves, isNot(contains(const Move(PieceType.king, 'e1', 'c1'))));
    });
  });

  group('Knight Legal Moves (Chess Rules)', () {
    test('Knight in center of empty board (d5) has 8 legal moves', () {
      final gamestate = GameState.atPosition(Player.white, [
        [__, __, __, __, __, __, __, bK], // R0 = Rank 8 (bK at h8)
        [__, __, __, __, __, __, __, __], // R1 = Rank 7
        [__, __, __, __, __, __, __, __], // R2 = Rank 6
        [__, __, __, wN, __, __, __, __], // R3 = Rank 5 (d5)
        [__, __, __, __, __, __, __, __], // R4 = Rank 4
        [__, __, __, __, __, __, __, __], // R5 = Rank 3
        [__, __, __, __, __, __, __, __], // R6 = Rank 2
        [wK, __, __, __, __, __, __, __], // R7 = Rank 1 (wK at a1)
      ]);
      gamestate.calculateLegalMoves();
      expect(
        gamestate.legalMoves.where((m) => m.type == PieceType.knight).toList(),
        unorderedEquals([
          const Move(PieceType.knight, 'd5', 'c7'), const Move(PieceType.knight, 'd5', 'e7'),
          const Move(PieceType.knight, 'd5', 'b6'), const Move(PieceType.knight, 'd5', 'f6'),
          const Move(PieceType.knight, 'd5', 'b4'), const Move(PieceType.knight, 'd5', 'f4'),
          const Move(PieceType.knight, 'd5', 'c3'), const Move(PieceType.knight, 'd5', 'e3'),
        ]),
      );
    });

    test('Knight in corner (a1) has 2 legal moves', () {
      final gamestate = GameState.atPosition(Player.white, [
        [__, __, __, __, __, __, __, bK], // R0 = Rank 8 (bK at h8)
        [__, __, __, __, __, __, __, __], // R1 = Rank 7
        [__, __, __, __, __, __, __, __], // R2 = Rank 6
        [__, __, __, __, __, __, __, __], // R3 = Rank 5
        [__, __, __, __, __, __, __, __], // R4 = Rank 4
        [__, __, __, __, __, __, __, __], // R5 = Rank 3
        [__, __, __, __, __, __, __, __], // R6 = Rank 2
        [wN, __, __, __, wK, __, __, __], // R7 = Rank 1 (wN at a1, wK at e1)
      ]);
      gamestate.calculateLegalMoves();
      expect(
        gamestate.legalMoves.where((m) => m.type == PieceType.knight).toList(),
        unorderedEquals([
          const Move(PieceType.knight, 'a1', 'b3'),
          const Move(PieceType.knight, 'a1', 'c2'),
        ]),
      );
    });

    test('Knight captures enemy piece and avoids friendly piece', () {
      final gamestate = GameState.atPosition(Player.white, [
        [__, __, __, __, __, __, __, bK], // R0 = Rank 8 (bK at h8)
        [__, __, __, __, __, __, __, __], // R1 = Rank 7
        [__, __, bp, __, wR, __, __, __], // R2 = Rank 6: c6 (bp), e6 (wR)
        [__, __, __, __, __, __, __, __], // R3 = Rank 5
        [__, __, __, wN, __, __, __, __], // R4 = Rank 4: d4 (wN)
        [__, __, __, __, __, __, __, __], // R5 = Rank 3
        [__, __, __, __, __, __, __, __], // R6 = Rank 2
        [wK, __, __, __, __, __, __, __], // R7 = Rank 1 (wK at a1)
      ]);
      gamestate.calculateLegalMoves();

      expect(gamestate.legalMoves, isNot(contains(const Move(PieceType.knight, 'd4', 'e6')))); // friendly piece on e6
      expect(gamestate.legalMoves, contains(const Move(PieceType.knight, 'd4', 'c6')));        // enemy piece on c6
    });
  });

  group('Rook Legal Moves (Chess Rules)', () {
    test('Rook in center of empty board (d4) has 14 legal moves', () {
      final gamestate = GameState.atPosition(Player.white, [
        [__, __, __, __, __, __, __, bK], // R0 = Rank 8 (bK at h8)
        [__, __, __, __, __, __, __, __], // R1 = Rank 7
        [__, __, __, __, __, __, __, __], // R2 = Rank 6
        [__, __, __, __, __, __, __, __], // R3 = Rank 5
        [__, __, __, wR, __, __, __, __], // R4 = Rank 4 (d4)
        [__, __, __, __, __, __, __, __], // R5 = Rank 3
        [__, __, __, __, __, __, __, __], // R6 = Rank 2
        [wK, __, __, __, __, __, __, __], // R7 = Rank 1 (wK at a1)
      ]);
      gamestate.calculateLegalMoves();
      expect(
        gamestate.legalMoves.where((m) => m.type == PieceType.rook).toList(),
        unorderedEquals([
          const Move(PieceType.rook, 'd4', 'd5'), const Move(PieceType.rook, 'd4', 'd6'), const Move(PieceType.rook, 'd4', 'd7'), const Move(PieceType.rook, 'd4', 'd8'),
          const Move(PieceType.rook, 'd4', 'd3'), const Move(PieceType.rook, 'd4', 'd2'), const Move(PieceType.rook, 'd4', 'd1'),
          const Move(PieceType.rook, 'd4', 'c4'), const Move(PieceType.rook, 'd4', 'b4'), const Move(PieceType.rook, 'd4', 'a4'),
          const Move(PieceType.rook, 'd4', 'e4'), const Move(PieceType.rook, 'd4', 'f4'), const Move(PieceType.rook, 'd4', 'g4'), const Move(PieceType.rook, 'd4', 'h4'),
        ]),
      );
    });

    test('Rook ray stops before friendly piece and captures enemy piece', () {
      final gamestate = GameState.atPosition(Player.white, [
        [__, __, __, __, __, __, __, bK], // R0 = Rank 8 (bK at h8)
        [__, __, __, __, __, __, __, __], // R1 = Rank 7
        [__, __, __, wB, __, __, __, __], // R2 = Rank 6: d6 (friendly wB)
        [__, __, __, __, __, __, __, __], // R3 = Rank 5
        [__, bp, __, wR, __, __, __, __], // R4 = Rank 4: b4 (enemy bp), d4 (wR)
        [__, __, __, __, __, __, __, __], // R5 = Rank 3
        [__, __, __, __, __, __, __, __], // R6 = Rank 2
        [wK, __, __, __, __, __, __, __], // R7 = Rank 1 (wK at a1)
      ]);
      gamestate.calculateLegalMoves();

      expect(gamestate.legalMoves, contains(const Move(PieceType.rook, 'd4', 'd5')));
      expect(gamestate.legalMoves, isNot(contains(const Move(PieceType.rook, 'd4', 'd6'))));
      expect(gamestate.legalMoves, isNot(contains(const Move(PieceType.rook, 'd4', 'd7'))));

      expect(gamestate.legalMoves, contains(const Move(PieceType.rook, 'd4', 'c4')));
      expect(gamestate.legalMoves, contains(const Move(PieceType.rook, 'd4', 'b4')));
      expect(gamestate.legalMoves, isNot(contains(const Move(PieceType.rook, 'd4', 'a4'))));
    });
  });

  group('Bishop Legal Moves (Chess Rules)', () {
    test('Bishop in center of empty board (d4) has 13 legal moves', () {
      final gamestate = GameState.atPosition(Player.white, [
        [wK, __, __, __, __, __, __, __], // R0 = Rank 8 (wK at a8 - off diagonals)
        [__, __, __, __, __, __, __, __], // R1 = Rank 7
        [__, __, __, __, __, __, __, __], // R2 = Rank 6
        [__, __, __, __, __, __, __, __], // R3 = Rank 5
        [__, __, __, wB, __, __, __, __], // R4 = Rank 4 (d4)
        [__, __, __, __, __, __, __, __], // R5 = Rank 3
        [__, __, __, __, __, __, __, __], // R6 = Rank 2
        [__, __, __, __, __, __, __, bK], // R7 = Rank 1 (bK at h1 - off diagonals)
      ]);
      gamestate.calculateLegalMoves();
      expect(
        gamestate.legalMoves.where((m) => m.type == PieceType.bishop).toList(),
        unorderedEquals([
          const Move(PieceType.bishop, 'd4', 'e5'), const Move(PieceType.bishop, 'd4', 'f6'), const Move(PieceType.bishop, 'd4', 'g7'), const Move(PieceType.bishop, 'd4', 'h8'),
          const Move(PieceType.bishop, 'd4', 'c5'), const Move(PieceType.bishop, 'd4', 'b6'), const Move(PieceType.bishop, 'd4', 'a7'),
          const Move(PieceType.bishop, 'd4', 'c3'), const Move(PieceType.bishop, 'd4', 'b2'), const Move(PieceType.bishop, 'd4', 'a1'),
          const Move(PieceType.bishop, 'd4', 'e3'), const Move(PieceType.bishop, 'd4', 'f2'), const Move(PieceType.bishop, 'd4', 'g1'),
        ]),
      );
    });

    test('Bishop blocked by friendly and enemy pieces on diagonals', () {
      final gamestate = GameState.atPosition(Player.white, [
        [wK, __, __, __, __, __, __, __], // R0 = Rank 8 (wK at a8)
        [__, __, __, __, __, __, __, __], // R1 = Rank 7
        [__, __, __, __, __, wR, __, __], // R2 = Rank 6: f6 (friendly wR)
        [__, __, __, __, __, __, __, __], // R3 = Rank 5
        [__, __, __, wB, __, __, __, __], // R4 = Rank 4: d4 (wB)
        [__, __, __, __, __, __, __, __], // R5 = Rank 3
        [__, bp, __, __, __, __, __, __], // R6 = Rank 2: b2 (enemy bp)
        [__, __, __, __, __, __, __, bK], // R7 = Rank 1 (bK at h1)
      ]);
      gamestate.calculateLegalMoves();

      expect(gamestate.legalMoves, contains(const Move(PieceType.bishop, 'd4', 'e5')));
      expect(gamestate.legalMoves, isNot(contains(const Move(PieceType.bishop, 'd4', 'f6'))));
      expect(gamestate.legalMoves, isNot(contains(const Move(PieceType.bishop, 'd4', 'g7'))));

      expect(gamestate.legalMoves, contains(const Move(PieceType.bishop, 'd4', 'c3')));
      expect(gamestate.legalMoves, contains(const Move(PieceType.bishop, 'd4', 'b2')));
      expect(gamestate.legalMoves, isNot(contains(const Move(PieceType.bishop, 'd4', 'a1'))));
    });
  });

  group('Queen Legal Moves (Chess Rules)', () {
    test('Queen in center of empty board (d4) has 27 legal moves', () {
      final gamestate = GameState.atPosition(Player.white, [
        [wK, __, __, __, __, __, __, __], // R0 = Rank 8 (wK at a8 - off Q rays)
        [__, __, __, __, __, __, __, __], // R1 = Rank 7
        [__, __, __, __, __, __, __, __], // R2 = Rank 6
        [__, __, __, __, __, __, __, __], // R3 = Rank 5
        [__, __, __, wQ, __, __, __, __], // R4 = Rank 4 (d4)
        [__, __, __, __, __, __, __, __], // R5 = Rank 3
        [__, __, __, __, __, __, __, __], // R6 = Rank 2
        [__, __, __, __, __, __, __, bK], // R7 = Rank 1 (bK at h1 - off Q rays)
      ]);
      gamestate.calculateLegalMoves();
      expect(
        gamestate.legalMoves.where((m) => m.type == PieceType.queen).toList(),
        unorderedEquals([
          const Move(PieceType.queen, 'd4', 'd5'), const Move(PieceType.queen, 'd4', 'd6'), const Move(PieceType.queen, 'd4', 'd7'), const Move(PieceType.queen, 'd4', 'd8'),
          const Move(PieceType.queen, 'd4', 'd3'), const Move(PieceType.queen, 'd4', 'd2'), const Move(PieceType.queen, 'd4', 'd1'),
          const Move(PieceType.queen, 'd4', 'c4'), const Move(PieceType.queen, 'd4', 'b4'), const Move(PieceType.queen, 'd4', 'a4'),
          const Move(PieceType.queen, 'd4', 'e4'), const Move(PieceType.queen, 'd4', 'f4'), const Move(PieceType.queen, 'd4', 'g4'), const Move(PieceType.queen, 'd4', 'h4'),
          const Move(PieceType.queen, 'd4', 'e5'), const Move(PieceType.queen, 'd4', 'f6'), const Move(PieceType.queen, 'd4', 'g7'), const Move(PieceType.queen, 'd4', 'h8'),
          const Move(PieceType.queen, 'd4', 'c5'), const Move(PieceType.queen, 'd4', 'b6'), const Move(PieceType.queen, 'd4', 'a7'),
          const Move(PieceType.queen, 'd4', 'c3'), const Move(PieceType.queen, 'd4', 'b2'), const Move(PieceType.queen, 'd4', 'a1'),
          const Move(PieceType.queen, 'd4', 'e3'), const Move(PieceType.queen, 'd4', 'f2'), const Move(PieceType.queen, 'd4', 'g1'),
        ]),
      );
    });

    test('Queen blocked by friendly and enemy pieces', () {
      final gamestate = GameState.atPosition(Player.white, [
        [wK, __, __, __, __, __, __, __], // R0 = Rank 8 (wK at a8)
        [__, __, __, __, __, __, __, __], // R1 = Rank 7
        [__, __, __, wB, __, __, __, __], // R2 = Rank 6: d6 (friendly wB)
        [__, __, __, __, __, __, __, __], // R3 = Rank 5
        [__, __, __, wQ, __, bp, __, __], // R4 = Rank 4: d4 (wQ), f4 (enemy bp)
        [__, __, __, __, __, __, __, __], // R5 = Rank 3
        [__, __, __, __, __, __, __, __], // R6 = Rank 2
        [__, __, __, __, __, __, __, bK], // R7 = Rank 1 (bK at h1)
      ]);
      gamestate.calculateLegalMoves();

      expect(gamestate.legalMoves, contains(const Move(PieceType.queen, 'd4', 'd5')));
      expect(gamestate.legalMoves, isNot(contains(const Move(PieceType.queen, 'd4', 'd6'))));

      expect(gamestate.legalMoves, contains(const Move(PieceType.queen, 'd4', 'e4')));
      expect(gamestate.legalMoves, contains(const Move(PieceType.queen, 'd4', 'f4')));
      expect(gamestate.legalMoves, isNot(contains(const Move(PieceType.queen, 'd4', 'g4'))));
    });
  });

  group('King Legal Moves (Chess Rules)', () {
    test('King in center of empty board (d4) has 8 legal moves according to chess rules', () {
      final gamestate = GameState.atPosition(Player.white, [
        [__, __, __, __, __, __, __, bK], // R0 = Rank 8 (bK at h8)
        [__, __, __, __, __, __, __, __], // R1 = Rank 7
        [__, __, __, __, __, __, __, __], // R2 = Rank 6
        [__, __, __, __, __, __, __, __], // R3 = Rank 5
        [__, __, __, wK, __, __, __, __], // R4 = Rank 4 (d4)
        [__, __, __, __, __, __, __, __], // R5 = Rank 3
        [__, __, __, __, __, __, __, __], // R6 = Rank 2
        [__, __, __, __, __, __, __, __], // R7 = Rank 1
      ]);
      gamestate.calculateLegalMoves();
      expect(
        gamestate.legalMoves.where((m) => m.type == PieceType.king).toList(),
        unorderedEquals([
          const Move(PieceType.king, 'd4', 'c5'), const Move(PieceType.king, 'd4', 'd5'), const Move(PieceType.king, 'd4', 'e5'),
          const Move(PieceType.king, 'd4', 'c4'),                                        const Move(PieceType.king, 'd4', 'e4'),
          const Move(PieceType.king, 'd4', 'c3'), const Move(PieceType.king, 'd4', 'd3'), const Move(PieceType.king, 'd4', 'e3'),
        ]),
      );
    });

    test('King in corner (a1) has 3 legal moves according to chess rules', () {
      final gamestate = GameState.atPosition(Player.white, [
        [__, __, __, __, __, __, __, bK], // R0 = Rank 8 (bK at h8)
        [__, __, __, __, __, __, __, __], // R1 = Rank 7
        [__, __, __, __, __, __, __, __], // R2 = Rank 6
        [__, __, __, __, __, __, __, __], // R3 = Rank 5
        [__, __, __, __, __, __, __, __], // R4 = Rank 4
        [__, __, __, __, __, __, __, __], // R5 = Rank 3
        [__, __, __, __, __, __, __, __], // R6 = Rank 2
        [wK, __, __, __, __, __, __, __], // R7 = Rank 1 (a1)
      ]);
      gamestate.calculateLegalMoves();
      expect(
        gamestate.legalMoves.where((m) => m.type == PieceType.king).toList(),
        unorderedEquals([
          const Move(PieceType.king, 'a1', 'a2'),
          const Move(PieceType.king, 'a1', 'b2'),
          const Move(PieceType.king, 'a1', 'b1'),
        ]),
      );
    });

    test('King captures enemy piece and avoids friendly piece', () {
      final gamestate = GameState.atPosition(Player.white, [
        [__, __, __, __, __, __, __, bK], // R0 = Rank 8 (bK at h8)
        [__, __, __, __, __, __, __, __], // R1 = Rank 7
        [__, __, __, __, __, __, __, __], // R2 = Rank 6
        [__, __, bp, __, wp, __, __, __], // R3 = Rank 5: c5 (enemy bp), e5 (friendly wp)
        [__, __, __, wK, __, __, __, __], // R4 = Rank 4: d4 (wK)
        [__, __, __, __, __, __, __, __], // R5 = Rank 3
        [__, __, __, __, __, __, __, __], // R6 = Rank 2
        [__, __, __, __, __, __, __, __], // R7 = Rank 1
      ]);
      gamestate.calculateLegalMoves();

      expect(gamestate.legalMoves, isNot(contains(const Move(PieceType.king, 'd4', 'e5')))); // friendly piece on e5
      expect(gamestate.legalMoves, contains(const Move(PieceType.king, 'd4', 'c5')));        // enemy piece on c5 (capture)
    });
  });

  group('King Check Restrictions (Chess Rules)', () {
    test('King cannot move into squares attacked by enemy piece', () {
      final gamestate = GameState.atPosition(Player.white, [
        [__, __, bR, __, __, __, __, bK], // R0 = Rank 8: c8 (bR), h8 (bK)
        [__, __, __, __, __, __, __, __], // R1 = Rank 7
        [__, __, __, __, __, __, __, __], // R2 = Rank 6
        [__, __, __, __, __, __, __, __], // R3 = Rank 5
        [__, __, __, wK, __, __, __, __], // R4 = Rank 4: d4 (wK)
        [__, __, __, __, __, __, __, __], // R5 = Rank 3
        [__, __, __, __, __, __, __, __], // R6 = Rank 2
        [__, __, __, __, __, __, __, __], // R7 = Rank 1
      ]);
      gamestate.calculateLegalMoves();

      // bR at c8 controls c-file (c1-c8).
      // wK at d4 CANNOT move to c3, c4, c5 because those squares are in check.
      expect(gamestate.legalMoves, isNot(contains(const Move(PieceType.king, 'd4', 'c3'))));
      expect(gamestate.legalMoves, isNot(contains(const Move(PieceType.king, 'd4', 'c4'))));
      expect(gamestate.legalMoves, isNot(contains(const Move(PieceType.king, 'd4', 'c5'))));

      // wK at d4 CAN move to unattacked squares (d3, d5, e3, e4, e5)
      expect(gamestate.legalMoves, contains(const Move(PieceType.king, 'd4', 'd3')));
      expect(gamestate.legalMoves, contains(const Move(PieceType.king, 'd4', 'd5')));
      expect(gamestate.legalMoves, contains(const Move(PieceType.king, 'd4', 'e3')));
      expect(gamestate.legalMoves, contains(const Move(PieceType.king, 'd4', 'e4')));
      expect(gamestate.legalMoves, contains(const Move(PieceType.king, 'd4', 'e5')));
    });

    test('When in check, player can only make moves that resolve check (block, capture, or move King)', () {
      final gamestate = GameState.atPosition(Player.white, [
        [__, __, __, __, bR, __, __, bK], // R0 = Rank 8: e8 (bR - checking wK at e1), h8 (bK)
        [__, __, __, __, __, __, __, __], // R1 = Rank 7
        [__, __, __, __, __, __, __, __], // R2 = Rank 6
        [__, __, __, __, __, __, __, __], // R3 = Rank 5
        [wR, __, __, __, __, __, __, __], // R4 = Rank 4: a4 (wR - can block at e4)
        [__, __, __, __, __, __, __, __], // R5 = Rank 3
        [__, __, __, __, __, __, __, __], // R6 = Rank 2
        [wB, __, __, __, wK, __, __, __], // R7 = Rank 1: a1 (wB - can block at e5), e1 (wK - in check)
      ]);
      gamestate.calculateLegalMoves();

      // wR at a4 can block check by moving to e4
      expect(gamestate.legalMoves, contains(const Move(PieceType.rook, 'a4', 'e4')));

      // wB at a1 can block check by moving to e5
      expect(gamestate.legalMoves, contains(const Move(PieceType.bishop, 'a1', 'e5')));

      // wR at a4 CANNOT make non-blocking move like a5
      expect(gamestate.legalMoves, isNot(contains(const Move(PieceType.rook, 'a4', 'a5'))));

      // wB at a1 CANNOT make non-blocking move like b2
      expect(gamestate.legalMoves, isNot(contains(const Move(PieceType.bishop, 'a1', 'b2'))));

      // wK at e1 can move out of check to d1, d2, f1, f2
      expect(gamestate.legalMoves, contains(const Move(PieceType.king, 'e1', 'd1')));
      expect(gamestate.legalMoves, contains(const Move(PieceType.king, 'e1', 'd2')));

      // wK at e1 CANNOT move along checking e-file to e2
      expect(gamestate.legalMoves, isNot(contains(const Move(PieceType.king, 'e1', 'e2'))));
    });

    test('When in check, capturing the checking piece is allowed to resolve check', () {
      final gamestate = GameState.atPosition(Player.white, [
        [__, __, __, __, __, __, __, bK], // R0 = Rank 8: h8 (bK)
        [__, __, __, __, __, __, __, __], // R1 = Rank 7
        [__, __, __, __, __, __, __, __], // R2 = Rank 6
        [__, __, __, __, __, __, __, __], // R3 = Rank 5
        [__, __, __, __, bQ, __, __, __], // R4 = Rank 4: e4 (bQ - checking wK at e1)
        [__, __, wN, __, __, __, __, __], // R5 = Rank 3: c3 (wN - can capture bQ at e4)
        [__, __, __, __, __, __, __, __], // R6 = Rank 2
        [__, __, __, __, wK, __, __, __], // R7 = Rank 1: e1 (wK - in check)
      ]);
      gamestate.calculateLegalMoves();

      // wN at c3 CAN capture checking bQ at e4 (c3 -> e4: +2 files, +1 rank)
      expect(gamestate.legalMoves, contains(const Move(PieceType.knight, 'c3', 'e4')));

      // wN at c3 CANNOT move to non-resolving squares like b5 or a4
      expect(gamestate.legalMoves, isNot(contains(const Move(PieceType.knight, 'c3', 'b5'))));
      expect(gamestate.legalMoves, isNot(contains(const Move(PieceType.knight, 'c3', 'a4'))));
    });
  });

  group('Pinned Piece Restrictions (Chess Rules)', () {
    test('Piece pinned vertically to King cannot move horizontally off pin ray', () {
      final gamestate = GameState.atPosition(Player.white, [
        [__, __, __, __, bR, __, __, bK], // R0 = Rank 8: e8 (bR), h8 (bK)
        [__, __, __, __, __, __, __, __], // R1 = Rank 7
        [__, __, __, __, __, __, __, __], // R2 = Rank 6
        [__, __, __, __, __, __, __, __], // R3 = Rank 5
        [__, __, __, __, wR, __, __, __], // R4 = Rank 4: e4 (wR - pinned to wK on e1)
        [__, __, __, __, __, __, __, __], // R5 = Rank 3
        [__, __, __, __, __, __, __, __], // R6 = Rank 2
        [__, __, __, __, wK, __, __, __], // R7 = Rank 1: e1 (wK)
      ]);
      gamestate.calculateLegalMoves();

      // wR at e4 is pinned to wK at e1 by bR at e8.
      // Moving wR off the e-file (e.g. to d4 or f4) would expose wK to check.
      expect(gamestate.legalMoves, isNot(contains(const Move(PieceType.rook, 'e4', 'd4'))));
      expect(gamestate.legalMoves, isNot(contains(const Move(PieceType.rook, 'e4', 'f4'))));

      // Moving along the pin ray (e.g. e2, e3, e5, e6, e7, e8) keeps King protected.
      expect(gamestate.legalMoves, contains(const Move(PieceType.rook, 'e4', 'e5')));
      expect(gamestate.legalMoves, contains(const Move(PieceType.rook, 'e4', 'e8'))); // capture checking bR
    });

    test('Piece pinned diagonally to King cannot move off diagonal pin ray', () {
      final gamestate = GameState.atPosition(Player.white, [
        [__, __, __, __, __, __, __, bK], // R0 = Rank 8: h8 (bK)
        [__, __, __, __, __, __, __, __], // R1 = Rank 7
        [__, __, __, __, __, __, __, __], // R2 = Rank 6
        [bB, __, __, __, __, __, __, __], // R3 = Rank 5: a5 (bB - pinning wB at d2 to wK at e1)
        [__, __, __, __, __, __, __, __], // R4 = Rank 4
        [__, __, __, __, __, __, __, __], // R5 = Rank 3
        [__, __, __, wB, __, __, __, __], // R6 = Rank 2: d2 (wB)
        [__, __, __, __, wK, __, __, __], // R7 = Rank 1: e1 (wK)
      ]);
      gamestate.calculateLegalMoves();

      // wB at d2 is pinned on a5-e1 diagonal.
      // Moving wB to e3 or f4 exposes wK to bB at a5.
      expect(gamestate.legalMoves, isNot(contains(const Move(PieceType.bishop, 'd2', 'e3'))));
      expect(gamestate.legalMoves, isNot(contains(const Move(PieceType.bishop, 'd2', 'f4'))));

      // Moving along the pin diagonal (c3, b4, a5) is allowed.
      expect(gamestate.legalMoves, contains(const Move(PieceType.bishop, 'd2', 'c3')));
      expect(gamestate.legalMoves, contains(const Move(PieceType.bishop, 'd2', 'a5'))); // capture pinning bB
    });
  });
}
