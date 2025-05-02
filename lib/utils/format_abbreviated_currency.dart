String formatAbbreviatedCurrency(num value, {String currencySymbol = '\$'}) {
  String truncate(num number) {
    final str = number.toStringAsFixed(10); // muita precisão para cortar
    final parts = str.split('.');
    final decimal = parts[1].substring(0, 2); // pega só as duas primeiras casas
    return '${parts[0]}.$decimal';
  }

  if (value >= 1e12) {
    return '$currencySymbol ${truncate(value / 1e12)} T';
  } else if (value >= 1e9) {
    return '$currencySymbol ${truncate(value / 1e9)} B';
  } else if (value >= 1e6) {
    return '$currencySymbol ${truncate(value / 1e6)} M';
  } else if (value >= 1e3) {
    return '$currencySymbol ${truncate(value / 1e3)} K';
  } else {
    return '$currencySymbol ${truncate(value)}';
  }
}
