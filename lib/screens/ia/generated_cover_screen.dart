import 'dart:io';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:dio/dio.dart';
import '../../service/ia_service.dart';

class GeneratedCoverScreen extends StatefulWidget {
  final String subjectName;

  const GeneratedCoverScreen({super.key, required this.subjectName});

  @override
  _GeneratedCoverScreenState createState() => _GeneratedCoverScreenState();
}

class _GeneratedCoverScreenState extends State<GeneratedCoverScreen> {
  bool _isLoading = true;
  String? _imageUrl;
  File? _downloadedImage;
  final IaService _iaService = IaService();
  final Dio _dio = Dio();

  @override
  void initState() {
    super.initState();
    _generateCover();
  }

  Future<void> _generateCover() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final imageUrl = await _iaService.generateCover(widget.subjectName);
      setState(() {
        _imageUrl = imageUrl;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error al generar la carátula: $e")),
      );
    }
  }

  Future<void> _downloadCover() async {
    if (_imageUrl != null) {
      try {
        final Directory downloadDir = await getApplicationDocumentsDirectory();
        final String downloadPath =
            '${downloadDir.path}/${widget.subjectName}_cover.png';

        // Descargar la imagen usando Dio
        await _dio.download(_imageUrl!, downloadPath);

        setState(() {
          _downloadedImage = File(downloadPath);
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Carátula guardada en $downloadPath")),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error al descargar la carátula: $e")),
        );
      }
    }
  }

  Future<void> _shareCover() async {
    if (_downloadedImage != null) {
      await Share.shareXFiles(
        [XFile(_downloadedImage!.path)],
        text: 'Carátula para la materia de ${widget.subjectName}',
        subject: 'Carátula Generada',
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Primero debes descargar la carátula")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Carátula Generada'),
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Carátula para: ${widget.subjectName}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            if (_isLoading)
              const CircularProgressIndicator()
            else if (_imageUrl != null) ...[
              Image.network(_imageUrl!,
                  errorBuilder: (context, error, stackTrace) {
                return const Text("No se pudo cargar la imagen");
              }),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey[300],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: const Text(
                      'Volver',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: _downloadCover,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: const Text(
                      'Descargar',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: _shareCover,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: const Text(
                      'Compartir',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
