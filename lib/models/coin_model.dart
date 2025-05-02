class Coin {
  String id;
  String name;
  String symbol;
  int marketCapRank;
  String thumb;

  Coin({
    required this.id,
    required this.name,
    required this.symbol,
    required this.marketCapRank,
    required this.thumb,
  });

  factory Coin.fromJson(Map<String, dynamic> json) => Coin(
    id: json["id"],
    name: json["name"],
    symbol: json["symbol"],
    marketCapRank: json["market_cap_rank"],
    thumb: json["thumb"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "symbol": symbol,
    "market_cap_rank": marketCapRank,
    "thumb": thumb,
  };
}
