String formatPercentageChange(double value) {
  final prefix = value >= 0 ? '+' : '';
  final truncated = value.toStringAsFixed(2);
  return '$prefix$truncated %';
}
