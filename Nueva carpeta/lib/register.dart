import 'package:flutter/material.dart';
import 'package:ubook/services/auth_service.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  // Controladores para los campos de texto
  final TextEditingController _identyController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  DateTime? _selectedDate;
  String? _selectedProgram;

  final AuthService _authService = AuthService();

  final List<String> programs = [
    'Ingeniería de Sistemas',
    'Ingeniería Civil',
    'Ingeniería Agroindustrial',
    'Ingeniería Agroforestal',
    'Derecho',
    'Medicina Veterinaria y Zootecnia',
    'Contaduría Pública'
  ];

  // Función para validar que el correo sea de un dominio permitido
  bool _isValidEmail(String email) {
    return email.endsWith('@gmail.com') || email.endsWith('@unitropico.edu.co');
  }

  void _pickDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1930),
      lastDate: DateTime.now(),
    );
    if (pickedDate != null) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  Future<void> _registerUser() async {
    // Validar que los campos requeridos no sean nulos
    if (_identyController.text.isNotEmpty &&
        _usernameController.text.isNotEmpty &&
        _emailController.text.isNotEmpty &&
        _passwordController.text.isNotEmpty &&
        _selectedDate != null &&
        _selectedProgram != null) {
      // Validar el correo electrónico
      if (!_isValidEmail(_emailController.text)) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content:
                  Text('El correo debe ser @gmail.com o @unitropico.edu.co')),
        );
        return; // Detener el registro si el correo no es válido
      }

      // Verificar si el correo ya está registrado
      bool emailExists =
          await _authService.checkEmailExists(_emailController.text);

      if (emailExists) {
        // Mostrar mensaje si el correo ya está registrado
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('El correo ya está registrado. Usa otro.')),
        );
        return; // Detener el registro
      }

      // Convertir la fecha a una cadena (por ejemplo, 'YYYY-MM-DD')
      String formattedDate =
          "${_selectedDate!.year}-${_selectedDate!.month}-${_selectedDate!.day}";

      // Llamar a la función de registro con valores no nulos
      await _authService.registerUser(
        _identyController.text,
        _usernameController.text,
        _emailController.text,
        _passwordController.text,
        formattedDate, // Aquí pasas la fecha como cadena
        _selectedProgram!, // Asegurar que no sea nulo con '!'
      );

      // Mostrar mensaje de éxito
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Registrado con éxito')),
      );
      Navigator.pushNamed(context, '/login');
    } else {
      // Mostrar un mensaje de error si faltan campos
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor completa todos los campos')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Registro'),
        backgroundColor: const Color(0xFF004D40), // Verde oscuro
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Campo de identificación
                TextField(
                  controller: _identyController,
                  decoration: InputDecoration(
                    labelText: 'Identificación',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    hintText: 'Número de identificación',
                  ),
                ),
                const SizedBox(height: 20),

                // Campo de nombre de usuario
                TextField(
                  controller: _usernameController,
                  decoration: InputDecoration(
                    labelText: 'Nombre de usuario',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Campo de correo
                TextField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: 'Correo',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    hintText: 'ejemplo@unitropico.edu.co',
                  ),
                ),
                const SizedBox(height: 20),

                // Campo de contraseña
                TextField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Contraseña',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Selector de fecha de nacimiento
                ListTile(
                  title: Text(
                    _selectedDate == null
                        ? 'Fecha de Nacimiento'
                        : 'Fecha de Nacimiento: ${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}',
                  ),
                  trailing: const Icon(Icons.calendar_today),
                  onTap: _pickDate,
                ),

                // Selector de programa
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    labelText: 'Programa',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  value: _selectedProgram,
                  items: programs.map((program) {
                    return DropdownMenuItem(
                      value: program,
                      child: Text(program),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedProgram = value;
                    });
                  },
                ),
                const SizedBox(height: 20),

                // Botón de registro
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _registerUser,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF004D40), // Verde oscuro
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    child: const Text('Registrarse'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
