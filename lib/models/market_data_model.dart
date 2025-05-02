class MarketData {
  Map<String, double> currentPrice;
  Map<String, double> marketCap;

  MarketData({required this.currentPrice, required this.marketCap});

  factory MarketData.fromJson(Map<String, dynamic> json) => MarketData(
    currentPrice: Map.from(
      json["current_price"],
    ).map((k, v) => MapEntry<String, double>(k, v?.toDouble())),
    marketCap: Map.from(
      json["market_cap"],
    ).map((k, v) => MapEntry<String, double>(k, v?.toDouble())),
  );

  Map<String, dynamic> toJson() => {
    "current_price": Map.from(
      currentPrice,
    ).map((k, v) => MapEntry<String, dynamic>(k, v)),
    "market_cap": Map.from(
      marketCap,
    ).map((k, v) => MapEntry<String, dynamic>(k, v)),
  };
}
