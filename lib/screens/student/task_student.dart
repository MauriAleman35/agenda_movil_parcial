import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:async'; // Para el auto-scroll del carrusel

class TasksScreen extends StatefulWidget {
  const TasksScreen({super.key});

  @override
  TasksScreenState createState() => TasksScreenState();
}

class TasksScreenState extends State<TasksScreen> {
  List<String> notifications = [
    'Entrega de tarea mañana',
    'Examen de Historia el viernes',
    'Suspensión de clases el lunes'
  ];
  final List<Map<String, dynamic>> _tasks = [
    {
      'title': 'Tarea de Matemáticas',
      'description': 'Resolver los ejercicios del libro, páginas 34-36.',
      'dueDate': DateTime.now(),
      'completed': false,
    },
    {
      'title': 'Lectura de Historia',
      'description': 'Leer el capítulo 5 y hacer un resumen.',
      'dueDate': DateTime.now().add(const Duration(days: 1)),
      'completed': false,
    },
    {
      'title': 'Trabajo de Ciencias',
      'description': 'Preparar una exposición sobre el sistema solar.',
      'dueDate': DateTime.now().add(const Duration(days: 2)),
      'completed': false,
    },
    {
      'title': 'Tarea de Matemáticas',
      'description': 'Resolver los ejercicios del libro, páginas 34-36.',
      'dueDate': DateTime.now(),
      'completed': false,
    },
    {
      'title': 'Lectura de Historia',
      'description': 'Leer el capítulo 5 y hacer un resumen.',
      'dueDate': DateTime.now().add(const Duration(days: 1)),
      'completed': false,
    },
    {
      'title': 'Trabajo de Ciencias',
      'description': 'Preparar una exposición sobre el sistema solar.',
      'dueDate': DateTime.now().add(const Duration(days: 2)),
      'completed': false,
    },
    {
      'title': 'Tarea de Matemáticas',
      'description': 'Resolver los ejercicios del libro, páginas 34-36.',
      'dueDate': DateTime.now(),
      'completed': false,
    },
    {
      'title': 'Lectura de Historia',
      'description': 'Leer el capítulo 5 y hacer un resumen.',
      'dueDate': DateTime.now().add(const Duration(days: 1)),
      'completed': false,
    },
    {
      'title': 'Trabajo de Ciencias',
      'description': 'Preparar una exposición sobre el sistema solar.',
      'dueDate': DateTime.now().add(const Duration(days: 2)),
      'completed': false,
    },
  ];

  final PageController _pageController = PageController(viewportFraction: 0.85);
  Timer? _carouselTimer;

  @override
  void initState() {
    super.initState();
    _startAutoScroll();
  }

  @override
  void dispose() {
    _carouselTimer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  // Auto-scroll del carrusel cada 3 segundos
  void _startAutoScroll() {
    _carouselTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (_pageController.hasClients) {
        int nextPage = _pageController.page!.toInt() + 1;
        if (nextPage >= _tasks.length) {
          nextPage = 0;
        }
        _pageController.animateToPage(
          nextPage,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(), // Header con avatar y notificaciones
            const SizedBox(height: 10),
            _buildTaskCarousel(), // Carrusel mejorado
            const SizedBox(height: 20),
            Expanded(
                child: _buildTaskTabs()), // Tabs de todas las tareas y filtro
          ],
        ),
      ),
    );
  }

  void _showNotificationMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return ListView.builder(
          padding: const EdgeInsets.all(16.0),
          itemCount: notifications.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(notifications[index]),
            );
          },
        );
      },
    );
  }

  // Header con avatar y notificaciones
  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Row(
            children: [
              CircleAvatar(
                radius: 30,
                backgroundImage: NetworkImage('https://i.pravatar.cc/300'),
              ),
              SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Hola, Livia Vaccaro',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    'Bienvenido a tu lista de tareas',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ],
          ),
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {
              _showNotificationMenu(context);
            },
          ),
        ],
      ),
    );
  }

