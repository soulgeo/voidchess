import 'dart:async';
import 'package:voidchess/engine/clock.dart';
import 'package:voidchess/engine/gamestate.dart';
import 'package:voidchess/engine/types.dart';

typedef MoveProvider = Future<dynamic> Function();

enum _MoveWaitOutcome { moveReceived, timedOut }

class GameLoop {
  final gamestate = GameState();
  final MoveProvider getNextMove;
  final Map<Player, Clock> clocks = {
    Player.white: Clock(ms: 300000),
    Player.black: Clock(ms: 300000),
  };
  Player? winner;

  GameLoop({required this.getNextMove});

  Clock clockFor(Player player) => clocks[player]!;

  Future<void> run() async {
    final whiteClock = clockFor(Player.white);
    final blackClock = clockFor(Player.black);

    // White starts on the clock; Black starts paused.
    whiteClock.startOrResume();
    blackClock.pause();

    try {
      while (true) {
        final currentPlayer = gamestate.turnPlayer;
        final activeClock = clockFor(currentPlayer);

        if (gamestate.legalMoves.isEmpty || activeClock.isFinished) {
          winner = currentPlayer * -1;
          break;
        }

        final moveFuture = getNextMove();

        // Wait for the next move or for the clock to time out.
        final outcome = await Future.any<_MoveWaitOutcome>([
          moveFuture.then((_) => _MoveWaitOutcome.moveReceived),
          activeClock.onTimeout.then((_) => _MoveWaitOutcome.timedOut),
        ]);

        if (outcome == _MoveWaitOutcome.timedOut || activeClock.isFinished) {
          winner = currentPlayer * -1;
          break;
        }

        final move = await moveFuture;

        if (gamestate.legalMoves.contains(move)) {
          gamestate.applyMove(move);

          if (gamestate.turnPlayer == Player.white) {
            blackClock.pause();
            whiteClock.startOrResume();
          } else {
            whiteClock.pause();
            blackClock.startOrResume();
          }
        }
      }
    } finally {
      whiteClock.dispose();
      blackClock.dispose();
    }
  }
}
