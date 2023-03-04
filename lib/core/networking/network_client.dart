import 'dart:io';

import 'package:dio/dio.dart';
import 'package:my_weather_app/core/config/configuration.dart';
import 'package:my_weather_app/core/exceptions/not_found_exception.dart';
import 'package:my_weather_app/core/exceptions/offline_exception.dart';
import 'package:my_weather_app/core/exceptions/server_exception.dart';
import 'package:my_weather_app/core/exceptions/unauthorized_exception.dart';

class NetworkClient {
  late Dio _dio;

  NetworkClient({Dio? dio}) {
    if (dio == null) {
      final options = BaseOptions(
        baseUrl: Configuration.baseUrl,
        headers: <String, dynamic>{
          'Accept': 'application/json',
          'Content-type': 'application/json'
        },
        responseType: ResponseType.json,
      );

      _dio = Dio(options);
    } else {
      _dio = dio;
    }
  }

  Future<dynamic> request({
    HttpMethod method = HttpMethod.get,
    required String path,
    Map<String, dynamic> param = const {},
  }) async {
    Response<dynamic> response;

    try {
      param['appid'] = Configuration.apiKey;

      switch (method) {
        case HttpMethod.get:
          response = await _dio.get(path, queryParameters: param);
          break;
      }

      final responseBody = response.data;

      if (responseBody != null) {
        return responseBody;
      }

      throw const ServerException(message: 'Server Error');
    } on DioError catch (e) {
      if (e.error is SocketException) {
        throw const OfflineException(message: 'No internet connection');
      } else {
        final errorResponse = e.response;

        if (errorResponse != null) {
          if (errorResponse.statusCode == HttpErrorCodes.unauthorized) {
            throw UnauthorizedException(
                message: errorResponse.statusMessage ?? '');
          } else if (errorResponse.statusCode == HttpErrorCodes.notFound) {
            throw NotFoundException(message: errorResponse.statusMessage ?? '');
          }
        }
      }
    }
  }
}

enum HttpMethod { get }

abstract class HttpErrorCodes {
  static const unauthorized = 401;
  static const notFound = 404;
}
