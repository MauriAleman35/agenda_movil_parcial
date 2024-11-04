import 'package:flutter/material.dart';

class TaskTeacherScreen extends StatelessWidget {
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
                'Tareas del Profesor',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Expanded(
              child: ListView(
                padding: EdgeInsets.all(16.0),
                children: [
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
                    SnackBar(content: Text('Nueva tarea añadida')),
                  );
                },
                child: Text('Añadir Tarea'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
