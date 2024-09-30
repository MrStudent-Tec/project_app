import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:ubook/modelChat.dart';

class ChatAdapter extends StatelessWidget {
  final List<Chat> chatList;
  final String imageUrl;
  final String currentUserId;

  ChatAdapter({
    required this.chatList,
    required this.imageUrl,
    required this.currentUserId,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: chatList.length,
      itemBuilder: (context, position) {
        final chat = chatList[position];
        return _buildChatItem(chat, position, context);
      },
    );
  }

  Widget _buildChatItem(Chat chat, int position, BuildContext context) {
    final isSender = chat.sender == currentUserId;

    return Container(
      margin: EdgeInsets.symmetric(vertical: 5),
      child: Row(
        mainAxisAlignment:
            isSender ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!isSender)
            CircleAvatar(
              backgroundImage: CachedNetworkImageProvider(imageUrl),
            ),
          SizedBox(width: 8),
          if (chat.message == "sent you an image." && chat.url.isNotEmpty)
            _buildImageMessage(chat, isSender, context, position)
          else
            _buildTextMessage(chat, isSender, context, position),
        ],
      ),
    );
  }

  Widget _buildTextMessage(
      Chat chat, bool isSender, BuildContext context, int position) {
    return GestureDetector(
      onLongPress: () {
        if (isSender) {
          _showDeleteDialog(context, position);
        }
      },
      child: Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: isSender ? Colors.blue : Colors.grey[300],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          chat.message,
          style: TextStyle(color: isSender ? Colors.white : Colors.black),
        ),
      ),
    );
  }

  Widget _buildImageMessage(
      Chat chat, bool isSender, BuildContext context, int position) {
    return GestureDetector(
      onTap: () => _showImageOptions(context, chat.url, position),
      child: CachedNetworkImage(
        imageUrl: chat.url,
        placeholder: (context, url) => CircularProgressIndicator(),
        errorWidget: (context, url, error) => Icon(Icons.error),
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, int position) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("What do you want to do?"),
          actions: [
            TextButton(
              onPressed: () {
                deleteSentMessage(position);
                Navigator.of(context).pop();
              },
              child: Text("Delete message"),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text("Cancel"),
            ),
          ],
        );
      },
    );
  }

  void _showImageOptions(BuildContext context, String url, int position) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("What do you want to do?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                // Navigate to full image view
              },
              child: Text("View full image"),
            ),
            if (chatList[position].sender == currentUserId)
              TextButton(
                onPressed: () {
                  deleteSentMessage(position);
                  Navigator.of(context).pop();
                },
                child: Text("Delete image"),
              ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text("Cancel"),
            ),
          ],
        );
      },
    );
  }

  void deleteSentMessage(int position) async {
    String messageId = chatList[position].messageId;

    final response = await http.post(
      Uri.parse("http://127.0.0.1/api/deleteMessage.php"),
      body: {
        "messageId": messageId,
      },
    );

    if (response.statusCode == 200) {
      var result = jsonDecode(response.body);
      if (result['success']) {
        // Message deleted successfully
      } else {
        // Show error message
      }
    } else {
      // Show error message
    }
  }
}
