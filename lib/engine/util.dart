extension ChessFileOps on String {
  /// Shifts a file character ('a'-'h') by a given amount.
  /// Returns an empty string if the shift goes off the board.
  String shiftFile(int amount) {
    if (isEmpty) return '';

    int currentVal = codeUnitAt(0);
    int newVal = currentVal + amount;

    // Check bounds: 'a' is 97, 'h' is 104
    if (newVal < 97 || newVal > 104) {
      return ''; // Off the edge of the board
    }

    return String.fromCharCode(newVal);
  }

  String get left => shiftFile(-1);
  String get right => shiftFile(1);
}
