import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

// Pantalla de chat, que recibe los datos del usuario seleccionado
class ChatScreen extends StatefulWidget {
  final String userId;
  final String userName;
  final String userProfileImage;
  final String currentUserId; // Añadido el ID del usuario actual

  const ChatScreen({
    Key? key,
    required this.userId,
    required this.userName,
    required this.userProfileImage,
    required this.currentUserId,
  }) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  TextEditingController _messageController = TextEditingController();
  List<dynamic> _messages = [];
  bool notify = false;

  @override
  void initState() {
    super.initState();
    _retrieveMessages();
  }

  // Enviar mensaje
  Future<void> _sendMessage() async {
    String message = _messageController.text;

    if (message.isNotEmpty) {
      var response = await http.post(
        Uri.parse('http://127.0.0.1/api/send_message.php'),
        body: {
          'sender': widget.currentUserId,
          'receiver': widget.userId,
          'message': message,
        },
      );

      var jsonResponse = jsonDecode(response.body);
      if (jsonResponse['status'] == 'success') {
        setState(() {
          _messageController.clear();
          _retrieveMessages();
        });
      }
    }
  }

  // Recuperar mensajes
  Future<void> _retrieveMessages() async {
    var response = await http.get(
      Uri.parse(
          'http://127.0.0.1/api/retrieve_messages.php?senderId=${widget.currentUserId}&receiverId=${widget.userId}'),
    );

    var jsonResponse = jsonDecode(response.body);
    setState(() {
      _messages = jsonResponse;
    });
  }

  // Subir imagen
  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      var request = http.MultipartRequest(
          'POST', Uri.parse('http://127.0.0.1/api/upload_image.php'));
      request.files
          .add(await http.MultipartFile.fromPath('image', pickedFile.path));

      var response = await request.send();
      if (response.statusCode == 200) {
        var responseData = await response.stream.bytesToString();
        var jsonResponse = jsonDecode(responseData);
        if (jsonResponse['status'] == 'success') {
          String imageUrl = jsonResponse['url'];
          _sendMessageWithImage(imageUrl);
        }
      }
    }
  }

  // Enviar imagen como mensaje
  Future<void> _sendMessageWithImage(String imageUrl) async {
    var response = await http.post(
      Uri.parse('http://127.0.0.1/api/send_message.php'),
      body: {
        'sender': widget.currentUserId,
        'receiver': widget.userId,
        'message': 'Sent you an image.',
        'url': imageUrl,
      },
    );

    var jsonResponse = jsonDecode(response.body);
    if (jsonResponse['status'] == 'success') {
      _retrieveMessages();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              backgroundImage: widget.userProfileImage.isNotEmpty
                  ? NetworkImage(widget.userProfileImage)
                  : AssetImage('assets/default_profile.png') as ImageProvider,
            ),
            const SizedBox(width: 8),
            Text(widget.userName),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                var message = _messages[index];
                return ListTile(
                  title: Text(message['message']),
                  subtitle: message['url'] != null
                      ? Image.network('http://127.0.0.1/api/${message['url']}')
                      : null,
                );
              },
            ),
          ),
          Row(
            children: [
              IconButton(
                icon: Icon(Icons.image),
                onPressed: _pickImage,
              ),
              Expanded(
                child: TextField(
                  controller: _messageController,
                  decoration: InputDecoration(hintText: 'Type a message'),
                ),
              ),
              IconButton(
                icon: Icon(Icons.send),
                onPressed: _sendMessage,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
