class Wind {
  final double speed;
  final int deg;

  Wind({
    required this.speed,
    required this.deg,
  });

  factory Wind.fromMap(Map<String, dynamic> json) => Wind(
        speed: json["speed"].toDouble(),
        deg: json["deg"],
      );

  Map<String, dynamic> toMap() => {
        "speed": speed,
        "deg": deg,
      };
}
