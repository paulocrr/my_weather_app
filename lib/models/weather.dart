class Weather {
  final String main;
  final String description;
  final String icon;

  Weather({
    required this.main,
    required this.description,
    required this.icon,
  });

  factory Weather.fromMap(Map<String, dynamic> json) => Weather(
        main: json["main"],
        description: json["description"],
        icon: json["icon"],
      );

  Map<String, dynamic> toMap() => {
        "main": main,
        "description": description,
        "icon": icon,
      };
}
