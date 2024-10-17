import 'package:flutter/material.dart';
import 'package:ubook/services/community_service.dart'; // Cambiado a CommunityService
import 'package:ubook/group_window.dart'; // Componente para mostrar la ventana del grupo
import 'package:ubook/services/auth_service.dart';

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

  Future<void> _showAvailableGroupsDialog() async {
    try {
      // Obtener el uid del usuario autenticado desde AuthService
      final userId = await AuthService().getUserId();

      if (userId == null) {
        // Manejar el caso en que no se ha encontrado el uid (usuario no autenticado)
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error: Usuario no autenticado')),
        );
        return;
      }

      // Obtener grupos disponibles para añadir a la comunidad
      final availableGroups = await CommunityService().getAvailableGroups(
        widget.communityId.toInt(),
      );

      if (availableGroups.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No hay grupos disponibles')),
        );
        return;
      }

      // Mostrar diálogo de selección de grupo
      String? selectedGroupId = await showDialog<String>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Selecciona un grupo para añadir'),
            content: SizedBox(
              width: double.maxFinite,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: availableGroups.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(availableGroups[index]['group_name']),
                    onTap: () {
                      Navigator.of(context).pop(
                        availableGroups[index]['group_id'].toString(),
                      );
                    },
                  );
                },
              ),
            ),
          );
        },
      );
      if (selectedGroupId != null) {
        // Obtener el nombre del grupo seleccionado
        final selectedGroup = availableGroups.firstWhere(
          (group) => group['group_id'].toString() == selectedGroupId,
        );

        // Verificaciones para asegurarse de que no hay valores nulos
        if (userId == null) {
          print(
              'Error: El userId es null. Asegúrate de que el usuario está autenticado.');
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text('Error: El usuario no está autenticado')),
          );
          return;
        }

        if (selectedGroupId == null) {
          print('Error: El groupId es null.');
          return;
        }

        if (selectedGroup['group_name'] == null) {
          print('Error: El group_name es null.');
          return;
        }

        // Imprimir los valores que se van a pasar
        print('Datos que se van a enviar:');
        print('communityId: ${widget.communityId}');
        print('groupId: $selectedGroupId');
        print('groupName: ${selectedGroup['group_name']}');
        print('groupImage: ""'); // Imagen no provista
        print('createdBy: $userId');

        try {
          // Llama a la función que añade el grupo a la comunidad
          bool success = await CommunityService().addCommunityGroup(
            widget.communityId.toString(),
            selectedGroupId, // `group_id` seleccionado
            selectedGroup['group_name'], // `group_name` seleccionado
            '', // Imagen del grupo, si es necesario
            userId, // `uid` del usuario autenticado
          );

          if (success) {
            fetchGroups(); // Recargar los grupos de la comunidad
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Grupo añadido con éxito')),
            );
          } else {
            // Imprimir el error si la operación no tuvo éxito
            print('Error: La operación falló al añadir el grupo.');
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Error al añadir el grupo')),
            );
          }
        } catch (e) {
          // Imprimir el error detallado
          print('Error al intentar añadir el grupo: $e');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: $e')),
          );
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.communityName),
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator()) // Indicador de carga
          : hasError
              ? const Center(child: Text('Error al cargar los grupos'))
              : groups.isEmpty
                  ? const Center(child: Text('No hay grupos disponibles'))
                  : Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: ListView.builder(
                            itemCount: groups.length,
                            itemBuilder: (context, index) {
                              return ListTile(
                                title: Text(groups[index]['group_name']),
                                selected: groups[index]['community_group_id']
                                        .toString() ==
                                    selectedGroupId.toString(),
                                onTap: () => onGroupSelected(
                                  groups[index]['community_group_id'],
                                ),
                              );
                            },
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: selectedGroupId != null
                              ? GroupWindow(
                                  groupId: groups[selectedGroupId!]
                                          ['community_group_id']
                                      .toString(), // groupId convertido a String
                                  groupName: groups[selectedGroupId!]
                                      ['group_name'], // groupName ya es String
                                  creatorId: groups[selectedGroupId!]
                                          ['creator_id']
                                      .toString(), // creatorId convertido a String
                                )
                              : const Center(
                                  child: Text('Seleccione un grupo'),
                                ),
                        ),
                      ],
                    ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAvailableGroupsDialog(); // Mostrar el diálogo para añadir un grupo
        },
        child: const Icon(Icons.add),
        tooltip: 'Añadir nuevo grupo',
      ),
    );
  }
}
