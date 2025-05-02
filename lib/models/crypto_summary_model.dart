import 'sparkline_in_7d_model.dart';

class CryptoSummaryModel {
  String id;
  String symbol;
  String name;
  String image;
  double currentPrice;
  int marketCap;
  int marketCapRank;
  double marketCapChangePercentage24H;
  SparklineIn7D sparklineIn7D;

  CryptoSummaryModel({
    required this.id,
    required this.symbol,
    required this.name,
    required this.image,
    required this.currentPrice,
    required this.marketCap,
    required this.marketCapRank,
    required this.marketCapChangePercentage24H,
    required this.sparklineIn7D,
  });

  factory CryptoSummaryModel.fromJson(Map<String, dynamic> json) =>
      CryptoSummaryModel(
        id: json["id"],
        symbol: json["symbol"],
        name: json["name"],
        image: json["image"],
        currentPrice: json["current_price"]?.toDouble() ?? 0.0,
        marketCap: json["market_cap"] ?? 0,
        marketCapRank: json["market_cap_rank"] ?? 0,
        marketCapChangePercentage24H:
            (json["market_cap_change_percentage_24h"] ?? 0).toDouble(),
        sparklineIn7D: SparklineIn7D.fromJson(json["sparkline_in_7d"]),
      );

  Map<String, dynamic> toJson() => {
    "id": id,
    "symbol": symbol,
    "name": name,
    "image": image,
    "current_price": currentPrice,
    "market_cap": marketCap,
    "market_cap_rank": marketCapRank,
    "market_cap_change_percentage_24h": marketCapChangePercentage24H,
    "sparkline_in_7d": sparklineIn7D.toJson(),
  };
}
