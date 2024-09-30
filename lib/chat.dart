import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:ubook/Chatlist.dart';
import 'package:ubook/DatePerson.dart';

class Chats extends StatefulWidget {
  @override
  _ChatsState createState() => _ChatsState();
}

class _ChatsState extends State<Chats> {
  List<DatePerson> users = [];
  List<Chatlist> userChatList = [];
  String currentUserId = "your_current_user_id"; // Define the current user ID.

  @override
  void initState() {
    super.initState();
    fetchChatList();
    fetchUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: users.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: users.length,
              itemBuilder: (context, index) {
                return buildUserItem(users[index]);
              },
            ),
    );
  }

  // Widget to build individual user item
  Widget buildUserItem(DatePerson user) {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: NetworkImage(user.profile),
        radius: 25,
      ),
      title: Text(user.name),
      subtitle: Text(user.status),
      onTap: () {
        // Handle user item tap (navigate to chat or profile)
        print('User selected: ${user.name}');
      },
    );
  }

  // Function to fetch the chat list from the server
  void fetchChatList() async {
    final response = await http.post(
      Uri.parse('http://127.0.0.1/api/getChatList.php'),
      body: {
        "userId": currentUserId,
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> chatListJson = jsonDecode(response.body);
      setState(() {
        userChatList =
            chatListJson.map((json) => Chatlist.fromJson(json)).toList();
      });
    } else {
      // Handle error
      print("Failed to load chat list");
    }
  }

  // Function to fetch users from the server
  void fetchUsers() async {
    final response =
        await http.get(Uri.parse('http://127.0.0.1/api/getUsers.php'));

    if (response.statusCode == 200) {
      List<dynamic> usersJson = jsonDecode(response.body);
      List<DatePerson> allUsers =
          usersJson.map((json) => DatePerson.fromJson(json)).toList();

      // Filter users that match the chat list
      setState(() {
        users = allUsers.where((user) {
          return userChatList.any((chatlist) => chatlist.id == user.uid);
        }).toList();
      });
    } else {
      // Handle error
      print("Failed to load users");
    }
  }
}
