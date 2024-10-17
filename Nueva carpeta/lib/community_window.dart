import 'package:flutter/material.dart';
import 'package:ubook/services/community_service.dart'; // Cambiado a CommunityService
import 'package:ubook/memberslist.dart'; // Importa el archivo para la lista de miembros

class CommunityWindow extends StatefulWidget {
  final int communityId;
  final String communityName;

  const CommunityWindow({
    required this.communityId,
    required this.communityName,
  });

  @override
  _CommunityWindowState createState() => _CommunityWindowState();
}

class _CommunityWindowState extends State<CommunityWindow> {
  List groups = [];
  int? selectedGroupId;
  bool isLoading = true; // Indicador de carga
  bool hasError = false; // Indicador de errores

  @override
  void initState() {
    super.initState();
    fetchGroups(); // Obtener grupos de la comunidad actual
  }

  // Función para obtener los grupos de la comunidad actual
  Future<void> fetchGroups() async {
    try {
      final fetchedGroups = await CommunityService().getCommunityGroups(
        widget.communityId.toString(),
      );
      setState(() {
        groups = fetchedGroups;
        isLoading = false; // Ocultar carga
      });
    } catch (error) {
      setState(() {
        isLoading = false;
        hasError = true; // Mostrar error
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al cargar los grupos: $error')),
      );
    }
  }

  // Función cuando se selecciona un grupo de la lista
  void onGroupSelected(int groupId) {
    setState(() {
      selectedGroupId = groupId;
    });
  }

  // Navegar a la lista de miembros de la comunidad
  void _navigateToMembersList() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CommunityMembersListScreen(
          communityId: widget.communityId, // Usa el ID de la comunidad actual
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.communityName),
        actions: [
          IconButton(
            icon: Icon(Icons.people),
            onPressed: _navigateToMembersList, // Navega a la lista de miembros
            tooltip: 'Lista de Miembros',
          ),
        ],
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator()) // Indicador de carga
          : hasError
              ? const Center(child: Text('Error al cargar los grupos'))
              : groups.isEmpty
                  ? const Center(child: Text('No hay grupos disponibles'))
                  : ListView.builder(
                      itemCount: groups.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(groups[index]['group_name']),
                          selected:
                              groups[index]['community_group_id'].toString() ==
                                  selectedGroupId.toString(),
                          onTap: () => onGroupSelected(
                            groups[index]['community_group_id'],
                          ),
                        );
                      },
                    ),
    );
  }
}
