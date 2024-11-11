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
        final result = response.data['result'];
        return result['image_url']; // Retorna solo la URL de la imagen generada
      } else {
        throw Exception(
            "Error en la generación de carátula: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Error en la solicitud: $e");
    }
  }
}
