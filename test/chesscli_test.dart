import 'package:voidchess/engine/gamestate.dart';
import 'package:voidchess/engine/pieces.dart';
import 'package:test/test.dart';

void main() {
  test('Print All Added Legal Moves', () {
    // ignore: constant_identifier_names
    const __ = null;
    var gamestate = GameState.atPosition(Player.white, [
      [__, __, __, __, __, __, __, wB],
      [__, __, __, __, __, __, wB, __],
      [__, __, __, __, __, __, __, __],
      [__, __, __, __, __, __, __, __],
      [__, __, __, __, __, __, __, __],
      [__, __, __, __, __, __, __, __],
      [__, __, __, __, __, __, bp, __],
      [__, __, __, __, __, __, __, wB],
    ]);
    gamestate.calculateLegalMoves();
    print(gamestate.legalMoves);
    expect(gamestate.legalMoves, allOf([
      //contains(''),
      //isNot(contains(''))
    ]));
  });
test('Print All Added Legal Moves', () {
    // ignore: constant_identifier_names
    const __ = null;
    var gamestate = GameState.atPosition(Player.white, [
      [__, __, __, __, __, __, __, __],
      [__, __, __, __, __, __, __, __],
      [__, wQ, __, __, __, __, __, __],
      [__, __, __, __, __, __, __, __],
      [__, __, __, __, __, __, __, __],
      [__, __, __, __, __, __, __, __],
      [__, __, __, __, __, __, __, __],
      [__, __, __, __, __, __, __, __],
    ]);
    gamestate.calculateLegalMoves();
    print(gamestate.legalMoves);
    expect(gamestate.legalMoves, allOf([
    ]));
  });

}