// Función para mostrar los detalles de la tarea en un diálogo
  void _showTaskDetailsDialog(BuildContext context, Map<String, dynamic> task) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Text(
            task['title'],
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Descripción:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black54,
                ),
              ),
              const SizedBox(height: 5),
              Text(task['description']),
              const SizedBox(height: 15),
              Text(
                'Fecha de entrega: ${DateFormat.yMMMMd().format(task['dueDate'])}',
                style: const TextStyle(color: Colors.black87),
              ),
              const SizedBox(height: 5),
              Text(
                'Hora de entrega: ${DateFormat.jm().format(task['dueDate'])}',
                style: const TextStyle(color: Colors.black87),
              ),
              const SizedBox(height: 15),
              Text(
                task['completed'] ? 'Estado: Completada' : 'Estado: Pendiente',
                style: TextStyle(
                  color: task['completed'] ? Colors.green : Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                'Cerrar',
                style: TextStyle(color: Colors.black),
              ),
            ),
          ],
        );
      },
    );
  }

  // Carrusel mejorado de tareas
  Widget _buildTaskCarousel() {
    return SizedBox(
      height: 180,
      child: PageView.builder(
        controller: _pageController,
        itemCount: _tasks.length,
        itemBuilder: (context, index) {
          final task = _tasks[index];
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Card(
              elevation: 6,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Container(
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Colors.black87, Colors.black54],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      task['title'],
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      'Fecha: ${DateFormat.yMMMMd().format(task['dueDate'])}',
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      task['completed']
                          ? 'Estado: Completada'
                          : 'Estado: Pendiente',
                      style: TextStyle(
                        color: task['completed'] ? Colors.green : Colors.red,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildNotificationButton() {
    return Stack(
      children: [
        IconButton(
          icon: const Icon(Icons.notifications),
          onPressed: () {
            _showNotificationMenu(context); // Muestra el menú de notificaciones
          },
        ),
        if (notifications.isNotEmpty) // Si hay notificaciones, muestra el badge
          Positioned(
            right: 11,
            top: 11,
            child: Container(
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(12),
              ),
              constraints: const BoxConstraints(
                minWidth: 16,
                minHeight: 16,
              ),
              child: Text(
                '${notifications.length}', // Número de notificaciones
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
      ],
    );
  }

  // Tabs de tareas
  Widget _buildTaskTabs() {
    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          const TabBar(
            labelColor: Colors.black,
            unselectedLabelColor: Colors.grey,
            tabs: [
              Tab(text: 'Todas las Tareas'),
              Tab(text: 'Filtrar por Fecha'),
            ],
          ),
          Expanded(
            child: TabBarView(
              children: [
                _buildAllTasksView(), // Todas las tareas
                _buildFilterByDateView(), // Filtro por fecha
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Vista de todas las tareas
  Widget _buildAllTasksView() {
    return ListView.builder(
      itemCount: _tasks.length,
      itemBuilder: (context, index) {
        final task = _tasks[index];
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
          child: ListTile(
            title: Text(
              task['title'],
              style: TextStyle(
                color: Colors.black,
                decoration: task['completed']
                    ? TextDecoration.lineThrough
                    : TextDecoration.none,
              ),
            ),
            subtitle: Text(
              'Fecha de entrega: ${DateFormat.yMMMMd().format(task['dueDate'])}',
              style: const TextStyle(color: Colors.black54),
            ),
            trailing: Checkbox(
              value: task['completed'],
              onChanged: (bool? value) {
                setState(() {
                  task['completed'] = value!;
                });
              },
            ),
            onTap: () {
              _showTaskDetailsDialog(context, task); // Mostrar diálogo al tocar
            },
          ),
        );
      },
    );
  }

  // Vista de filtro por fecha
  Widget _buildFilterByDateView() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Row(
            children: [
              _buildDateInput('Inicio', (date) {
                // Aquí puedes implementar la lógica de selección de fecha inicial
              }),
              const SizedBox(width: 10),
              _buildDateInput('Fin', (date) {
                // Aquí puedes implementar la lógica de selección de fecha final
              }),
            ],
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: () {
              // Implementa aquí la lógica para filtrar tareas por fechas
            },
            child: const Text('Filtrar'),
          ),
        ],
      ),
    );
  }

  // Input de fecha
  Widget _buildDateInput(String label, ValueChanged<DateTime?> onDateSelected) {
    return Expanded(
      child: TextField(
        readOnly: true,
        decoration: InputDecoration(
          labelText: label,
          suffixIcon: const Icon(Icons.calendar_today),
        ),
        onTap: () async {
          final date = await showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(2000),
            lastDate: DateTime(2100),
          );
          if (date != null) onDateSelected(date);
        },
      ),
    );
  }
}
