import 'package:agenda_electronica/screens/communications.dart';
import 'package:agenda_electronica/screens/ia.dart';
import 'package:agenda_electronica/screens/parent/task_parent.dart';
import 'package:agenda_electronica/screens/student/task_student.dart';
import 'package:agenda_electronica/screens/teacher/attendance_teacher.dart';
import 'package:agenda_electronica/screens/teacher/task_teacher.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/role_provider.dart';
import '../screens/calendar.dart';

class HomeScreen extends StatefulWidget {
  final String role;
  final Map<String, dynamic> userData;

  const HomeScreen({super.key, required this.role, required this.userData});

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    // Aquí puedes obtener el `idEstudiante` desde `userData`
    int? idEstudiante = widget.userData['id'];
    print("idEstudiante: $idEstudiante");
  }

  // Obtener las vistas según el rol
  List<Widget> _getScreensForRole(String role) {
    switch (role) {
      case 'student':
        return [
          TasksScreen(userData: widget.userData),
          const CalendarScreen(),
          // Pasar el `idEstudiante` al `CommunicationScreen`
          CommunicationScreen(estudianteId: widget.userData['id']),
        ];
      case 'parent':
        return [
          TaskParentScreen(userData: widget.userData),
          const CalendarScreen(),
          const CommunicationScreen(),
        ];
      case 'teacher':
        return [
          TaskTeacherScreen(userData: widget.userData),
          AttendanceTeacherScreen(userData: widget.userData),
          const CalendarScreen(),
          const CommunicationScreen(),
          IaScreen(),
        ];
      default:
        return [const Center(child: Text('Pantalla no disponible'))];
    }
  }

  // Obtener los ítems del BottomNavigationBar según el rol
  List<BottomNavigationBarItem> _getNavItemsForRole(String role) {
    switch (role) {
      case 'student':
        return const [
          BottomNavigationBarItem(icon: Icon(Icons.task), label: 'Tareas'),
          BottomNavigationBarItem(
              icon: Icon(Icons.calendar_today), label: 'Calendario'),
          BottomNavigationBarItem(
              icon: Icon(Icons.notifications), label: 'Comunicados'),
        ];
      case 'parent':
        return const [
          BottomNavigationBarItem(
              icon: Icon(Icons.task), label: 'Tareas del Hijo'),
          BottomNavigationBarItem(
              icon: Icon(Icons.calendar_today), label: 'Calendario'),
          BottomNavigationBarItem(
              icon: Icon(Icons.notifications), label: 'Comunicados'),
        ];
      case 'teacher':
        return const [
          BottomNavigationBarItem(icon: Icon(Icons.task), label: 'Tareas'),
          BottomNavigationBarItem(
              icon: Icon(Icons.checklist), label: 'Asistencia'),
          BottomNavigationBarItem(
              icon: Icon(Icons.calendar_today), label: 'Calendario'),
          BottomNavigationBarItem(
              icon: Icon(Icons.notifications), label: 'Comunicados'),
          BottomNavigationBarItem(icon: Icon(Icons.auto_awesome), label: 'IA'),
        ];
      default:
        return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    final role = widget.role;

    final screens = _getScreensForRole(role);
    final navItems = _getNavItemsForRole(role);

    return Scaffold(
      body: screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: navItems,
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        backgroundColor: Colors.white,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        showSelectedLabels: true,
        showUnselectedLabels: true,
      ),
    );
  }
}
