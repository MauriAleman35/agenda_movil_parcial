import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/role_provider.dart';
import '../service/student_service.dart'; // Importa tu servicio

class CommunicationScreen extends StatefulWidget {
  final int? estudianteId; // Recibe el `estudianteId`

  const CommunicationScreen({super.key, this.estudianteId});

  @override
  CommunicationScreenState createState() => CommunicationScreenState();
}

class CommunicationScreenState extends State<CommunicationScreen> {
  List<Map<String, dynamic>> communications =
      []; // Cambia a `dynamic` para manejar la estructura
  bool isLoading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    _loadCommunications();
  }

  Future<void> _loadCommunications() async {
    try {
      if (widget.estudianteId != null) {
        // Carga los comunicados del estudiante
        final response =
            await StudentsService.getComunicadosByStudent(widget.estudianteId!);
        if (response != null && response.statusCode == 200) {
          // Asegúrate de que la estructura de datos sea correcta
          final data = response.data['comunicados'] as List;
          setState(() {
            communications = data.cast<Map<String, dynamic>>();
            isLoading = false;
          });
        } else {
          setState(() {
            errorMessage = 'Error al obtener los comunicados.';
            isLoading = false;
          });
        }
      } else {
        setState(() {
          errorMessage = 'ID de estudiante no válido.';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Error al obtener los comunicados: $e';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Comunicados',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.black),
            onPressed: () {
              showSearch(
                context: context,
                delegate: CommunicationSearchDelegate(communications),
              );
            },
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : errorMessage.isNotEmpty
              ? Center(child: Text(errorMessage))
              : _buildCommunicationList(communications),
    );
  }

  Widget _buildCommunicationList(List<Map<String, dynamic>> communications) {
    if (communications.isEmpty) {
      return const Center(child: Text('No hay comunicados disponibles.'));
    }

    return ListView.builder(
      itemCount: communications.length,
      itemBuilder: (context, index) {
        final communication = communications[index];
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.0),
            ),
            child: ListTile(
              title: Text(communication['titulo'] ?? 'Sin título'),
              subtitle: Text(communication['mensaje'] ?? 'Sin mensaje'),
              trailing: Text(communication['fecha'] ?? 'Sin fecha'),
            ),
          ),
        );
      },
    );
  }
}

// Delegado de búsqueda
class CommunicationSearchDelegate extends SearchDelegate {
  final List<Map<String, dynamic>> communications;

  CommunicationSearchDelegate(this.communications);

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
          showSuggestions(context);
        },
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final results = communications.where((communication) {
      final title = (communication['title'] ?? '').toLowerCase();
      final content = (communication['content'] ?? '').toLowerCase();
      return title.contains(query.toLowerCase()) ||
          content.contains(query.toLowerCase());
    }).toList();

    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        final communication = results[index];
        return ListTile(
          title: Text(communication['title'] ?? 'Sin título'),
          subtitle: Text(communication['content'] ?? 'Sin contenido'),
          trailing: Text(
              '${communication['date'] ?? ''} - ${communication['time'] ?? ''}'),
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestions = communications.where((communication) {
      final title = (communication['title'] ?? '').toLowerCase();
      return title.contains(query.toLowerCase());
    }).toList();

    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (context, index) {
        final communication = suggestions[index];
        return ListTile(
          title: Text(communication['title'] ?? 'Sin título'),
          onTap: () {
            query = communication['title'] ?? '';
            showResults(context);
          },
        );
      },
    );
  }
}
