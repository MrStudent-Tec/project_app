import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:ubook/notificationModel.dart';

class NotificationService {
  // Método para obtener las notificaciones de un usuario
  Future<List<NotificationModel>> fetchNotifications(int userId) async {
    try {
      final url = 'http://127.0.0.1/api/get_notifications.php?user_id=$userId';
      print('Fetching notifications from: $url');

      final response = await http.get(
        Uri.parse(url),
      );

      print(
          'Server response: ${response.body}'); // Imprime la respuesta del servidor

      if (response.statusCode == 200) {
        List<dynamic> body = jsonDecode(response.body);

        // Verificar si la respuesta es válida y tiene datos
        if (body.isNotEmpty) {
          return body.map((json) => NotificationModel.fromJson(json)).toList();
        } else {
          return []; // Si no hay notificaciones, retornar una lista vacía
        }
      } else {
        throw Exception(
            'Error al obtener las notificaciones. Código: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
      throw Exception('Error al conectar con el servidor: $e');
    }
  }
}
