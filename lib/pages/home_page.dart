import 'package:flutter/material.dart';
import 'package:my_weather_app/core/failures/failure.dart';
import 'package:my_weather_app/core/failures/not_found_failure.dart';
import 'package:my_weather_app/core/failures/offline_failure.dart';
import 'package:my_weather_app/models/user_position.dart';
import 'package:my_weather_app/models/weather_response.dart';
import 'package:my_weather_app/services/weather_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var isLoading = true;

  final service = WeatherService();
  WeatherResponse? response;
  Failure? failure;

  @override
  void initState() {
    super.initState();

    getWeatherByPosition();
  }

  void getWeatherByPosition() async {
    final either = await service.getWeatherByPosition(
        position: UserPosition(lat: 44.34, lon: 10.99));

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
      body: isLoading
          ? Center(
              child: const CircularProgressIndicator(),
            )
          : SafeArea(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (failure != null) ...[
                    if (failure is OfflineFailure) ...[
                      const Text('Usted no tiene internet')
                    ] else if (failure is NotFoundFailure) ...[
                      const Text('No hay data para su zona')
                    ] else ...[
                      Text(failure!.message)
                    ]
                  ] else if (response != null) ...[
                    Center(
                      child: Text(
                        '${response!.temperatureInformation.temp}',
                        style: TextStyle(fontSize: 32),
                      ),
                    )
                  ]
                ],
              ),
            ),
    );
  }
}
