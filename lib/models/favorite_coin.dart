class FavoriteCoin {
  final String id;
  final String name;
  final String symbol;
  String image;

  FavoriteCoin({
    required this.id,
    required this.name,
    required this.symbol,
    required this.image,
  });

  factory FavoriteCoin.fromJson(Map<String, dynamic> json) {
    return FavoriteCoin(
      id: json['id'],
      name: json['name'],
      symbol: json['symbol'],
      image: json['image'],
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'symbol': symbol,
    'image': image,
  };
}
