String formatCurrency(double value) {
  final intValue = value.round();
  final buffer = StringBuffer();
  final digits = intValue.toString();
  for (var i = 0; i < digits.length; i++) {
    final position = digits.length - i;
    buffer.write(digits[i]);
    if (position > 1 && position % 3 == 1) {
      buffer.write('.');
    }
  }
  return '${buffer.toString()} đ';
}
