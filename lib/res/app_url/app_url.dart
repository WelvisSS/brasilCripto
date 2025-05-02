class AppUrl {
  static const String baseUrl = 'https://api.coingecko.com/api/v3';

  static String coinMarkets({
    String vsCurrency = 'usd',
    String order = 'market_cap_desc',
    int perPage = 10,
    int page = 1,
    bool sparkline = true,
    String priceChangePercentage = '24h',
  }) =>
      '$baseUrl/coins/markets?vs_currency=$vsCurrency&order=$order&per_page=$perPage&page=$page&sparkline=$sparkline&price_change_percentage=$priceChangePercentage';

  static String coinSearch(String query) => '$baseUrl/search?query=$query';

  static String coinDetails(String coinId) => '$baseUrl/coins/$coinId';

  static String coinMarketChart(
    String coinId, {
    String vsCurrency = 'usd',
    int days = 7,
    String interval = 'daily',
  }) =>
      '$baseUrl/coins/$coinId/market_chart?vs_currency=$vsCurrency&days=$days&interval=$interval';

  static String specificCoinsMarket({
    String vsCurrency = 'usd',
    required List<String> ids,
    String order = 'market_cap_desc',
    bool sparkline = true,
    String priceChangePercentage = '24h',
  }) {
    final idsParam = ids.join(',');
    return '$baseUrl/coins/markets?vs_currency=$vsCurrency&ids=$idsParam&order=$order&sparkline=$sparkline&price_change_percentage=$priceChangePercentage';
  }
}
