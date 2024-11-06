import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart'; // Importar la librería de Lottie

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  // Variable para almacenar el rol seleccionado
  String _selectedRole = 'Estudiante'; // Valor inicial

  // Opciones de roles disponibles
  final List<String> _roles = ['Estudiante', 'Profesor', 'Padre de Familia'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Fondo blanco
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 50.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Animación Lottie
              SizedBox(
                height: 300, // Ajusta el tamaño según tu diseño
                child: Lottie.asset(
                  'assets/lootie/loginAnimation.json', // Ruta del asset JSON
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(height: 30), // Espacio entre animación y contenido

              // Título Principal
              const Text(
                'Sign In',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 8),

              // Subtítulo
              Text(
                "Hola bienvenido a tu Agenda Electrónica",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 40),

              // Campo de Email / Código
              TextField(
                decoration: InputDecoration(
                  labelText: 'Código',
                  prefixIcon: const Icon(Icons.email_outlined),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Campo de Contraseña
              TextField(
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Contraseña',
                  prefixIcon: const Icon(Icons.lock_outline),
                  suffixIcon: const Icon(Icons.visibility_off),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Dropdown para seleccionar el rol
              DropdownButtonFormField<String>(
                value: _selectedRole, // Rol inicial
                items: _roles.map((String role) {
                  return DropdownMenuItem<String>(
                    value: role,
                    child: Text(role),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedRole = newValue!; // Actualiza el rol seleccionado
                  });
                },
                decoration: InputDecoration(
                  labelText: 'Seleccionar Rol',
                  prefixIcon: const Icon(Icons.person_outline),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Olvidó contraseña
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {},
                  child: const Text(
                    'Forgot Password?',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Botón de Iniciar Sesión
              ElevatedButton(
                onPressed: () {
                  // Lógica de navegación según el rol seleccionado
                  Navigator.pushReplacementNamed(context, '/home');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black, // Botón negro
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 100, vertical: 16),
                ),
                child: const Text(
                  'Sign In',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
              const SizedBox(height: 50), // Espacio final para estética
            ],
          ),
        ),
      ),
    );
  }
}
