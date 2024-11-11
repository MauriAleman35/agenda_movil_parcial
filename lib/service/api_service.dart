import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:dio/dio.dart';

class Api {
  static final String baseUrl =
      dotenv.env['BASE_URL_LOCALHOST'] ?? 'http://localhost:8069';

  static final Dio _dio = Dio(
    BaseOptions(
      baseUrl: baseUrl,
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
    ),
  );

  static Dio get instance => _dio;

  static String convertToJsonString(Map<String, dynamic> obj) {
    return obj.toString();
  }
}
