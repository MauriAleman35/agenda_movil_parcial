import 'package:agenda_electronica/service/api_service.dart';
import 'package:dio/dio.dart';

class TutorsService {
  // Método de inicio de sesión para el tutor
  static Future<Map<String, dynamic>> loginTutor(
      String email, String carnet) async {
    try {
      final response = await Api.instance.post(
        '/web/login/tutor',
        data: {
          'email': email,
          'carnet': carnet,
        },
        options: Options(
          headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        ),
      );

      if (response.data != null && response.statusCode == 200) {
        return response.data; // Devuelve los datos del tutor
      } else {
        return {'error': 'Datos incorrectos o usuario no encontrado'};
      }
    } catch (e) {
      print('Error al iniciar sesión como tutor: $e');
      return {'error': e.toString()};
    }
  }
}
