import 'package:voidchess/engine/gamestate.dart';
import 'package:voidchess/engine/pieces.dart';
import 'package:test/test.dart';

void main() {
  test('calculate knight legal moves', () {
    // ignore: constant_identifier_names
    const __ = null;
    var gamestate = GameState.atPosition(Player.white, [
      [__, __, __, __, bK, __, __, __],
      [__, __, __, __, __, __, __, __],
      [__, __, __, __, __, __, bN, __],
      [__, __, __, __, __, __, __, __],
      [__, __, __, __, __, __, wR, __],
      [__, __, bB, __, __, __, __, __],
      [__, __, __, wN, __, __, __, __],
      [__, wN, __, __, __, __, wK, __],
    ]);
    gamestate.calculateLegalMoves();
    expect(gamestate.legalMoves, allOf([
      contains('N_b1_a3'),
      contains('N_b1_c3'),
      contains('R_g4_g5'),
      contains('R_g4_g6'),
      contains('R_g4_g3'),
      contains('R_g4_g2'),
      
      isNot(contains('N_b1_d2')),
      isNot(contains('N_g6_h8')),
      isNot(contains('N_g4_g9')),
      isNot(contains('N_g4_g0')),
      isNot(contains('N_g4_g8')),
      isNot(contains('N_g4_g1')),
      isNot(contains('N_g4_g7')),
    ]));
  });
}
