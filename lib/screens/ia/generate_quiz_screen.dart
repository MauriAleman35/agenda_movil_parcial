import 'package:agenda_electronica/service/ia_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:share_plus/share_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';

class GenerateQuizScreen extends StatefulWidget {
  const GenerateQuizScreen({super.key});

  @override
  GenerateQuizScreenState createState() => GenerateQuizScreenState();
}

class GenerateQuizScreenState extends State<GenerateQuizScreen> {
  bool _isRecording = false;
  bool _isPaused = false;
  bool _isProcessing = false;
  bool _quizGenerated = false;
  String? _quizText;
  String? _audioFilePath;
  File? _pdfFile;
  final IaService iaService = IaService();
  final FlutterSoundRecorder _recorder = FlutterSoundRecorder();

  @override
  void initState() {
    super.initState();
    _initializeRecorder();
    _requestPermissions(); // Solicitar permisos en tiempo de ejecución
  }

  Future<void> _requestPermissions() async {
    await Permission.microphone.request();
    await Permission.storage.request();
  }

  Future<void> _initializeRecorder() async {
    await _recorder.openRecorder();
    await _recorder.setSubscriptionDuration(const Duration(milliseconds: 500));
  }

  Future<void> _startRecording() async {
    setState(() {
      _isRecording = true;
      _isProcessing = false;
      _quizGenerated = false;
      _quizText = null;
    });
    final appDocDir = await getApplicationDocumentsDirectory();
    _audioFilePath = '${appDocDir.path}/recording.aac';
    await _recorder.startRecorder(toFile: _audioFilePath);
  }

  Future<void> _pauseRecording() async {
    if (_isPaused) {
      await _recorder.resumeRecorder();
    } else {
      await _recorder.pauseRecorder();
    }
    setState(() {
      _isPaused = !_isPaused;
    });
  }

  Future<void> _stopRecording() async {
    try {
      await _recorder.stopRecorder();
      setState(() {
        _isRecording = false;
        _isProcessing = true;
      });
      _processAudio();
    } catch (e) {
      print("Error al detener la grabación: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Error al detener la grabación.")),
      );
    }
  }

  Future<void> _uploadAudio() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.audio);
    if (result != null) {
      setState(() {
        _isProcessing = true;
        _quizGenerated = false;
        _quizText = null;
        _audioFilePath = result.files.single.path;
      });
      _processAudio();
    }
  }

  void _processAudio() async {
    if (_audioFilePath == null) {
      setState(() {
        _isProcessing = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text("No se ha seleccionado ningún archivo de audio.")),
      );
      return;
    }

    setState(() {
      _isProcessing = true;
    });

    try {
      List<String> questions = await iaService.generateQuiz(_audioFilePath!);
      setState(() {
        _isProcessing = false;
        _quizGenerated = true;
        _quizText = questions.join('\n\n');
      });
      await _createPdf();
    } catch (e) {
      setState(() {
        _isProcessing = false;
        _quizGenerated = false;
        _quizText = "Error al generar el cuestionario: $e";
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error en el procesamiento del audio: $e")),
      );
    }
  }

  Future<void> _createPdf() async {
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
      _pdfFile = File("${output.path}/cuestionario.pdf");
      await _pdfFile!.writeAsBytes(await pdf.save());
    }
  }

  Future<void> _sharePdf() async {
    if (_pdfFile != null) {
      await Share.shareXFiles([XFile(_pdfFile!.path)],
          text: 'Cuestionario generado');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text("Primero debes generar el cuestionario en PDF")),
      );
    }
  }

  void _copyToClipboard() {
    if (_quizText != null) {
      Clipboard.setData(ClipboardData(text: _quizText!));
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Cuestionario copiado al portapapeles")),
      );
    }
  }

  @override
  void dispose() {
    _recorder.closeRecorder();
    super.dispose();
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
                _isPaused ? 'Reanudar Grabación' : 'Pausar Grabación',
                _isPaused ? Icons.play_arrow : Icons.pause,
                Colors.orangeAccent,
                _pauseRecording,
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
                'Compartir como PDF',
                Icons.share,
                Colors.deepPurple,
                _sharePdf,
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
