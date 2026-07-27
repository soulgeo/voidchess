import 'package:voidchess/engine/gamestate.dart';
import 'package:voidchess/engine/pieces.dart';
import 'package:test/test.dart';

// ignore: constant_identifier_names
const __ = null;

void main() {
  group('Default Starting Position Legal Moves', () {
    test('White default starting position has 20 legal moves according to chess rules', () {
      final gamestate = GameState();
      gamestate.calculateLegalMoves();

      expect(gamestate.legalMoves.length, equals(20));

      final pawnMoves = gamestate.legalMoves.where((m) => m.startsWith('p_')).toList();
      expect(pawnMoves.length, equals(16));
      expect(
        pawnMoves,
        containsAll([
          'p_a2_a3', 'p_a2_a4',
          'p_b2_b3', 'p_b2_b4',
          'p_c2_c3', 'p_c2_c4',
          'p_d2_d3', 'p_d2_d4',
          'p_e2_e3', 'p_e2_e4',
          'p_f2_f3', 'p_f2_f4',
          'p_g2_g3', 'p_g2_g4',
          'p_h2_h3', 'p_h2_h4',
        ]),
      );

      final knightMoves = gamestate.legalMoves.where((m) => m.startsWith('N_')).toList();
      expect(knightMoves.length, equals(4));
      expect(
        knightMoves,
        containsAll(['N_b1_a3', 'N_b1_c3', 'N_g1_f3', 'N_g1_h3']),
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

      final pawnMoves = gamestate.legalMoves.where((m) => m.startsWith('p_')).toList();
      expect(pawnMoves.length, equals(16));
      expect(
        pawnMoves,
        containsAll([
          'p_a7_a6', 'p_a7_a5',
          'p_b7_b6', 'p_b7_b5',
          'p_c7_c6', 'p_c7_c5',
          'p_d7_d6', 'p_d7_d5',
          'p_e7_e6', 'p_e7_e5',
          'p_f7_f6', 'p_f7_f5',
          'p_g7_g6', 'p_g7_g5',
          'p_h7_h6', 'p_h7_h5',
        ]),
      );

      final knightMoves = gamestate.legalMoves.where((m) => m.startsWith('N_')).toList();
      expect(knightMoves.length, equals(4));
      expect(
        knightMoves,
        containsAll(['N_b8_a6', 'N_b8_c6', 'N_g8_f6', 'N_g8_h6']),
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
      final pawnMoves = gamestate.legalMoves.where((m) => m.startsWith('p_')).toList();
      expect(pawnMoves, unorderedEquals(['p_e2_e3', 'p_e2_e4']));
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
      final pawnMoves = gamestate.legalMoves.where((m) => m.startsWith('p_')).toList();
      expect(pawnMoves, equals(['p_e5_e6']));
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
      expect(gamestate.legalMoves, isNot(contains('p_e2_e3')));
      expect(gamestate.legalMoves, isNot(contains('p_e2_e4')));
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

      expect(gamestate.legalMoves, contains('p_e4_d5'));
      expect(gamestate.legalMoves, contains('p_e4_f5'));
      expect(gamestate.legalMoves, contains('p_e4_e5'));
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

      expect(gamestate.legalMoves, isNot(contains('p_e4_d5'))); // friendly square
      expect(gamestate.legalMoves, isNot(contains('p_e4_f5'))); // empty square
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

      expect(gamestate.legalMoves, contains('p_d6_c5'));
      expect(gamestate.legalMoves, contains('p_d6_d5'));
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
        gamestate.legalMoves.where((m) => m.startsWith('N_')).toList(),
        unorderedEquals([
          'N_d5_c7', 'N_d5_e7',
          'N_d5_b6', 'N_d5_f6',
          'N_d5_b4', 'N_d5_f4',
          'N_d5_c3', 'N_d5_e3',
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
        gamestate.legalMoves.where((m) => m.startsWith('N_')).toList(),
        unorderedEquals(['N_a1_b3', 'N_a1_c2']),
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

      expect(gamestate.legalMoves, isNot(contains('N_d4_e6'))); // friendly piece on e6
      expect(gamestate.legalMoves, contains('N_d4_c6'));        // enemy piece on c6
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
        gamestate.legalMoves.where((m) => m.startsWith('R_')).toList(),
        unorderedEquals([
          'R_d4_d5', 'R_d4_d6', 'R_d4_d7', 'R_d4_d8',
          'R_d4_d3', 'R_d4_d2', 'R_d4_d1',
          'R_d4_c4', 'R_d4_b4', 'R_d4_a4',
          'R_d4_e4', 'R_d4_f4', 'R_d4_g4', 'R_d4_h4',
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

      expect(gamestate.legalMoves, contains('R_d4_d5'));
      expect(gamestate.legalMoves, isNot(contains('R_d4_d6')));
      expect(gamestate.legalMoves, isNot(contains('R_d4_d7')));

      expect(gamestate.legalMoves, contains('R_d4_c4'));
      expect(gamestate.legalMoves, contains('R_d4_b4'));
      expect(gamestate.legalMoves, isNot(contains('R_d4_a4')));
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
        gamestate.legalMoves.where((m) => m.startsWith('B_')).toList(),
        unorderedEquals([
          'B_d4_e5', 'B_d4_f6', 'B_d4_g7', 'B_d4_h8',
          'B_d4_c5', 'B_d4_b6', 'B_d4_a7',
          'B_d4_c3', 'B_d4_b2', 'B_d4_a1',
          'B_d4_e3', 'B_d4_f2', 'B_d4_g1',
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

      expect(gamestate.legalMoves, contains('B_d4_e5'));
      expect(gamestate.legalMoves, isNot(contains('B_d4_f6')));
      expect(gamestate.legalMoves, isNot(contains('B_d4_g7')));

      expect(gamestate.legalMoves, contains('B_d4_c3'));
      expect(gamestate.legalMoves, contains('B_d4_b2'));
      expect(gamestate.legalMoves, isNot(contains('B_d4_a1')));
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
        gamestate.legalMoves.where((m) => m.startsWith('Q_')).toList(),
        unorderedEquals([
          'Q_d4_d5', 'Q_d4_d6', 'Q_d4_d7', 'Q_d4_d8',
          'Q_d4_d3', 'Q_d4_d2', 'Q_d4_d1',
          'Q_d4_c4', 'Q_d4_b4', 'Q_d4_a4',
          'Q_d4_e4', 'Q_d4_f4', 'Q_d4_g4', 'Q_d4_h4',
          'Q_d4_e5', 'Q_d4_f6', 'Q_d4_g7', 'Q_d4_h8',
          'Q_d4_c5', 'Q_d4_b6', 'Q_d4_a7',
          'Q_d4_c3', 'Q_d4_b2', 'Q_d4_a1',
          'Q_d4_e3', 'Q_d4_f2', 'Q_d4_g1',
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

      expect(gamestate.legalMoves, contains('Q_d4_d5'));
      expect(gamestate.legalMoves, isNot(contains('Q_d4_d6')));

      expect(gamestate.legalMoves, contains('Q_d4_e4'));
      expect(gamestate.legalMoves, contains('Q_d4_f4'));
      expect(gamestate.legalMoves, isNot(contains('Q_d4_g4')));
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
        gamestate.legalMoves.where((m) => m.startsWith('K_')).toList(),
        unorderedEquals([
          'K_d4_c5', 'K_d4_d5', 'K_d4_e5',
          'K_d4_c4',           'K_d4_e4',
          'K_d4_c3', 'K_d4_d3', 'K_d4_e3',
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
        gamestate.legalMoves.where((m) => m.startsWith('K_')).toList(),
        unorderedEquals(['K_a1_a2', 'K_a1_b2', 'K_a1_b1']),
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

      expect(gamestate.legalMoves, isNot(contains('K_d4_e5'))); // friendly piece on e5
      expect(gamestate.legalMoves, contains('K_d4_c5'));        // enemy piece on c5 (capture)
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
      expect(gamestate.legalMoves, isNot(contains('K_d4_c3')));
      expect(gamestate.legalMoves, isNot(contains('K_d4_c4')));
      expect(gamestate.legalMoves, isNot(contains('K_d4_c5')));

      // wK at d4 CAN move to unattacked squares (d3, d5, e3, e4, e5)
      expect(gamestate.legalMoves, contains('K_d4_d3'));
      expect(gamestate.legalMoves, contains('K_d4_d5'));
      expect(gamestate.legalMoves, contains('K_d4_e3'));
      expect(gamestate.legalMoves, contains('K_d4_e4'));
      expect(gamestate.legalMoves, contains('K_d4_e5'));
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
      expect(gamestate.legalMoves, isNot(contains('R_e4_d4')));
      expect(gamestate.legalMoves, isNot(contains('R_e4_f4')));

      // Moving along the pin ray (e.g. e2, e3, e5, e6, e7, e8) keeps King protected.
      expect(gamestate.legalMoves, contains('R_e4_e5'));
      expect(gamestate.legalMoves, contains('R_e4_e8')); // capture checking bR
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
      expect(gamestate.legalMoves, isNot(contains('B_d2_e3')));
      expect(gamestate.legalMoves, isNot(contains('B_d2_f4')));

      // Moving along the pin diagonal (c3, b4, a5) is allowed.
      expect(gamestate.legalMoves, contains('B_d2_c3'));
      expect(gamestate.legalMoves, contains('B_d2_a5')); // capture pinning bB
    });
  });
}
