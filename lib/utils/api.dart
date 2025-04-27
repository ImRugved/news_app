import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'global.dart';

class API {
  final Dio _dio = Dio();

  API() {
    _dio.options.baseUrl = Global.hostUrl;
    _dio.options.connectTimeout = const Duration(seconds: 30);
    _dio.options.receiveTimeout = const Duration(seconds: 30);
    _dio.options.headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    // Add logger for debug mode
    _dio.interceptors.add(PrettyDioLogger(
      requestHeader: true,
      requestBody: true,
      responseHeader: true,
      responseBody: true,
      error: true,
      compact: true,
    ));

    // Add interceptor for API key
    _dio.interceptors.add(InterceptorsWrapper(onRequest: (options, handler) {
      // Add API key to all requests
      final url = options.path;
      final separator = url.contains('?') ? '&' : '?';
      options.path = '$url${separator}apiKey=${Global.apiKey}';
      return handler.next(options);
    }, onError: (DioException error, handler) {
      // Handle common errors
      print('API Error: ${error.message}');
      return handler.next(error);
    }));
  }

  Dio get sendRequest => _dio;
}
