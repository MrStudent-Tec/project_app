import 'package:http/http.dart' as http;
import 'dart:convert';

class AuthService {
  final String apiUrl = 'http://192.168.1.101/api/';

  // Registro
  Future<void> registerUser(String id_usuario, String nombre_usuario,
      String email, String contrasena, String fec_nac, String programa) async {
    final response = await http.post(
      Uri.parse('${apiUrl}register.php'),
      body: {
        'id_usuario': id_usuario,
        'nombre_usuario': nombre_usuario,
        'email': email,
        'contrasena': contrasena, // Coincide con el PHP
        'fec_nac': fec_nac,
        'programa': programa,
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
