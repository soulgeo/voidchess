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
      [__, __, __, __, __, __, wN, __],
      [__, __, __, __, __, __, __, __],
      [__, __, __, __, __, __, wR, __],
      [__, __, bB, __, __, __, __, __],
      [__, __, __, wN, __, __, __, __],
      [__, wN, __, __, __, __, bK, __],
    ]);
    gamestate.calculateLegalMoves();
    print(gamestate.legalMoves);
    expect(gamestate.legalMoves, allOf([
      contains('R_g4_g5'),
      contains('R_g4_g3'),
      contains('R_g4_g2'),
      contains('R_g4_h4'),
      contains('R_g4_f4'),
      contains('R_g4_e4'),
      contains('R_g4_d4'),
      contains('R_g4_c4'),
      contains('R_g4_b4'),
      contains('R_g4_a4'),
      contains('R_g4_g1'),
      
      isNot(contains('R_g4_g9')),
      isNot(contains('R_g4_g0')),
      isNot(contains('R_g4_g8')),
      isNot(contains('R_g4_g7')),
      isNot(contains('R_g4_g6'))
    ]));
  });
}
