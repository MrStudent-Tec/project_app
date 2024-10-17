import 'package:flutter/material.dart';
import 'package:ubook/services/community_service.dart'; // Asegúrate de tener un servicio para obtener miembros

class CommunityMembersListScreen extends StatefulWidget {
  final int communityId;

  const CommunityMembersListScreen({
    required this.communityId,
  });

  @override
  _CommunityMembersListScreenState createState() =>
      _CommunityMembersListScreenState();
}

class _CommunityMembersListScreenState
    extends State<CommunityMembersListScreen> {
  List communityMembers = [];
  bool isLoading = true;
  bool hasError = false;

  @override
  void initState() {
    super.initState();
    fetchCommunityMembers();
  }

  // Función para obtener los miembros de la comunidad
  Future<void> fetchCommunityMembers() async {
    try {
      final fetchedMembers = await CommunityService()
          .getCommunityMembers(widget.communityId.toString());
      setState(() {
        communityMembers = fetchedMembers;
        isLoading = false;
      });
    } catch (error) {
      setState(() {
        isLoading = false;
        hasError = true;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al cargar los miembros: $error')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Miembros de la Comunidad'),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : hasError
              ? const Center(child: Text('Error al cargar los miembros'))
              : communityMembers.isEmpty
                  ? const Center(
                      child: Text('No hay miembros en esta comunidad'))
                  : ListView.builder(
                      itemCount: communityMembers.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(communityMembers[index]['member_name']),
                          subtitle: Text(
                              'ID: ${communityMembers[index]['member_id']}'),
                        );
                      },
                    ),
    );
  }
}
