import 'package:dartz/dartz.dart';
import 'package:geolocator/geolocator.dart';
import 'package:my_weather_app/core/failures/failure.dart';
import 'package:my_weather_app/core/failures/location_denied_failure.dart';
import 'package:my_weather_app/core/failures/location_disabled_failure.dart';
import 'package:my_weather_app/core/failures/unknown_failure.dart';
import 'package:my_weather_app/models/user_position.dart';

class PositionService {
  Future<Either<Failure, UserPosition>> getUserPosition() async {
    final serviceEnable = await Geolocator.isLocationServiceEnabled();

    if (!serviceEnable) {
      return Left(
        LocationDisabledFailure(message: 'Su gps esta deshabilitado'),
      );
    }

    var permissions = await Geolocator.checkPermission();

    switch (permissions) {
      case LocationPermission.unableToDetermine:
      case LocationPermission.denied:
      case LocationPermission.deniedForever:
        permissions = await Geolocator.requestPermission();

        if (permissions == LocationPermission.unableToDetermine ||
            permissions == LocationPermission.denied ||
            permissions == LocationPermission.deniedForever) {
          return Left(LocationDeniedFailure(
              message: 'Necesitamos acceso a su ubicacion'));
        }

        return Left(UnknownFailure(message: 'No se pudo obtener la ubicacion'));
      case LocationPermission.whileInUse:
      case LocationPermission.always:
        final currentPosition = await Geolocator.getCurrentPosition();

        return Right(
          UserPosition(
            lat: currentPosition.latitude,
            lon: currentPosition.longitude,
          ),
        );
    }
  }
}
