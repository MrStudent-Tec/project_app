import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ChatDetailScreen extends StatefulWidget {
  final String userName;
  final String userImage;
  final bool isOnline;

  const ChatDetailScreen({
    Key? key,
    required this.userName,
    required this.userImage,
    required this.isOnline,
  }) : super(key: key);

  @override
  _ChatDetailScreenState createState() => _ChatDetailScreenState();
}

class _ChatDetailScreenState extends State<ChatDetailScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ImagePicker _picker = ImagePicker();

  // Simulación de lista de mensajes
  final List<String> _messages = [];

  // Función para enviar mensaje de texto
  void _sendMessage() {
    if (_messageController.text.isNotEmpty) {
      setState(() {
        _messages.add(_messageController.text);
        _messageController.clear();
      });
    }
  }

  // Función para enviar una imagen desde la galería
  Future<void> _sendImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      // Aquí puedes implementar la subida de imagen al servidor
      print('Imagen seleccionada: ${image.path}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              backgroundImage:
                  AssetImage(widget.userImage), // Imagen del usuario
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.userName, // Nombre del usuario
                  style: const TextStyle(color: Colors.white),
                ),
                Text(
                  widget.isOnline
                      ? 'En línea'
                      : 'Desconectado', // Estado del usuario
                  style: const TextStyle(fontSize: 12, color: Colors.white),
                ),
              ],
            ),
          ],
        ),
        backgroundColor: const Color(0xFF004D40),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(_messages[index]),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.photo),
                  onPressed: _sendImage, // Seleccionar imagen desde la galería
                ),
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: const InputDecoration(
                      hintText: 'Escribe un mensaje...',
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: _sendMessage, // Enviar mensaje de texto
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
