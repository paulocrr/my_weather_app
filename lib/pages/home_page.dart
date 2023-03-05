import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:my_weather_app/core/failures/failure.dart';
import 'package:my_weather_app/core/failures/location_denied_failure.dart';
import 'package:my_weather_app/core/failures/not_found_failure.dart';
import 'package:my_weather_app/core/failures/offline_failure.dart';
import 'package:my_weather_app/models/user_position.dart';
import 'package:my_weather_app/models/weather_response.dart';
import 'package:my_weather_app/services/position_service.dart';
import 'package:my_weather_app/services/weather_service.dart';

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
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
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
                    ] else if (failure is LocationDeniedFailure) ...[
                      ElevatedButton(
                        onPressed: () async {
                          await Geolocator.openLocationSettings();
                        },
                        child: const Text('Reintentar'),
                      )
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
