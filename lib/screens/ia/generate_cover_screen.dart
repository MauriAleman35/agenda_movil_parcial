import 'package:flutter/material.dart';
import 'generated_cover_screen.dart';

class GenerateCoverScreen extends StatelessWidget {
  final TextEditingController _controller = TextEditingController();

  GenerateCoverScreen({super.key});

  void _goToGeneratedCoverScreen(BuildContext context) {
    final subjectName = _controller.text.trim();
    if (subjectName.isNotEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => GeneratedCoverScreen(subjectName: subjectName),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text("Por favor, ingresa el nombre de la materia")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Generar Carátula'),
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: 'Escribe el nombre de la materia',
                labelStyle: const TextStyle(color: Colors.deepPurple),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Colors.deepPurple),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide:
                      const BorderSide(color: Colors.deepPurple, width: 2),
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _goToGeneratedCoverScreen(context),
              style: ElevatedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                backgroundColor: Colors.deepPurple,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                elevation: 8,
              ),
              child: const Text(
                'Generar Carátula',
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
