import 'package:voidchess/engine/gamestate.dart';
import 'package:voidchess/engine/pieces.dart';
import 'package:test/test.dart';

void main() {
  test('Bishop moves', () {
    // ignore: constant_identifier_names
    const __ = null;
    var gamestate = GameState.atPosition(Player.white, [
        [__, bK, __, __, __, __, __, wB],
        [__, __, __, __, __, __, wB, __],
        [__, __, __, __, __, __, __, __],
        [__, __, __, __, __, __, __, __],
        [__, __, __, __, __, __, __, __],
        [__, __, __, __, __, __, __, __],
        [__, __, __, __, __, __, bp, __],
        [__, __, __, wK, __, __, __, wB],
    ]);
    gamestate.calculateLegalMoves();
    // print(gamestate.legalMoves);
    expect(gamestate.legalMoves, allOf([
          contains('B_g7_f8'),
          contains('B_g7_h6'),
          contains('B_g7_f6'),
          contains('B_g7_e5'),
          contains('B_g7_d4'),
          contains('B_g7_c3'),
          contains('B_g7_b2'),
          contains('B_g7_b1'),
          contains('B_h1_g2'),
          isNot(contains('B_g7_h8')),
    ]));
  });
}
