import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // Importamos Provider
import 'package:table_calendar/table_calendar.dart';
import '../providers/role_provider.dart'; // Importa tu RoleProvider

class CalendarScreen extends StatefulWidget {
  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();
  List<String> _tasks = [];

  @override
  Widget build(BuildContext context) {
    final role = Provider.of<RoleProvider>(context).role; // Obtenemos el rol

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, // Elimina el botón de retroceso
        title: Text(
          'Calendario - $role',
          style: const TextStyle(
            color: Colors.black, // Aseguramos que el color del título sea negro
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0, // Eliminar sombra para un diseño limpio
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Calendario con estilo
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TableCalendar(
                firstDay: DateTime.utc(2000, 1, 1),
                lastDay: DateTime.utc(2100, 12, 31),
                focusedDay: _focusedDay,
                selectedDayPredicate: (day) {
                  return isSameDay(_selectedDay, day);
                },
                onDaySelected: (selectedDay, focusedDay) {
                  setState(() {
                    _selectedDay = selectedDay;
                    _focusedDay = focusedDay;
                    _tasks = _getTasksForTheDay(selectedDay); // Cargar tareas
                  });
                },
                calendarStyle: CalendarStyle(
                  todayDecoration: const BoxDecoration(
                    color: Colors.black,
                    shape: BoxShape.circle,
                  ),
                  selectedDecoration: BoxDecoration(
                    color: Colors.grey[700],
                    shape: BoxShape.circle,
                  ),
                  outsideDaysVisible: false,
                ),
              ),
            ),
            const SizedBox(height: 10), // Espacio entre el calendario y tareas

            // Lista de tareas o eventos según el rol
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                decoration: BoxDecoration(
                  color: Colors.grey[200], // Fondo claro
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(20),
                  ),
                ),
                child: _tasks.isEmpty
                    ? const Center(
                        child: Text(
                          'No hay tareas para hoy',
                          style: TextStyle(fontSize: 16, color: Colors.black54),
                        ),
                      )
                    : ListView.builder(
                        itemCount: _tasks.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            leading:
                                const Icon(Icons.task_alt, color: Colors.black),
                            title: Text(_tasks[index]),
                          );
                        },
                      ),
              ),
            ),
          ],
        ),
      ),
      // Mostrar botón flotante solo para el profesor
      floatingActionButton: role == 'teacher'
          ? FloatingActionButton(
              onPressed: () {
                _showAddEventDialog(context); // Función para agregar evento
              },
              child: const Icon(Icons.add),
            )
          : null, // No mostrar el botón para otros roles
    );
  }

  // Simulación de tareas por día
  List<String> _getTasksForTheDay(DateTime day) {
    if (day.weekday == DateTime.monday) {
      return ['Hacer tarea de matemáticas', 'Comprar útiles'];
    } else if (day.weekday == DateTime.friday) {
      return ['Reunión con profesores', 'Preparar exposición'];
    } else {
      return [];
    }
  }

  // Diálogo para agregar evento (Solo para el profesor)
  void _showAddEventDialog(BuildContext context) {
    TextEditingController eventController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Agregar Evento'),
          content: TextField(
            controller: eventController,
            decoration: const InputDecoration(
              hintText: 'Escribe el nombre del evento',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _tasks.add(eventController.text); // Agregar evento
                });
                Navigator.of(context).pop();
              },
              child: const Text('Agregar'),
            ),
          ],
        );
      },
    );
  }
}
