import 'package:flutter/material.dart';
import 'package:proyecto_final/fire_functions.dart';

import 'login_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('HOME PAGE')),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // Llama al método de cierre de sesión en tu servicio de Firebase
            FirebaseService().signOutFromGoogle();
            // Navega de nuevo a la página de inicio de sesión después de cerrar sesión
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const LoginPage()),
            );
          },
          child: const Text('Cerrar Sesión'),
        ),
      ),
    );
  }
}
