import 'package:flutter/material.dart';
import 'package:proyecto_u/Login.dart';
import 'package:proyecto_u/home.dart';
import 'package:proyecto_u/register.dart';
import 'package:proyecto_u/user.dart';
import 'package:proyecto_u/calendar.dart';

void main() {
  runApp(const SocialApp());
}

class SocialApp extends StatelessWidget {
  const SocialApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const LoginScreen(),
      routes: {
        '/home': (context) => const HomeScreen(),
        '/register': (context) => const RegisterScreen(),
        '/users': (context) => const UsersScreen(),
        '/calendar': (context) => const CalendarScreen(),
      },
    );
  }
}
