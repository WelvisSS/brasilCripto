class MarketChartModel {
  List<List<double>> prices;

  MarketChartModel({required this.prices});

  factory MarketChartModel.fromJson(Map<String, dynamic> json) =>
      MarketChartModel(
        prices: List<List<double>>.from(
          json["prices"].map(
            (x) => List<double>.from(x.map((x) => x?.toDouble())),
          ),
        ),
      );

  Map<String, dynamic> toJson() => {
    "prices": List<dynamic>.from(
      prices.map((x) => List<dynamic>.from(x.map((x) => x))),
    ),
  };
}
