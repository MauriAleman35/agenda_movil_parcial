import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:dio/dio.dart';

class Api {
  // Obtén las URLs desde las variables de entorno
  static final String baseUrlLocalhost =
      dotenv.env['BASE_URL_LOCALHOST'] ?? 'http://localhost:3000';
  static final String baseUrlProduction =
      dotenv.env['BASE_URL_PRODUCTION'] ?? 'https://api.tuproduccion.com';

  // Detecta si está en modo de producción o desarrollo
  static final String baseUrl = const bool.fromEnvironment('dart.vm.product')
      ? baseUrlProduction
      : baseUrlLocalhost;

  // static final String baseUrl = 'http://localhost:3000';

  // Configura la instancia de Dio con la URL base y encabezados
  static final Dio _dio = Dio(
    BaseOptions(
      baseUrl: baseUrl,
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
      // connectTimeout: Duration(seconds: 10), // Tiempo de conexión
      // receiveTimeout: Duration(seconds: 10), // Tiempo de espera de respuesta
    ),
  );

  static Dio get instance => _dio;

  static String convertToJsonString(Map<String, dynamic> obj) {
    return obj.toString();
  }
}
