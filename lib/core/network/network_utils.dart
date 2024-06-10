import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:maids_task/core/network/api_consts.dart';

class NetworkUtils {
  // Singleton instance
  static final NetworkUtils _instance = NetworkUtils._internal();

  // Private Dio instance
  late Dio _dio;

  // Private constructor
  NetworkUtils._internal() {
    _dio = Dio(
      BaseOptions(
        baseUrl: ApiConstance.baseUrl,
        connectTimeout: const Duration(minutes: 12000),
        receiveTimeout: const Duration(milliseconds: 12000),
      ),
    );

    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        // Log request
        log('Request: ${options.method} ${options.path}');
        return handler.next(options); //continue
      },
      onResponse: (response, handler) {
        // Log response
        log('Response: ${response.statusCode} ${response.data}');
        return handler.next(response); // continue
      },
      onError: (DioException error, handler) {
        // Log error
        log('Error: ${error.response?.statusCode} ${error.message}');
        return handler.next(error); //continue
      },
    ));
  }

  // Factory constructor
  factory NetworkUtils() {
    return _instance;
  }

  // Method to get dio instance
  Dio get dio => _dio;

  // Example GET request
  Future<Response> get(String path,
      {Map<String, dynamic>? queryParameters}) async {
    try {
      final response = await _dio.get(path, queryParameters: queryParameters);
      return response;
    } catch (error) {
      _handleError(error);
      rethrow;
    }
  }

  // Example POST request
  Future<Response> post(String path,
      {dynamic data, Map<String, dynamic>? queryParameters}) async {
    try {
      final response =
          await _dio.post(path, data: data, queryParameters: queryParameters);
      return response;
    } catch (error) {
      _handleError(error);
      rethrow;
    }
  }

  // Error handling
  void _handleError(dynamic error) {
    if (error is DioException) {
      switch (error.type) {
        case DioExceptionType.cancel:
          log('Request to API server was cancelled');
          break;
        case DioExceptionType.sendTimeout:
          log('Connection timeout with API server');
          break;
        case DioExceptionType.unknown:
          log('Connection to API server failed due to internet connection');
          break;
        case DioExceptionType.receiveTimeout:
          log('Receive timeout in connection with API server');
          break;
        case DioExceptionType.badResponse:
          log('Received invalid status code: ${error.response?.statusCode}');
          break;
        case DioExceptionType.badCertificate:
          log('incorrect certificate as configured');
          break;
        case DioExceptionType.connectionTimeout:
          log('Send timeout in connection with API server');
          break;
        case DioExceptionType.connectionError:
          log('error socketExceptions in connection with API server');
          break;
      }
    } else {
      log('Unexpected error: $error');
    }
  }
}
