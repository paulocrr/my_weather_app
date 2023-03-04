import 'package:my_weather_app/core/networking/network_client.dart';

class WeatherService {
  late NetworkClient _networkClient;
  final _path = '/weather';

  WeatherService({NetworkClient? networkClient}) {
    if (networkClient == null) {
      _networkClient = NetworkClient();
    } else {
      _networkClient = networkClient;
    }
  }
}
