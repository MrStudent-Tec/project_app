import 'package:flutter/material.dart';
import 'chat_detail_screen.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 10, // Número de chats de ejemplo
      itemBuilder: (context, index) {
        return ListTile(
          leading: CircleAvatar(
            backgroundColor: Colors.green,
            child: const Icon(Icons.person, color: Colors.white),
          ),
          title: const Text('Nombre del usuario',
              style: TextStyle(color: Color.fromARGB(255, 0, 0, 0))),
          subtitle: const Text('Mensaje de ejemplo',
              style: TextStyle(color: Color.fromARGB(255, 0, 0, 0))),
          onTap: () {
            // Navegar a la pantalla de detalles del chat
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ChatDetailScreen(
                  userName: 'Nombre del usuario',
                  userImage: 'assets/user.png', // Ruta de la imagen del usuario
                  isOnline: true, // Estado de ejemplo
                ),
              ),
            );
          },
        );
      },
    );
  }
}
