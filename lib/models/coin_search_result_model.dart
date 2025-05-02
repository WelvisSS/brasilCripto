import 'coin_model.dart';

class CoinSearchResultModel {
  List<Coin> coins;
  CoinSearchResultModel({required this.coins});

  factory CoinSearchResultModel.fromJson(Map<String, dynamic> json) =>
      CoinSearchResultModel(
        coins: List<Coin>.from(json["coins"].map((x) => Coin.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
    "coins": List<dynamic>.from(coins.map((x) => x.toJson())),
  };
}
