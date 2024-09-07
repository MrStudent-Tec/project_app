import 'package:flutter/material.dart';

class GroupScreen extends StatelessWidget {
  const GroupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 10, // Número de mensajes de ejemplo
      itemBuilder: (context, index) {
        return ListTile(
          leading: CircleAvatar(
            backgroundColor: Colors.green,
            child: const Icon(Icons.person, color: Colors.white),
          ),
          title: const Text('Nombre del grupo',
              style: TextStyle(color: Color.fromARGB(255, 0, 0, 0))),
          subtitle: const Text('Mensaje de ejemplo',
              style: TextStyle(color: Color.fromARGB(255, 0, 0, 0))),
        );
      },
    );
  }
}
