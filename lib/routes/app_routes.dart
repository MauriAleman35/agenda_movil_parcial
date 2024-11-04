import 'package:agenda_electronica/screens/parent/task_parent.dart';
import 'package:agenda_electronica/screens/student/task_student.dart';
import 'package:agenda_electronica/screens/teacher/attendance_teacher.dart';
import 'package:agenda_electronica/screens/teacher/task_teacher.dart';
import 'package:flutter/material.dart';
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

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case login:
        return MaterialPageRoute(builder: (_) => LoginScreen());
      case home:
        return MaterialPageRoute(builder: (_) => HomeScreen());
      case calendar:
        return MaterialPageRoute(builder: (_) => CalendarScreen());
      case taskStudent:
        return MaterialPageRoute(builder: (_) => TasksScreen());
      case taskTeacher:
        return MaterialPageRoute(builder: (_) => TaskTeacherScreen());
      case attendanceTeacher:
        return MaterialPageRoute(builder: (_) => AttendanceTeacherScreen());
      case taskParent:
        return MaterialPageRoute(builder: (_) => TaskParentScreen());
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
