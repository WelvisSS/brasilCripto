import 'sparkline_in_7d_model.dart';

class CoinMarketDataModel {
  String id;
  String symbol;
  String name;
  String image;
  double currentPrice;
  int marketCap;
  int marketCapRank;
  double marketCapChangePercentage24H;
  SparklineIn7D sparklineIn7D;

  CoinMarketDataModel({
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

  factory CoinMarketDataModel.fromJson(Map<String, dynamic> json) =>
      CoinMarketDataModel(
        id: json["id"],
        symbol: json["symbol"],
        name: json["name"],
        image: json["image"],
        currentPrice: json["current_price"]?.toDouble(),
        marketCap: json["market_cap"],
        marketCapRank: json["market_cap_rank"],
        marketCapChangePercentage24H:
            json["market_cap_change_percentage_24h"]?.toDouble(),
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
