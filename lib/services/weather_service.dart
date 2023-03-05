import 'package:dartz/dartz.dart';
import 'package:my_weather_app/core/exceptions/not_found_exception.dart';
import 'package:my_weather_app/core/exceptions/offline_exception.dart';
import 'package:my_weather_app/core/exceptions/server_exception.dart';
import 'package:my_weather_app/core/exceptions/unauthorized_exception.dart';
import 'package:my_weather_app/core/failures/failure.dart';
import 'package:my_weather_app/core/failures/not_found_failure.dart';
import 'package:my_weather_app/core/failures/offline_failure.dart';
import 'package:my_weather_app/core/failures/server_failure.dart';
import 'package:my_weather_app/core/failures/unauthorized_failure.dart';
import 'package:my_weather_app/core/failures/unknown_exceptions.dart';
import 'package:my_weather_app/core/networking/network_client.dart';
import 'package:my_weather_app/models/user_position.dart';
import 'package:my_weather_app/models/weather_response.dart';

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

  Future<Either<Failure, WeatherResponse>> getWeatherByPosition({
    required UserPosition position,
  }) async {
    try {
      final response = await _networkClient.request(
        path: _path,
        param: {
          'lat': '${position.lat}',
          'lon': '${position.lon}',
          'units': 'metric',
        },
      ) as Map<String, dynamic>;

      return Right(WeatherResponse.fromMap(response));
    } on ServerException catch (exception) {
      return Left(ServerFailure(message: exception.message));
    } on NotFoundException catch (exception) {
      return Left(NotFoundFailure(message: exception.message));
    } on OfflineException catch (exception) {
      return Left(OfflineFailure(message: exception.message));
    } on UnauthorizedException catch (exception) {
      return Left(UnauthorizedFailure(message: exception.message));
    } catch (exception) {
      return Left(UnknownFailure(message: exception.toString()));
    }
  }
}
