import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'dart:io';

class AuthService {
  // Inicializar el logger
  final logger = Logger();

  // URL base de la API
  final String baseUrl = "http://127.0.0.1/api/";

  // Método para registrar un usuario
  Future<void> registerUser(
      String id_usuario,
      String email,
      String nombreUsuario,
      String contrasena,
      String fecNac,
      String programa) async {
    final String registerUrl =
        "$baseUrl/register.php"; // Ruta completa para el registro

    try {
      final response = await http.post(
        Uri.parse(registerUrl),
        body: {
          'id_usuario': id_usuario,
          'correo': email,
          'nombre_usuario': nombreUsuario,
          'contrasena': contrasena,
          'fecha_nac': fecNac,
          'programa': programa,
        },
      );

      // Imprimir la respuesta completa del servidor
      logger.i("Respuesta del servidor: ${response.body}");

      if (response.statusCode == 200) {
        try {
          final data = jsonDecode(response.body);
          if (data['success']) {
            logger.i("Usuario registrado con éxito: ${data['message']}");
          } else {
            logger.w("Error al registrar usuario: ${data['message']}");
          }
        } catch (e) {
          logger.e("La respuesta no es un JSON válido: ${response.body}");
        }
      } else {
        logger
            .e("Error de servidor: ${response.statusCode} - ${response.body}");
      }
    } catch (e) {
      logger.e("Error al registrar usuario", e);
    }
  }

// Método para iniciar sesión
  Future<String> loginUser(String correo, String contrasena) async {
    final String loginUrl =
        "$baseUrl/login.php"; // Ruta completa para el inicio de sesión

    try {
      final response = await http.post(
        Uri.parse(loginUrl),
        body: {
          'correo': correo,
          'contrasena': contrasena,
        },
      );

      // Imprimir la respuesta completa del servidor
      logger.i("Respuesta del servidor: ${response.body}");

      if (response.statusCode == 200) {
        try {
          final data = jsonDecode(response.body);
          if (data['success']) {
            logger.i("Inicio de sesión exitoso: ${data['message']}");
            return 'success'; // Inicio de sesión exitoso
          } else {
            logger.w("Error de inicio de sesión: ${data['message']}");
            return data['message']; // Mensaje específico del error
          }
        } catch (e) {
          logger.e("La respuesta no es un JSON válido: ${response.body}");
          return 'Error procesando la respuesta del servidor';
        }
      } else {
        logger
            .e("Error de servidor: ${response.statusCode} - ${response.body}");
        return 'Error de servidor: ${response.statusCode}';
      }
    } catch (e) {
      logger.e("Error al iniciar sesión: $e");
      return 'Error de conexión al servidor';
    }
  }

  Future<void> submitData({
    required File? profileImage,
    required File? coverImage,
    required String facebook,
    required String instagram,
  }) async {
    final uri = Uri.parse("$baseUrl/settings.php");
    var request = http.MultipartRequest('POST', uri);

    // Adjuntar la imagen de perfil si está disponible
    if (profileImage != null) {
      request.files.add(
          await http.MultipartFile.fromPath('profileImage', profileImage.path));
    }

    // Adjuntar la imagen de portada si está disponible
    if (coverImage != null) {
      request.files.add(
          await http.MultipartFile.fromPath('coverImage', coverImage.path));
    }

    // Añadir los campos de texto (Facebook e Instagram)
    request.fields['facebook'] = facebook;
    request.fields['instagram'] = instagram;

    // Enviar la solicitud
    var response = await request.send();

    // Verificar el estado de la respuesta
    if (response.statusCode == 200) {
      var responseData = await response.stream.bytesToString();
      var jsonResponse = json.decode(responseData);
      // Manejar la respuesta del servidor
      print(jsonResponse);
    } else {
      print('Error al enviar los datos: ${response.statusCode}');
    }
  }
}
