import 'package:flutter/material.dart';
import 'package:ubook/services/community_service.dart';
import 'package:ubook/services/auth_service.dart';
import 'package:ubook/createcommunity.dart';
import 'package:ubook/community_window.dart';

class CommunityScreen extends StatefulWidget {
  const CommunityScreen({super.key});

  @override
  _CommunityScreenState createState() => _CommunityScreenState();
}

class _CommunityScreenState extends State<CommunityScreen> {
  final CommunityService _communityService = CommunityService();
  final AuthService _authService = AuthService();
  List communities = [];
  String? currentUserId;

  @override
  void initState() {
    super.initState();
    fetchUserIdAndCommunities(); // Llamada para cargar el userId y las comunidades
  }

  // Obtener el userId del usuario logueado y luego cargar las comunidades
  Future<void> fetchUserIdAndCommunities() async {
    try {
      currentUserId =
          await _authService.getUserId(); // Obtiene el ID del usuario
      if (currentUserId != null) {
        fetchCommunities(currentUserId!); // Carga las comunidades
      } else {
        print('Error: No se pudo obtener el ID del usuario');
      }
    } catch (e) {
      print('Error al obtener el userId: $e');
    }
  }

  // Función para obtener la lista de comunidades
  Future<void> fetchCommunities(String userId) async {
    try {
      final fetchedCommunities = await _communityService.getCommunities(userId);
      setState(() {
        communities = fetchedCommunities;
      });
    } catch (error) {
      print('Error al cargar comunidades: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: communities.isEmpty
          ? const Center(
              child: Text(
                'No te has unido a ninguna comunidad',
                style: TextStyle(fontSize: 18, color: Colors.black54),
              ),
            )
          : ListView.builder(
              itemCount: communities.length,
              itemBuilder: (context, index) {
                final community = communities[index];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.green,
                    child: community['community_image'] != null &&
                            community['community_image'].isNotEmpty
                        ? ClipOval(
                            child: Image.network(
                              community['community_image'],
                              fit: BoxFit.cover,
                              width: 100,
                              height: 100,
                            ),
                          )
                        : const Icon(Icons.group, color: Colors.white),
                  ),
                  title: Text(
                    community['community_name'],
                    style: const TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
                  ),
                  // Eliminar el ID de la comunidad de aquí
                  // subtitle: Text(
                  //   'ID de la comunidad: ${community['community_id']}',
                  //   style: const TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
                  // ),
                  onTap: () {
                    // Navegar a la ventana de la comunidad seleccionada
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CommunityWindow(
                          communityId: community['community_id'],
                          communityName: community['community_name'],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navegar a la pantalla de creación de comunidad
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CreateCommunityScreen(),
            ),
          );
        },
        child: const Icon(Icons.add),
        backgroundColor: Colors.green,
      ),
    );
  }
}
