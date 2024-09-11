import 'package:flutter/material.dart';
import 'package:ubook/chat.dart';
import 'package:ubook/comunity.dart';
import 'package:ubook/group.dart';
import 'package:ubook/settings.dart';

class UsersScreen extends StatelessWidget {
  const UsersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Usuario',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: const Color(0xFF004D40),
          actions: [
            IconButton(
              icon: const Icon(Icons.search),
              color: Colors.white,
              onPressed: () {
                // Aquí puedes implementar la acción de búsqueda
                print('Buscar icono presionado');
              },
            ),
          ],
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(50.0),
            child: Container(
              color: Colors.teal, // Fondo diferente para las pestañas
              child: const TabBar(
                indicatorColor: Colors.white,
                labelColor: Colors.white,
                unselectedLabelColor: Colors.black54,
                tabs: [
                  Tab(text: 'Chats'),
                  Tab(text: 'Grupos'),
                  Tab(text: 'Comunidad'),
                  Tab(text: 'Ajustes'),
                ],
              ),
            ),
          ),
        ),
        body: const TabBarView(
          children: [
            ChatScreen(),
            GroupScreen(),
            ComunityScreen(),
            SettingsScreen(),
          ],
        ),
      ),
    );
  }
}
