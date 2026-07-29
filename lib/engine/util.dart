extension type ChessFile(String value) {
  /// Allows doing `file + 1`
  String operator +(int amount) {
    if (value.isEmpty) return '';
    int newVal = value.codeUnitAt(0) + amount;
    if (newVal < 97 || newVal > 104) return '';
    return String.fromCharCode(newVal);
  }

  /// Allows doing `file - 1`
  String operator -(int amount) => this + (-amount);
}
