import 'package:agenda_electronica/service/api_service.dart';
import 'package:dio/dio.dart';

class StudentsService {
  // Método para obtener la información del estudiante por ID
  Future<Map<String, dynamic>> getEstudianteInfo(int estudianteId) async {
    try {
      final response = await Api.instance.get('/web/estudiante/$estudianteId');
      return response.data;
    } catch (e) {
      print('Error al obtener información del estudiante: $e');
      return {
        'error': 'Ocurrió un error al obtener la información del estudiante'
      };
    }
  }

  static Future<Response?> getComunicadosByStudent(int estudianteId) async {
    try {
      // Construir la URL usando la baseUrl de las variables de entorno
      final url = '${Api.baseUrl}/web/estudiante/$estudianteId/comunicados';

      // Preparar el cuerpo de la solicitud
      final body = {
        "jsonrpc": "2.0",
        "params": {"estudiante_id": estudianteId}
      };

      // Realizar la solicitud POST
      final response = await Api.instance.post(
        url,
        data: body,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
          },
        ),
      );

      // Retorna la respuesta si es exitosa
      return response;
    } catch (e) {
      print('Error al obtener los comunicados: $e');
      return null;
    }
  }

  static Future<Map<String, dynamic>> loginStudent(
      String registro, String carnet) async {
    try {
      // Crear FormData con los datos de registro y carnet
      FormData formData = FormData.fromMap({
        'registro': registro,
        'carnet': carnet,
      });
      print(formData);
      // Realizar la solicitud POST usando FormData
      final response = await Api.instance.post(
        '/web/login/student',
        data: formData, // Enviar los datos como FormData
        options: Options(
          headers: {
            'Content-Type': 'multipart/form-data'
          }, // Usar 'multipart/form-data'
        ),
      );

      if (response.data != null && response.statusCode == 200) {
        return response.data; // Devuelve los datos del estudiante
      } else {
        return {'error': 'Datos incorrectos o usuario no encontrado'};
      }
    } catch (e) {
      print('Error en la solicitud: $e');
      return {'error': e.toString()};
    }
  }
}
