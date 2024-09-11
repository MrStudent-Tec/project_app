import 'package:flutter/material.dart';
import 'package:ubook/services/auth_service.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _idController = TextEditingController();
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
                TextField(
                  controller: _idController,
                  decoration: InputDecoration(
                    labelText: 'Identificación',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    hintText: 'Número de identificación',
                  ),
                ),
                const SizedBox(height: 20),
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
                ListTile(
                  title: Text(
                    _selectedDate == null
                        ? 'Fecha de Nacimiento'
                        : 'Fecha de Nacimiento: ${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}',
                  ),
                  trailing: Icon(Icons.calendar_today),
                  onTap: _pickDate,
                ),
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
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      // Validar que los campos requeridos no sean nulos
                      if (_selectedDate != null && _selectedProgram != null) {
                        // Convertir la fecha a una cadena (por ejemplo, 'YYYY-MM-DD')
                        String formattedDate =
                            "${_selectedDate!.year}-${_selectedDate!.month}-${_selectedDate!.day}";

                        // Llamar a la función de registro con valores no nulos
                        await _authService.registerUser(
                          _idController.text,
                          _usernameController.text,
                          _emailController.text,
                          _passwordController.text,
                          formattedDate, // Aquí pasas la fecha como cadena
                          _selectedProgram!, // Asegurar que no sea nulo con '!'
                        );

                        // Mostrar mensaje de éxito o error
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Registrado con éxito')),
                        );
                      } else {
                        // Mostrar un mensaje de error si faltan campos
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content:
                                  Text('Por favor completa todos los campos')),
                        );
                      }
                    },
                    child: const Text('Registrarse'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF004D40), // Verde oscuro
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
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
