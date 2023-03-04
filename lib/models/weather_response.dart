import 'package:my_weather_app/models/temperature_information.dart';
import 'package:my_weather_app/models/weather.dart';
import 'package:my_weather_app/models/wind.dart';

class WeatherResponse {
  final List<Weather> weather;
  final TemperatureInformation temperatureInformation;
  final Wind wind;

  WeatherResponse({
    required this.weather,
    required this.temperatureInformation,
    required this.wind,
  });

  factory WeatherResponse.fromMap(Map<String, dynamic> json) => WeatherResponse(
        weather: List<Weather>.from(
          json["weather"].map(
            (x) => Weather.fromMap(x),
          ),
        ),
        temperatureInformation: TemperatureInformation.fromMap(json["main"]),
        wind: Wind.fromMap(json["wind"]),
      );

  Map<String, dynamic> toMap() => {
        "weather": List<dynamic>.from(
          weather.map(
            (x) => x.toMap(),
          ),
        ),
        "temperature_information": temperatureInformation.toMap(),
        "wind": wind.toMap(),
      };
}
