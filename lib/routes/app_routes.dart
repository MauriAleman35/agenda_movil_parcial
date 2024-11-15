import 'package:agenda_electronica/screens/ia/generate_cover_screen.dart';
import 'package:agenda_electronica/screens/ia/generate_quiz_screen.dart';
import 'package:flutter/material.dart';
import 'package:agenda_electronica/screens/parent/task_parent.dart';
import 'package:agenda_electronica/screens/student/task_student.dart';
import 'package:agenda_electronica/screens/teacher/attendance_teacher.dart';
import 'package:agenda_electronica/screens/teacher/task_teacher.dart';
import 'package:agenda_electronica/screens/ia.dart';
import '../screens/login.dart';
import '../screens/home.dart';
import '../screens/calendar.dart';

class AppRoutes {
  static const String login = '/login';
  static const String home = '/home';
  static const String calendar = '/calendar';
  static const String taskStudent = '/task-student';
  static const String taskTeacher = '/task-teacher';
  static const String attendanceTeacher = '/attendance-teacher';
  static const String taskParent = '/task-parent';
  static const String ia = '/ia';
  static const String generateCover = '/generate-cover';
  static const String generateQuiz = '/generate-quiz';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    // Verifica si hay argumentos pasados en RouteSettings
    final args = settings.arguments as Map<String, dynamic>?;

    switch (settings.name) {
      case login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case home:
        return MaterialPageRoute(
          builder: (_) => HomeScreen(
            role:
                args?['role'] ?? 'student', // Pasar el rol desde los argumentos
            userData: args?['userData'] ?? {}, // Pasar los datos del usuario
          ),
        );
      case calendar:
        return MaterialPageRoute(builder: (_) => const CalendarScreen());
      case taskStudent:
        return MaterialPageRoute(
          builder: (_) => TasksScreen(
            userData: args?['userData'] ?? {}, // Pasar los datos del usuario
          ),
        );
      case taskTeacher:
        return MaterialPageRoute(
          builder: (_) => TaskTeacherScreen(
            userData: args?['userData'] ?? {}, // Pasar los datos del usuario
          ),
        );
      case attendanceTeacher:
        return MaterialPageRoute(
          builder: (_) => AttendanceTeacherScreen(
            userData: args?['userData'] ?? {}, // Pasar los datos del usuario
          ),
        );
      case taskParent:
        return MaterialPageRoute(
          builder: (_) => TaskParentScreen(
            userData: args?['userData'] ?? {}, // Pasar los datos del usuario
          ),
        );
      case ia:
        return MaterialPageRoute(builder: (_) => IaScreen());
      case generateCover:
        return MaterialPageRoute(builder: (_) => GenerateCoverScreen());
      case generateQuiz:
        return MaterialPageRoute(builder: (_) => const GenerateQuizScreen());
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('Ruta no encontrada: ${settings.name}'),
            ),
          ),
        );
    }
  }
}
