import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Para copiar al portapapeles
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class GenerateQuizScreen extends StatefulWidget {
  const GenerateQuizScreen({super.key});

  @override
  GenerateQuizScreenState createState() => GenerateQuizScreenState();
}

class GenerateQuizScreenState extends State<GenerateQuizScreen> {
  bool _isRecording = false;
  bool _isProcessing = false;
  bool _quizGenerated = false;
  String? _quizText;

  void _startRecording() {
    setState(() {
      _isRecording = true;
      _isProcessing = false;
      _quizGenerated = false;
      _quizText = null;
    });
    // Lógica para iniciar la grabación de audio
  }

  void _stopRecording() {
    setState(() {
      _isRecording = false;
      _isProcessing = true;
    });
    // Lógica para detener la grabación y procesar el audio
    _processAudio();
  }

  void _uploadAudio() {
    setState(() {
      _isProcessing = true;
      _quizGenerated = false;
      _quizText = null;
    });
    // Lógica para subir un archivo de audio
    _processAudio();
  }

  void _processAudio() async {
    setState(() {
      _isProcessing = true;
    });

    // Simulación de procesamiento (aquí va la llamada a la IA para transcripción y generación del cuestionario)
    await Future.delayed(const Duration(seconds: 3));

    setState(() {
      _isProcessing = false;
      _quizGenerated = true;
      _quizText =
          "1. ¿Qué es la fotosíntesis?\nRespuesta: Es el proceso por el cual las plantas...\n\n2. ¿Cuáles son los órganos principales de una planta?\nRespuesta: Raíz, tallo, hojas...\n\n3. ¿Por qué es importante la fotosíntesis?\nRespuesta: Proporciona oxígeno...\n\n4. ¿Qué tipo de organismos realizan fotosíntesis?\nRespuesta: Plantas, algas...\n\n5. ¿Cuál es el pigmento responsable de la fotosíntesis?\nRespuesta: Clorofila.";
    });
  }

  void _reprocessAudio() {
    setState(() {
      _isProcessing = true;
      _quizGenerated = false;
      _quizText = null;
    });
    // Lógica para reprocesar el audio en caso de error
    _processAudio();
  }

  void _copyToClipboard() {
    if (_quizText != null) {
      Clipboard.setData(ClipboardData(text: _quizText!));
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Cuestionario copiado al portapapeles")),
      );
    }
  }

  Future<void> _downloadAsPdf() async {
    if (_quizText != null) {
      final pdf = pw.Document();
      pdf.addPage(
        pw.Page(
          build: (pw.Context context) => pw.Center(
            child: pw.Text(_quizText!),
          ),
        ),
      );

      final output = await getTemporaryDirectory();
      final file = File("${output.path}/cuestionario.pdf");
      await file.writeAsBytes(await pdf.save());

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text("Cuestionario guardado como PDF en ${file.path}")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Generar Cuestionario'),
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (!_isRecording && !_isProcessing && !_quizGenerated) ...[
              _buildActionButton(
                context,
                'Iniciar Grabación',
                Icons.mic,
                Colors.purpleAccent,
                _startRecording,
              ),
              const SizedBox(height: 10),
              _buildActionButton(
                context,
                'Subir Archivo de Audio',
                Icons.upload_file,
                Colors.blueAccent,
                _uploadAudio,
              ),
            ],
            if (_isRecording) ...[
              const Text(
                'Grabando...',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              _buildActionButton(
                context,
                'Detener Grabación',
                Icons.stop,
                Colors.redAccent,
                _stopRecording,
              ),
            ],
            if (_isProcessing) ...[
              const SizedBox(height: 30),
              const Center(child: CircularProgressIndicator()),
              const SizedBox(height: 10),
              const Text(
                'Procesando el audio...',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
            ],
            if (_quizGenerated && _quizText != null) ...[
              const SizedBox(height: 20),
              const Text(
                'Cuestionario Generado:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: SingleChildScrollView(
                  child: Text(
                    _quizText!,
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              _buildActionButton(
                context,
                'Copiar Cuestionario',
                Icons.copy,
                Colors.green,
                _copyToClipboard,
              ),
              const SizedBox(height: 10),
              _buildActionButton(
                context,
                'Descargar como PDF',
                Icons.picture_as_pdf,
                Colors.deepPurple,
                _downloadAsPdf,
              ),
              const SizedBox(height: 10),
              _buildActionButton(
                context,
                'Reprocesar Audio',
                Icons.refresh,
                Colors.orange,
                _reprocessAudio,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(
    BuildContext context,
    String text,
    IconData icon,
    Color color,
    VoidCallback onPressed,
  ) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, color: Colors.white),
      label: Text(
        text,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 16),
        backgroundColor: color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        shadowColor: color.withOpacity(0.4),
        elevation: 8,
      ),
    );
  }
}
