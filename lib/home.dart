import 'package:flutter/material.dart';
import 'package:proyecto_u/calendar.dart'; // Importar la pantalla de calendario

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Lista de publicaciones
  List<Map<String, dynamic>> posts = [];

  // Método para añadir una nueva publicación
  void _addPost(String content) {
    setState(() {
      posts.add({
        'author': 'Usuario',
        'date': DateTime.now().toString(),
        'content': content,
        'likes': 0,
        'liked': false,
      });
    });
  }

  // Método para mostrar el formulario de añadir publicación
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

  // Método para manejar el estado del "like"
  void _toggleLike(int index) {
    setState(() {
      if (posts[index]['liked']) {
        posts[index]['likes']--;
      } else {
        posts[index]['likes']++;
      }
      posts[index]['liked'] = !posts[index]['liked'];
    });
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
                      CircleAvatar(
                        backgroundColor: Colors.green, // Color del avatar
                        child: const Icon(Icons.person, color: Colors.white),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          posts[index]['author']!,
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                      Text(
                        posts[index]['date']!,
                        style: const TextStyle(color: Colors.grey),
                        textAlign: TextAlign.right,
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    posts[index]['content']!,
                    style: const TextStyle(color: Colors.white),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(
                          posts[index]['liked']
                              ? Icons.favorite
                              : Icons.favorite_border,
                          color:
                              posts[index]['liked'] ? Colors.red : Colors.green,
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
