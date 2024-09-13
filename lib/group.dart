import 'package:flutter/material.dart';
import 'package:ubook/addgroup.dart'; // La pantalla que agregará el grupo

class GroupScreen extends StatefulWidget {
  const GroupScreen({super.key});

  @override
  _GroupScreenState createState() => _GroupScreenState();
}

class _GroupScreenState extends State<GroupScreen> {
  List<Map<String, dynamic>> groups = []; // Lista vacía de grupos

  @override
  void initState() {
    super.initState();
    _fetchGroups(); // Cargar los grupos al iniciar
  }

  void _fetchGroups() async {
    // Llamada al PHP para obtener los grupos desde la base de datos
    // Actualiza la lista con los grupos obtenidos
    // Aquí puedes hacer una llamada HTTP
  }

  void _addGroup(Map<String, dynamic> group) {
    setState(() {
      groups.add(group);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: groups.length, // Número de grupos en la base de datos
        itemBuilder: (context, index) {
          final group = groups[index];
          return ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage(group['image']),
            ),
            title: Text(group['name'],
                style: const TextStyle(color: Color.fromARGB(255, 0, 0, 0))),
            subtitle: Text(group['lastMessage'] ?? 'No hay mensajes aún',
                style: const TextStyle(color: Color.fromARGB(255, 0, 0, 0))),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final newGroup = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddGroupScreen()),
          );
          if (newGroup != null) {
            _addGroup(newGroup);
          }
        },
        child: const Icon(Icons.add),
        backgroundColor: Colors.green,
      ),
    );
  }
}
