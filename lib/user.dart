import 'package:flutter/material.dart';
import 'package:ubook/chat.dart';
import 'package:ubook/chat_detail_screen.dart';
import 'package:ubook/comunity.dart';
import 'package:ubook/group.dart';
import 'package:ubook/settings.dart';
import 'dart:convert'; // Para decodificar respuestas JSON
import 'package:http/http.dart' as http; // Para hacer solicitudes HTTP

class UsersScreen extends StatefulWidget {
  const UsersScreen({super.key});

  @override
  _UsersScreenState createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen> {
  bool _isSearching = false; // Estado para saber si estamos en modo búsqueda
  List<dynamic> _searchResults = []; // Lista para guardar los resultados
  TextEditingController _searchController = TextEditingController();

  String currentUserId = '123'; // Aquí debes asignar el currentUserId adecuado

  // Función para obtener la lista de personas desde MySQL
  Future<void> _searchUsers(String query) async {
    final response = await http.post(
      Uri.parse(
          'http://127.0.0.1/api/getUsers.php'), // Asegúrate de cambiar la URL
      body: {'query': query},
    );

    if (response.statusCode == 200) {
      final List<dynamic> results = json.decode(response.body);
      setState(() {
        _searchResults = results;
      });
    } else {
      // Manejo de errores
      print('Error en la búsqueda');
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: !_isSearching
              ? const Text('Ubook', style: TextStyle(color: Colors.white))
              : TextField(
                  controller: _searchController,
                  decoration: const InputDecoration(
                    hintText: 'Buscar...',
                    hintStyle: TextStyle(color: Colors.white),
                  ),
                  style: const TextStyle(color: Colors.white),
                  onChanged: (value) {
                    _searchUsers(value); // Ejecutar búsqueda en tiempo real
                  },
                ),
          backgroundColor: const Color(0xFF004D40),
          actions: [
            IconButton(
              icon: Icon(_isSearching ? Icons.close : Icons.search),
              color: Colors.white,
              onPressed: () {
                setState(() {
                  _isSearching = !_isSearching;
                  _searchController.clear(); // Limpiar el campo de búsqueda
                  _searchResults.clear(); // Limpiar los resultados
                });
              },
            ),
          ],
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(50.0),
            child: Container(
              color: Colors.teal,
              child: const TabBar(
                indicatorColor: Colors.white,
                labelColor: Colors.white,
                unselectedLabelColor: Colors.black54,
                tabs: [
                  Tab(text: 'Chats'),
                  Tab(text: 'Grupos'),
                  Tab(text: 'Comunidad'),
                  Tab(text: 'Ajustes'),
                ],
              ),
            ),
          ),
        ),
        body: TabBarView(
          children: [
            _isSearching
                ? _buildSearchResults() // Mostrar resultados de búsqueda
                : Chats(),
            GroupScreen(),
            ComunityScreen(),
            SettingsScreen(),
          ],
        ),
      ),
    );
  }

  // Widget para mostrar la lista de resultados de búsqueda
  Widget _buildSearchResults() {
    return ListView.builder(
      itemCount: _searchResults.length,
      itemBuilder: (context, index) {
        final person = _searchResults[index];

        return InkWell(
          onTap: () {
            // Al tocar la tarjeta, navega a la pantalla de chat
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ChatScreen(
                  userId: person['uid']?.toString() ?? '', // Evitar null
                  userName:
                      person['name'] ?? 'Unknown User', // Nombre por defecto
                  userProfileImage: person['profile'] ??
                      'https://example.com/default-profile.png', // Imagen por defecto
                  currentUserId: currentUserId, // Asegúrate de que no sea null
                ),
              ),
            );
          },
          child: Card(
            margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            elevation: 8.0, // Incrementa el valor para un sombreado más visible
            shadowColor: Colors.black54, // Color del sombreado
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  // Imagen de perfil
                  CircleAvatar(
                    radius: 40, // Tamaño de 80px por 80px
                    backgroundImage: person['profile'] != null
                        ? NetworkImage(
                            person['profile']) // Imagen de perfil desde URL
                        : const AssetImage('assets/person_icon.png')
                            as ImageProvider, // Imagen por defecto
                  ),
                  const SizedBox(
                      width: 16), // Espacio entre la imagen y el texto

                  // Columna con la información del usuario
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Nombre del usuario
                        Text(
                          person['name'] ?? 'Sin nombre',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),

                        // Programa del usuario
                        Text(
                          person['program'] ?? 'Sin programa',
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 8),

                        // Estado del usuario (Online u Offline)
                        Text(
                          person['status'] == 'online'
                              ? 'En línea'
                              : 'Desconectado',
                          style: TextStyle(
                            fontSize: 14,
                            color: person['status'] == 'online'
                                ? Colors.green
                                : Colors.red,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
