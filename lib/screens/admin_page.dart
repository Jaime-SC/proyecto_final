import 'package:flutter/material.dart';
import 'package:proyecto_final/fire_functions.dart';
import 'home_page.dart';

class AdminPage extends StatefulWidget {
  const AdminPage({Key? key}) : super(key: key);

  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
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
              MaterialPageRoute(builder: (context) => const HomePage()),
            );
          },
          child: const Text('Cerrar Sesión'),
        ),
      ),
    );
  }
}
