import 'package:flutter/material.dart';
import 'dart:async'; // Importar Timer
import 'package:ubook/services/group_service.dart';
import 'package:ubook/services/auth_service.dart';
import 'package:ubook/listmembers.dart'; // Importamos la pantalla de lista de miembros
import 'package:collection/collection.dart'; // Para comparar listas

class GroupWindow extends StatefulWidget {
  final String groupId;
  final String creatorId;
  final String groupName;

  GroupWindow({
    required this.groupId,
    required this.creatorId,
    required this.groupName,
    Key? key,
  }) : super(key: key);

  @override
  _GroupWindowState createState() => _GroupWindowState();
}

class _GroupWindowState extends State<GroupWindow> {
  final GroupService _groupService = GroupService();
  final AuthService _authService = AuthService();
  List<Map<String, dynamic>> messages = [];
  List<Map<String, dynamic>> members = [];
  String? currentUserId;
  TextEditingController _messageController = TextEditingController();
  bool _isLoading = false; // Indicador de carga
  Timer? _pollingTimer; // Definir el timer para polling

  @override
  void initState() {
    super.initState();
    getCurrentUserId();
    // Configurar el polling para ejecutar loadMessages cada 5 segundos
    _pollingTimer = Timer.periodic(Duration(seconds: 5), (timer) {
      loadMessages(); // Actualizar los mensajes periódicamente
    });
  }

  @override
  void dispose() {
    _pollingTimer?.cancel(); // Cancelar el timer cuando se destruye el widget
    _messageController.dispose(); // Liberar el controlador del TextField
    super.dispose();
  }

  // Obtener el ID del usuario actual
  void getCurrentUserId() async {
    currentUserId = await _authService.getUserId();
    await loadMessages();
    await loadMembers();
    setState(() {});
  }

  // Verificar si el usuario es el administrador (creador del grupo)
  bool isAdmin() {
    return currentUserId == widget.creatorId;
  }

  // Cargar mensajes del grupo
  Future<void> loadMessages() async {
    try {
      List<Map<String, dynamic>> rawMessages =
          await _groupService.getGroupMessages(widget.groupId);

      List<Map<String, dynamic>> newMessages = rawMessages.map((message) {
        String senderId = message['sender_id'].toString();
        String currentUserIdStr = currentUserId.toString();
        bool isSender = senderId == currentUserIdStr;

        return {
          ...message,
          'isSender': isSender,
        };
      }).toList();

      // Solo actualizar si los mensajes son diferentes
      if (newMessages.length != messages.length ||
          !ListEquality().equals(newMessages, messages)) {
        setState(() {
          messages = newMessages;
        });
      }
    } catch (e) {
      showError('Error al cargar mensajes: $e');
    }
  }

  // Cargar miembros del grupo
  Future<void> loadMembers() async {
    try {
      members = await _groupService.getGroupMembers(widget.groupId);
      setState(() {}); // Actualizar lista de miembros
    } catch (e) {
      showError('Error al cargar miembros: $e');
    }
  }

  // Enviar un nuevo mensaje
  Future<void> sendMessage() async {
    String message = _messageController.text;
    if (message.isNotEmpty) {
      try {
        await _groupService.sendMessageToGroup(
          widget.groupId,
          currentUserId!,
          message,
          null,
        );
        _messageController.clear(); // Limpiar el campo de mensaje

        // Añadir el mensaje localmente sin recargar toda la lista
        setState(() {
          messages.add({
            'message': message,
            'isSender': true,
            'sender_id': currentUserId,
          });
        });
      } catch (e) {
        showError('Error al enviar el mensaje: $e');
      }
    }
  }

  // Mostrar error
  void showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  // Navegar a la lista de miembros
  void navigateToMembersList() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MembersListScreen(
          members: members,
          groupId: widget.groupId,
          creatorId: widget.creatorId,
          currentUserId: currentUserId,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.groupName),
        actions: [
          if (isAdmin())
            IconButton(
              icon: Icon(Icons.group),
              onPressed: navigateToMembersList,
            ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: _isLoading
                ? Center(
                    child: CircularProgressIndicator(),
                  ) // Mostrar spinner si está cargando
                : ListView.builder(
                    key: Key('messagesList'), // Clave única para ListView
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      var message = messages[index];
                      bool isSender = message['isSender'];

                      return MessageWidget(
                        key: Key(
                            message['message_id'].toString()), // Usar ID único
                        message: message['message'],
                        senderName: message['senderName'] ?? 'Desconocido',
                        isSender: isSender,
                      );
                    },
                  ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: 'Escribe un mensaje...',
                      filled: true,
                      fillColor: Colors.grey[200],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class MessageWidget extends StatelessWidget {
  final String message;
  final String senderName;
  final bool isSender;

  const MessageWidget({
    Key? key,
    required this.message,
    required this.senderName,
    required this.isSender,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isSender ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
        padding: EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          color: isSender ? Colors.blue[200] : Colors.grey[300],
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(12.0),
            topRight: Radius.circular(12.0),
            bottomLeft: isSender ? Radius.circular(12.0) : Radius.zero,
            bottomRight: isSender ? Radius.zero : Radius.circular(12.0),
          ),
        ),
        child: Column(
          crossAxisAlignment:
              isSender ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            if (!isSender)
              Text(
                senderName,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            Text(
              message,
              style: TextStyle(color: Colors.black),
            ),
          ],
        ),
      ),
    );
  }
}
