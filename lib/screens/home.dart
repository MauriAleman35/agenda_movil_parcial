import 'package:agenda_electronica/screens/communications.dart';
import 'package:agenda_electronica/screens/parent/task_parent.dart';
import 'package:agenda_electronica/screens/student/task_student.dart';
import 'package:agenda_electronica/screens/teacher/attendance_teacher.dart';
import 'package:agenda_electronica/screens/teacher/task_teacher.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/role_provider.dart';
import '../screens/calendar.dart';
// Importamos la nueva vista

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  // Obtener las vistas según el rol
  List<Widget> _getScreensForRole(String role) {
    switch (role) {
      case 'student':
        return [
          TasksScreen(),
          CalendarScreen(),
          CommunicationScreen(), // Comunicados del estudiante
        ];
      case 'parent':
        return [
          TaskParentScreen(),
          CalendarScreen(),
          CommunicationScreen(), // Comunicados del padre
        ];
      case 'teacher':
        return [
          TaskTeacherScreen(),
          AttendanceTeacherScreen(),
          CalendarScreen(),
          CommunicationScreen(), // Comunicados del profesor
        ];
      default:
        return [Center(child: Text('Pantalla no disponible'))];
    }
  }

  // Obtener los ítems del BottomNavigationBar según el rol
  List<BottomNavigationBarItem> _getNavItemsForRole(String role) {
    switch (role) {
      case 'student':
        return [
          BottomNavigationBarItem(icon: Icon(Icons.task), label: 'Tareas'),
          BottomNavigationBarItem(
              icon: Icon(Icons.calendar_today), label: 'Calendario'),
          BottomNavigationBarItem(
              icon: Icon(Icons.notifications), label: 'Comunicados'),
        ];
      case 'parent':
        return [
          BottomNavigationBarItem(
              icon: Icon(Icons.task), label: 'Tareas del Hijo'),
          BottomNavigationBarItem(
              icon: Icon(Icons.calendar_today), label: 'Calendario'),
          BottomNavigationBarItem(
              icon: Icon(Icons.notifications), label: 'Comunicados'),
        ];
      case 'teacher':
        return [
          BottomNavigationBarItem(icon: Icon(Icons.task), label: 'Tareas'),
          BottomNavigationBarItem(
              icon: Icon(Icons.checklist), label: 'Asistencia'),
          BottomNavigationBarItem(
              icon: Icon(Icons.calendar_today), label: 'Calendario'),
          BottomNavigationBarItem(
              icon: Icon(Icons.notifications), label: 'Comunicados'),
        ];
      default:
        return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    final role = context.watch<RoleProvider>().role; // Obtener el rol actual

    final screens = _getScreensForRole(role);
    final navItems = _getNavItemsForRole(role);

    return Scaffold(
      body: screens[_selectedIndex], // Vista actual seleccionada
      bottomNavigationBar: BottomNavigationBar(
        items: navItems,
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        backgroundColor: Colors.white, // Fondo del BottomNavigationBar
        selectedItemColor: Colors.blue, // Color del ítem seleccionado
        unselectedItemColor: Colors.grey, // Color del ítem no seleccionado
        showSelectedLabels: true, // Mostrar etiquetas del ítem seleccionado
        showUnselectedLabels:
            true, // Mostrar etiquetas del ítem no seleccionado
      ),
    );
  }
}
