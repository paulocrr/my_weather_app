import 'package:flutter/material.dart';
import 'package:my_weather_app/core/failures/failure.dart';
import 'package:my_weather_app/extensions/string_extensions.dart';
import 'package:my_weather_app/models/user_position.dart';
import 'package:my_weather_app/models/weather_response.dart';
import 'package:my_weather_app/services/position_service.dart';
import 'package:my_weather_app/services/weather_service.dart';
import 'package:my_weather_app/widgets/failure_shower.dart';
import 'package:my_weather_app/widgets/weather_item.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var isLoading = true;

  final weatherService = WeatherService();
  final positionService = PositionService();
  WeatherResponse? response;
  Failure? failure;

  @override
  void initState() {
    super.initState();

    getUserCurrentPosition();
  }

  void getUserCurrentPosition() async {
    final either = await positionService.getUserPosition();

    either.fold(
      (l) {
        failure = l;

        setState(() {
          isLoading = false;
        });
      },
      (r) {
        getWeatherByPosition(userPosition: r);
      },
    );
  }

  void getWeatherByPosition({required UserPosition userPosition}) async {
    final either =
        await weatherService.getWeatherByPosition(position: userPosition);

    either.fold((l) {
      failure = l;
    }, (r) {
      response = r;
    });

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff4f4fc),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SafeArea(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (failure != null) ...[
                    FailureShower(
                      failure: failure!,
                      onRetry: () => updateWeatherInformation(),
                    )
                  ] else if (response != null) ...[
                    _WeatherInformation(response: response!),
                    ElevatedButton(
                      onPressed: () => updateWeatherInformation(),
                      child: const Text('Actualizar información'),
                    )
                  ]
                ],
              ),
            ),
    );
  }

  void updateWeatherInformation() {
    setState(() {
      isLoading = true;
    });

    getUserCurrentPosition();
  }
}

class _WeatherInformation extends StatelessWidget {
  final WeatherResponse response;

  const _WeatherInformation({required this.response});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: SizedBox(
              height: 120,
              width: 120,
              child: response.weather.first.main.getWeatherSvg,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Temperatura: ${response.temperatureInformation.temp} Celsius',
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Descripción: ${response.weather.first.description}',
            style: const TextStyle(fontSize: 16),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0),
            child: Divider(color: Colors.blueGrey),
          ),
          WeatherItem(
            icon: 'assets/svgs/wind_speed.svg',
            text: 'Velocidad del viento',
            value: '${response.wind.speed} Km/h',
          ),
          WeatherItem(
            icon: 'assets/svgs/angle.svg',
            text: 'Angulo del viento',
            value: '${response.wind.deg} grados',
          ),
        ],
      ),
    );
  }
}
