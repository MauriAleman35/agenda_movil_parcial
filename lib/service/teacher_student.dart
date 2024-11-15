import 'package:agenda_electronica/service/api_service.dart';
import 'package:dio/dio.dart';

class TeachersService {
  // Método para obtener la información del profesor por ID
  Future<Map<String, dynamic>> getProfesorInfo(int profesorId) async {
    try {
      final response = await Api.instance.get('/web/profesor/$profesorId');
      return response.data;
    } catch (e) {
      print('Error al obtener información del profesor: $e');
      return {
        'error': 'Ocurrió un error al obtener la información del profesor'
      };
    }
  }

  static Future<Map<String, dynamic>> loginTeacher(
      String email, String carnet) async {
    try {
      final response = await Api.instance.post(
        '/web/login/profesor',
        data: {
          'email': email,
          'carnet': carnet,
        },
        options: Options(
          headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        ),
      );

      if (response.data != null && response.statusCode == 200) {
        return response.data; // Devuelve los datos del profesor
      } else {
        return {'error': 'Datos incorrectos o usuario no encontrado'};
      }
    } catch (e) {
      print('Error al iniciar sesión como profesor: $e');
      return {'error': e.toString()};
    }
  }

  // Método para obtener la lista de cursos que imparte el profesor
  Future<Map<String, dynamic>> getProfesorCursos(int profesorId) async {
    try {
      final response =
          await Api.instance.get('/web/profesor/$profesorId/cursos');
      return response.data;
    } catch (e) {
      print('Error al obtener cursos del profesor: $e');
      return {'error': 'Ocurrió un error al obtener los cursos del profesor'};
    }
  }

  // Método para obtener la lista de materias que el profesor enseña
  Future<Map<String, dynamic>> getProfesorMaterias(int profesorId) async {
    try {
      final response =
          await Api.instance.get('/web/profesor/$profesorId/materias');
      return response.data;
    } catch (e) {
      print('Error al obtener materias del profesor: $e');
      return {'error': 'Ocurrió un error al obtener las materias del profesor'};
    }
  }
}
