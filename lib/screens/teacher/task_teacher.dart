import 'package:flutter/material.dart';

class TaskTeacherScreen extends StatelessWidget {
  final Map<String, dynamic> userData; // Añade esta línea

  const TaskTeacherScreen(
      {super.key, required this.userData}); // Modifica el constructor

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Tareas del Profesor (${userData['name']})', // Muestra el nombre del profesor
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16.0),
                children: const [
                  ListTile(
                    leading: Icon(Icons.task),
                    title: Text('Preparar examen de Matemáticas'),
                    subtitle: Text('Fecha de entrega: 27 de Octubre'),
                  ),
                  ListTile(
                    leading: Icon(Icons.task),
                    title: Text('Revisar ensayos de Lenguaje'),
                    subtitle: Text('Fecha de entrega: 30 de Octubre'),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Nueva tarea añadida')),
                  );
                },
                child: const Text('Añadir Tarea'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
