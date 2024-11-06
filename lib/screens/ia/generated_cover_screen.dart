import 'package:flutter/material.dart';

class GeneratedCoverScreen extends StatefulWidget {
  final String subjectName;

  const GeneratedCoverScreen({Key? key, required this.subjectName})
      : super(key: key);

  @override
  _GeneratedCoverScreenState createState() => _GeneratedCoverScreenState();
}

class _GeneratedCoverScreenState extends State<GeneratedCoverScreen> {
  bool _isLoading = true;
  String? _imageUrl;

  @override
  void initState() {
    super.initState();
    _generateCover();
  }

  Future<void> _generateCover() async {
    await Future.delayed(Duration(seconds: 2)); // Simulación de carga
    setState(() {
      _isLoading = false;
      _imageUrl = "https://via.placeholder.com/300"; // URL de imagen de ejemplo
    });
  }

  void _downloadCover() {
    // Lógica para descargar la carátula
  }

  void _shareCover() {
    // Lógica para compartir la carátula
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Carátula Generada'),
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Carátula para: ${widget.subjectName}',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            if (_isLoading)
              CircularProgressIndicator()
            else if (_imageUrl != null) ...[
              Image.network(_imageUrl!),
              SizedBox(height: 20),
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
                    child: Text(
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
                    child: Text(
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
                    child: Text(
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
