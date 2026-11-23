import 'dart:async';

class Clock {
  final int _initialMilliseconds;
  final Stopwatch _stopwatch = Stopwatch();
  Completer<void>? _timeoutCompleter;
  Timer? _timeoutTimer;
  bool _isRunning = false;

  Clock({required int ms})
      : _initialMilliseconds = ms < 0 ? 0 : ms;

  /// Live remaining time, clamped at 0.
  int get remainingMilliseconds {
    final left = _initialMilliseconds - _stopwatch.elapsedMilliseconds;
    return left > 0 ? left : 0;
  }

  bool get isPaused => _isRunning && !_stopwatch.isRunning;
  bool get isRunning => _isRunning;
  bool get isFinished => remainingMilliseconds <= 0;

  /// Future that completes as soon as remainingMilliseconds reaches 0.
  Future<void> get onTimeout {
    if (isFinished) return Future.value();
    _timeoutCompleter ??= Completer<void>();
    return _timeoutCompleter!.future;
  }

  /// Starts or resumes ticking down.
  void startOrResume() {
    if (isFinished || _stopwatch.isRunning) return;
    _isRunning = true;
    _stopwatch.start();
    _scheduleTimeoutCheck();
  }

  /// Pauses the clock without losing elapsed time.
  void pause() {
    if (!_stopwatch.isRunning) return;
    _stopwatch.stop();
    _timeoutTimer?.cancel();
    _timeoutTimer = null;
  }

  /// Stops the clock permanently and cleans up timers.
  void dispose() {
    _stopwatch.stop();
    _timeoutTimer?.cancel();
    _timeoutTimer = null;
    _isRunning = false;
    if (_timeoutCompleter != null && !_timeoutCompleter!.isCompleted) {
      _timeoutCompleter!.complete();
    }
  }

  void _scheduleTimeoutCheck() {
    _timeoutTimer?.cancel();
    _timeoutTimer = null;

    if (!_stopwatch.isRunning) return;

    final left = remainingMilliseconds;
    if (left <= 0) {
      _stopwatch.stop();
      _isRunning = false;
      if (_timeoutCompleter != null && !_timeoutCompleter!.isCompleted) {
        _timeoutCompleter!.complete();
      }
      return;
    }

    // Arm a single timer for the exact remaining milliseconds.
    _timeoutTimer = Timer(Duration(milliseconds: left), _scheduleTimeoutCheck);
  }
}
