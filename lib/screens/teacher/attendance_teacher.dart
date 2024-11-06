import 'package:flutter/material.dart';

class AttendanceTeacherScreen extends StatelessWidget {
  final List<String> students = [
    'Juan Pérez',
    'María García',
    'Carlos Sánchez',
    'Ana Torres',
  ];

  AttendanceTeacherScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registrar Asistencia'),
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
