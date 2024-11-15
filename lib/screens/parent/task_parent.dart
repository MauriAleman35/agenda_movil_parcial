import 'package:flutter/material.dart';

class TaskParentScreen extends StatelessWidget {
  final Map<String, dynamic> userData; // Añade esta línea

  const TaskParentScreen(
      {super.key, required this.userData}); // Modifica el constructor

  @override
  Widget build(BuildContext context) {
    // Aquí puedes usar userData para personalizar la vista
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Tareas del Hijo (${userData['name']})', // Muestra el nombre del hijo
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16.0),
                children: [
                  _buildTaskCard('Matemáticas', 'Resolver 10 ejercicios', true),
                  _buildTaskCard('Ciencias', 'Proyecto de biología', false),
                  _buildTaskCard('Inglés', 'Completar vocabulario', true),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTaskCard(String subject, String description, bool completed) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: ListTile(
        leading: Icon(
          completed ? Icons.check_circle : Icons.radio_button_unchecked,
          color: completed ? Colors.green : Colors.grey,
        ),
        title: Text(subject),
        subtitle: Text(description),
      ),
    );
  }
}
