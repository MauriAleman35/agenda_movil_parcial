import 'package:flutter/material.dart';

class AttendanceTeacherScreen extends StatelessWidget {
  final Map<String, dynamic> userData; // Añade esta línea
  final List<String> students = [
    'Juan Pérez',
    'María García',
    'Carlos Sánchez',
    'Ana Torres',
  ];

  AttendanceTeacherScreen(
      {super.key, required this.userData}); // Modifica el constructor

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            'Registrar Asistencia (${userData['name']})'), // Muestra el nombre del profesor
      ),
      body: ListView.builder(
        itemCount: students.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(students[index]),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.check, color: Colors.green),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('${students[index]} presente')),
                    );
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.red),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('${students[index]} ausente')),
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
