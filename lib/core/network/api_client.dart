import 'package:dio/dio.dart';

/// Base HTTP client with configurable base URL, timeout, and error mapping.
/// Maps 4xx/5xx and network errors to user-facing messages (no credentials in logs).
class ApiClient {
  ApiClient({
    required String baseUrl,
    Duration? connectTimeout,
    Duration? receiveTimeout,
  })  : _dio = Dio(
          BaseOptions(
            baseUrl: baseUrl,
            connectTimeout: connectTimeout ?? const Duration(seconds: 15),
            receiveTimeout: receiveTimeout ?? const Duration(seconds: 15),
            headers: {'Content-Type': 'application/json', 'Accept': 'application/json'},
          ),
        ) {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onError: (error, handler) {
          handler.next(_mapError(error));
        },
      ),
    );
  }

  final Dio _dio;

  Dio get dio => _dio;

  /// Map DioException to a user-facing message (no sensitive data).
  static String mapErrorToUserMessage(dynamic error) {
    if (error is DioException) {
      switch (error.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.sendTimeout:
        case DioExceptionType.receiveTimeout:
          return 'Request timed out. Please try again.';
        case DioExceptionType.connectionError:
          return 'Network unavailable. Please check your connection.';
        case DioExceptionType.badResponse:
          final status = error.response?.statusCode;
          if (status == 401) return 'Invalid email or password.';
          if (status != null && status >= 500) {
            return 'Server error. Please try again later.';
          }
          return 'Something went wrong. Please try again.';
        default:
          return 'Network unavailable. Please check your connection.';
      }
    }
    return 'Something went wrong. Please try again.';
  }

  DioException _mapError(DioException error) => error;
}
