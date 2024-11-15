import 'package:agenda_electronica/service/student_service.dart';
import 'package:agenda_electronica/service/teacher_student.dart';
import 'package:agenda_electronica/service/tutor_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:lottie/lottie.dart';
import '../providers/role_provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _carnetController = TextEditingController();

  String _selectedRole = 'Estudiante';
  final List<String> _roles = ['Estudiante', 'Profesor', 'Tutor'];
  bool _isLoading = false;

  Future<void> _login() async {
    setState(() {
      _isLoading = true;
    });

    final email = _emailController.text.trim();
    final carnet = _carnetController.text.trim();

    if (email.isEmpty || carnet.isEmpty) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor ingrese ambos campos')),
      );
      return;
    }

    Map<String, dynamic> result = {};
    final roleProvider = context.read<RoleProvider>();

    if (_selectedRole == 'Estudiante') {
      result = await StudentsService.loginStudent(email, carnet);
      if (!result.containsKey('error')) {
        roleProvider.setRole('student');
        Navigator.pushReplacementNamed(
          context,
          '/home',
          arguments: {'role': 'student', 'userData': result},
        );
      }
    } else if (_selectedRole == 'Profesor') {
      result = await TeachersService.loginTeacher(email, carnet);
      if (!result.containsKey('error')) {
        roleProvider.setRole('teacher');
        Navigator.pushReplacementNamed(
          context,
          '/home',
          arguments: {'role': 'teacher', 'userData': result},
        );
      }
    } else if (_selectedRole == 'Tutor') {
      result = await TutorsService.loginTutor(email, carnet);
      if (!result.containsKey('error')) {
        roleProvider.setRole('tutor');
        Navigator.pushReplacementNamed(
          context,
          '/home',
          arguments: {'role': 'tutor', 'userData': result},
        );
      }
    }

    setState(() {
      _isLoading = false;
    });

    if (result.containsKey('error')) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result['error'])),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 50.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 300,
                child: Lottie.asset(
                  'assets/lootie/loginAnimation.json',
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(height: 30),
              const Text(
                'Sign In',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "Hola bienvenido a tu Agenda Electrónica",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 40),
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  prefixIcon: const Icon(Icons.email),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _carnetController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Carnet',
                  prefixIcon: const Icon(Icons.lock_outline),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              DropdownButtonFormField<String>(
                value: _selectedRole,
                items: _roles.map((String role) {
                  return DropdownMenuItem<String>(
                    value: role,
                    child: Text(role),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedRole = newValue!;
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
              ElevatedButton(
                onPressed: _isLoading ? null : _login,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 100, vertical: 16),
                ),
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                        'Sign In',
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
              ),
              const SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }
}
