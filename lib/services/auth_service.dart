import 'package:http/http.dart' as http;
import 'dart:convert';

class AuthService {
  final String apiUrl = 'http://192.168.1.101/api/';

  // Registro
  Future<void> registerUser(
      String email, String nombre_usuario, String contrasena) async {
    final response = await http.post(
      Uri.parse('${apiUrl}register.php'),
      body: {
        'email': email,
        'nombre_usuario': nombre_usuario,
        'contrasena': contrasena, // Coincide con el PHP
      },
    );

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      if (data['success']) {
        print('Registro exitoso');
      } else {
        print('Error: ${data['message']}');
      }
    }
  }

  // Inicio de sesión
  Future<void> loginUser(String email, String contrasena) async {
    final response = await http.post(
      Uri.parse('${apiUrl}login.php'),
      body: {
        'email': email,
        'contrasena': contrasena, // Coincide con el PHP
      },
    );

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      if (data['success']) {
        print('Inicio de sesión exitoso');
      } else {
        print('Error: ${data['message']}');
      }
    }
  }
}
