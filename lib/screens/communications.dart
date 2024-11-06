import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // Provider
import '../providers/role_provider.dart'; // RoleProvider

class CommunicationScreen extends StatefulWidget {
  const CommunicationScreen({super.key});

  @override
  CommunicationScreenState createState() => CommunicationScreenState();
}

class CommunicationScreenState extends State<CommunicationScreen> {
  final List<Map<String, String>> _allCommunications = [
    {
      'title': 'Reunión de padres',
      'type': 'Institucional',
      'content': 'Reunión importante el 10 de noviembre a las 6 PM.',
      'author': 'Victoria Belgrano',
      'date': '10 Nov, 2024',
      'time': '18:00',
      'imageUrl': 'https://via.placeholder.com/300', // Imagen opcional
    },
    {
      'title': 'Cambio de horarios',
      'type': 'Institucional',
      'content': 'Desde el 1 de diciembre habrá un nuevo horario escolar.',
      'author': 'Dirección Académica',
      'date': '1 Dic, 2024',
      'time': '09:15',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final role = Provider.of<RoleProvider>(context).role; // Obtener el rol

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, // Sin botón de retroceso
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Comunicados',
          style: TextStyle(
            color: Colors.black, // Título en negro
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.black),
            onPressed: () {
              showSearch(
                context: context,
                delegate: CommunicationSearchDelegate(_allCommunications),
              );
            },
          ),
        ],
      ),
      body: _buildCommunicationList(_allCommunications),
    );
  }

  Widget _buildCommunicationList(List<Map<String, String>> communications) {
    return ListView.builder(
      itemCount: communications.length,
      itemBuilder: (context, index) {
        final communication = communications[index];
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
          child: Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.0),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (communication['imageUrl'] != null) // Imagen opcional
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(16.0),
                    ),
                    child: Image.network(
                      communication['imageUrl']!,
                      height: 150,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        communication['title']!,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        communication['type']!,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.blueGrey,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        communication['content']!,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black54,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Por: ${communication['author']!}',
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.black87,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                          Text(
                            '${communication['date']!} - ${communication['time']!}',
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

// Delegado de búsqueda
class CommunicationSearchDelegate extends SearchDelegate {
  final List<Map<String, String>> communications;

  CommunicationSearchDelegate(this.communications);

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = ''; // Limpiar búsqueda
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
        close(context, null); // Cerrar búsqueda
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final results = communications.where((communication) {
      final title = communication['title']!.toLowerCase();
      final content = communication['content']!.toLowerCase();
      return title.contains(query.toLowerCase()) ||
          content.contains(query.toLowerCase());
    }).toList();

    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        final communication = results[index];
        return ListTile(
          title: Text(communication['title']!),
          subtitle: Text(communication['content']!),
          trailing: Text('${communication['date']} - ${communication['time']}'),
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestions = communications.where((communication) {
      final title = communication['title']!.toLowerCase();
      return title.contains(query.toLowerCase());
    }).toList();

    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (context, index) {
        final communication = suggestions[index];
        return ListTile(
          title: Text(communication['title']!),
          onTap: () {
            query = communication['title']!;
            showResults(context); // Mostrar resultados
          },
        );
      },
    );
  }
}
