class Image {
  String thumb;
  String small;
  String large;

  Image({required this.thumb, required this.small, required this.large});

  factory Image.fromJson(Map<String, dynamic> json) =>
      Image(thumb: json["thumb"], small: json["small"], large: json["large"]);

  Map<String, dynamic> toJson() => {
    "thumb": thumb,
    "small": small,
    "large": large,
  };
}
