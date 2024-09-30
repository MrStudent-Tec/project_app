import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class MessageChatScreen extends StatefulWidget {
  final String userIdVisit;
  final String currentUserId;

  MessageChatScreen({required this.userIdVisit, required this.currentUserId});

  @override
  _MessageChatScreenState createState() => _MessageChatScreenState();
}

class _MessageChatScreenState extends State<MessageChatScreen> {
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
          'receiver': widget.userIdVisit,
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
          'http://127.0.0.1/api/retrieve_messages.php?senderId=${widget.currentUserId}&receiverId=${widget.userIdVisit}'),
    );

    var jsonResponse = jsonDecode(response.body);
    setState(() {
      _messages = jsonResponse;
    });
  }

  // Subir imagen
  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker()
        .pickImage(source: ImageSource.gallery); // Corrección aquí
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

  Future<void> _sendMessageWithImage(String imageUrl) async {
    var response = await http.post(
      Uri.parse('http://127.0.0.1/api/send_message.php'),
      body: {
        'sender': widget.currentUserId,
        'receiver': widget.userIdVisit,
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
        title: Text('Chat'),
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
