import 'package:flutter/material.dart';

class AddGroupScreen extends StatelessWidget {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Agregar Nuevo Grupo'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Nombre del grupo'),
            ),
            TextField(
              controller: _messageController,
              decoration: const InputDecoration(labelText: 'Mensaje inicial'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                String name = _nameController.text;
                String message = _messageController.text;

                // Aquí haces la conexión al PHP para guardar el grupo en la base de datos
                final response = await _sendGroupData(name, message);

                if (response) {
                  // Si se guarda con éxito, retornamos el nuevo grupo a la pantalla anterior
                  Navigator.pop(context, {
                    'name': name,
                    'lastMessage': message,
                    'image':
                        'URL_IMAGEN_GRUPO', // Imagen predeterminada o cargada
                  });
                }
              },
              child: const Text('Agregar Grupo'),
            )
          ],
        ),
      ),
    );
  }

  Future<bool> _sendGroupData(String name, String message) async {
    // Conexión PHP para enviar los datos
    // Retorna true si se guarda con éxito
    return true;
  }
}
