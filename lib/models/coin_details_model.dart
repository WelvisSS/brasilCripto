import 'description_model.dart';
import 'image_model.dart';
import 'market_data_model.dart';

class CoinDetailsModel {
  String id;
  String symbol;
  Description description;
  Image image;
  MarketData marketData;

  CoinDetailsModel({
    required this.id,
    required this.symbol,
    required this.description,
    required this.image,
    required this.marketData,
  });

  factory CoinDetailsModel.fromJson(Map<String, dynamic> json) =>
      CoinDetailsModel(
        id: json["id"],
        symbol: json["symbol"],
        description: Description.fromJson(json["description"]),
        image: Image.fromJson(json["image"]),
        marketData: MarketData.fromJson(json["market_data"]),
      );

  Map<String, dynamic> toJson() => {
    "id": id,
    "symbol": symbol,
    "description": description.toJson(),
    "image": image.toJson(),
    "market_data": marketData.toJson(),
  };
}
