import 'package:dio/dio.dart';
import 'api_service.dart';

class IaService {
  Future<String> generateCover(String subject) async {
    try {
      final response = await Api.instance.post(
        '/web/generate_image_cover',
        data: {
          "jsonrpc": "2.0",
          "params": {"subject": subject}
        },
      );

      if (response.statusCode == 200) {
        print("Response data: ${response.data}");

        // Verificar si la respuesta contiene un error en lugar de una imagen
        if (response.data['result'] is List &&
            response.data['result'][0] is Map &&
            response.data['result'][0].containsKey('error')) {
          throw Exception(
              "Error de generación de carátula: ${response.data['result'][0]['error']}");
        }

        // Si la respuesta es la esperada
        if (response.data['result'] is Map &&
            response.data['result']['image_url'] is String) {
          return response.data['result']['image_url'];
        } else {
          throw Exception(
              "Estructura inesperada en la respuesta del servidor: ${response.data}");
        }
      } else {
        throw Exception(
            "Error en la generación de carátula: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Error en la solicitud: $e");
    }
  }

  Future<List<String>> generateQuiz(String audioFilePath) async {
    try {
      String fileExtension = audioFilePath.split('.').last;
      final formData = FormData.fromMap({
        'audio': await MultipartFile.fromFile(audioFilePath,
            filename: 'audio.$fileExtension')
      });

      final response = await Api.instance.post(
        '/web/generate_audio_quiz',
        data: formData,
        options: Options(
          headers: {
            "Content-Type": "multipart/form-data",
          },
        ),
      );

      if (response.statusCode == 200) {
        final result = response.data['questions'];
        return List<String>.from(result);
      } else {
        throw Exception(
            "Error en la generación de cuestionario: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Error en la solicitud del cuestionario: $e");
    }
  }
}
