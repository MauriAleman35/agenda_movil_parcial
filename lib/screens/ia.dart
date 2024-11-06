import 'package:flutter/material.dart';

class IaScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Opciones de IA'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 40.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Selecciona una opción para generar contenido con IA',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.grey[800],
              ),
            ),
            SizedBox(height: 30),
            _buildOptionButton(
              context,
              'Generar Carátulas con IA',
              Icons.image,
              Colors.blueAccent,
              () {
                Navigator.pushNamed(context, '/generate-cover');
              },
            ),
            SizedBox(height: 20),
            _buildOptionButton(
              context,
              'Generar Cuestionarios con IA',
              Icons.question_answer,
              Colors.greenAccent,
              () {
                Navigator.pushNamed(context, '/generate-quiz');
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionButton(BuildContext context, String text, IconData icon,
      Color color, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.symmetric(vertical: 18.0, horizontal: 24.0),
        backgroundColor: color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        shadowColor: color.withOpacity(0.4),
        elevation: 10,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: Colors.white, size: 28),
          SizedBox(width: 10),
          Text(
            text,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
