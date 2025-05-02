class SparklineIn7D {
  List<double> price;

  SparklineIn7D({required this.price});

  factory SparklineIn7D.fromJson(Map<String, dynamic> json) => SparklineIn7D(
    price: List<double>.from(json["price"].map((x) => x?.toDouble())),
  );

  Map<String, dynamic> toJson() => {
    "price": List<dynamic>.from(price.map((x) => x)),
  };
}
