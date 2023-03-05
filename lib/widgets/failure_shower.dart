import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:my_weather_app/core/failures/failure.dart';
import 'package:my_weather_app/core/failures/location_denied_failure.dart';
import 'package:my_weather_app/core/failures/not_found_failure.dart';
import 'package:my_weather_app/core/failures/offline_failure.dart';
import 'package:my_weather_app/core/failures/server_failure.dart';
import 'package:my_weather_app/core/failures/unauthorized_failure.dart';

class FailureShower extends StatelessWidget {
  final Failure failure;
  final VoidCallback? onRetry;

  const FailureShower({super.key, required this.failure, this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _FailureAnimation(failure: failure),
        if (onRetry != null)
          ElevatedButton(
            onPressed: onRetry,
            child: const Text('Reintentar'),
          )
      ],
    );
  }
}

class _FailureAnimation extends StatelessWidget {
  final Failure failure;

  const _FailureAnimation({required this.failure});

  @override
  Widget build(BuildContext context) {
    if (failure is OfflineFailure) {
      return Lottie.asset('assets/animations/offline_animation.json');
    } else if (failure is NotFoundFailure) {
      return Column(
        children: [
          Lottie.asset('assets/animations/not_found_animation.json'),
          const Text('No se encontro el clima de la ubicación')
        ],
      );
    } else if (failure is ServerFailure) {
      return Lottie.asset('assets/animations/server_error_animation.json');
    } else if (failure is UnauthorizedFailure) {
      return Lottie.asset('assets/animations/unauthorized_animation.json');
    } else if (failure is LocationDeniedFailure) {
      return Column(
        children: [
          Lottie.asset('assets/animations/location_denied_animation.json'),
          const Text(
            'Permisos de ubicación denegados',
            style: TextStyle(fontWeight: FontWeight.bold),
          )
        ],
      );
    }
    return Lottie.asset('assets/animations/error_animation.json');
  }
}
