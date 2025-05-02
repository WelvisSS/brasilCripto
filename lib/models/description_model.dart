class Description {
  String en;

  Description({required this.en});

  factory Description.fromJson(Map<String, dynamic> json) =>
      Description(en: json["en"]);

  Map<String, dynamic> toJson() => {"en": en};
}
