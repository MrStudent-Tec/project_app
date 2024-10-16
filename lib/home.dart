import 'package:flutter/material.dart';
import 'package:ubook/calendar.dart';
import 'package:ubook/services/postservice.dart';
import 'package:ubook/services/auth_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  // Lista de publicaciones
  List<Map<String, dynamic>> posts = [];
  final PostService _postService = PostService();
  String? userId; // Variable para almacenar el ID del usuario

  @override
  void initState() {
    super.initState();
    _loadUserId(); // Cargar el ID del usuario
  }

  void _loadUserId() async {
    AuthService authService = AuthService();
    userId = await authService.getUserId(); // Recuperar el ID del usuario
    if (userId != null) {
      _loadPosts(); // Cargar publicaciones solo si el ID está disponible
    } else {
      // Manejar caso en que no se pueda recuperar el ID del usuario
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No se pudo recuperar el ID de usuario.')),
      );
    }
  }

  // Cargar publicaciones desde la API
  void _loadPosts() async {
    try {
      List<Map<String, dynamic>> loadedPosts = await _postService.getPosts();
      setState(() {
        posts = loadedPosts;
      });
    } catch (e) {
      // Manejar errores al cargar publicaciones
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al cargar publicaciones: $e')),
      );
    }
  }

  // Añadir una nueva publicación
  void _addPost(String content) async {
    if (userId != null) {
      // Verificar si el ID del usuario está disponible
      try {
        await _postService.addPost(
            int.parse(userId!), content); // Convertir el ID a int
        _loadPosts(); // Recargar publicaciones después de añadir
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al añadir publicación: $e')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ID de usuario no disponible')),
      );
    }
  }

  // Mostrar el formulario de añadir publicación
  void _showAddPostDialog() {
    String newPostContent = '';

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Añadir Publicación'),
          content: TextField(
            onChanged: (value) {
              newPostContent = value;
            },
            decoration:
                const InputDecoration(hintText: "Escribe tu publicación"),
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
                if (newPostContent.isNotEmpty) {
                  _addPost(newPostContent);
                }
                Navigator.of(context).pop();
              },
              child: const Text('Publicar'),
            ),
          ],
        );
      },
    );
  }

  // Manejar el "like" o "unlike" de una publicación
  void _toggleLike(int index) async {
    try {
      bool isLiked = posts[index]['liked'] ?? false;

      // Enviar la actualización al servidor
      final response = await _postService.toggleLike(
          int.parse(posts[index]['post_id'].toString()), isLiked);

      // Si la respuesta es exitosa, actualizar la UI con el número de likes actualizado
      setState(() {
        posts[index]['likes'] = response[
            'likes']; // Asegúrate de que 'likes' viene de la respuesta decodificada
        posts[index]['liked'] = !isLiked; // Cambiar el estado de "liked"
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al actualizar likes: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Ubook',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF004D40), // Verde oscuro
        actions: [
          IconButton(
            icon: const Icon(Icons.people),
            color: Colors.white,
            onPressed: () {
              Navigator.pushNamed(context, '/users');
            },
          ),
          IconButton(
            icon: const Icon(Icons.calendar_today),
            color: Colors.white,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CalendarScreen()),
              );
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: posts.length, // Número de publicaciones dinámico
        itemBuilder: (context, index) {
          return Card(
            color: Colors.grey[800],
            margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const CircleAvatar(
                        backgroundColor: Colors.green, // Color del avatar
                        child: Icon(Icons.person, color: Colors.white),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          posts[index]['author'] ?? 'Autor desconocido',
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                      Text(
                        posts[index]['date'] ?? '',
                        style: const TextStyle(color: Colors.grey),
                        textAlign: TextAlign.right,
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    posts[index]['content'] ?? '',
                    style: const TextStyle(color: Colors.white),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(
                          (posts[index]['liked'] ?? false)
                              ? Icons.favorite
                              : Icons.favorite_border,
                          color: (posts[index]['liked'] ?? false)
                              ? Colors.red
                              : Colors.green,
                        ),
                        onPressed: () {
                          _toggleLike(index);
                        },
                      ),
                      const SizedBox(width: 5),
                      Text(
                        '${posts[index]['likes']} likes',
                        style: const TextStyle(color: Colors.white),
                      ),
                      const Spacer(),
                      TextButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.share, color: Colors.green),
                        label: const Text(
                          'COMPARTIR',
                          style: TextStyle(color: Colors.green),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddPostDialog,
        backgroundColor: const Color(0xFF004D40),
        child: const Icon(Icons.add),
      ),
    );
  }
}
