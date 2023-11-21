import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:proyecto_final/fire_functions.dart';
import '../widgets/widgets_ui.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late TextEditingController emailController, passwordController;

  // Lista de eventos de ejemplo
  List<Evento> eventos = [
    Evento('Evento 1', 'Descripción del Evento 1', DateTime.now().add(const Duration(days: 2))),
    Evento('Evento 2', 'Descripción del Evento 2', DateTime.now().subtract(const Duration(days: 1))),
    Evento('Evento 3', 'Descripción del Evento 1', DateTime.now().add(const Duration(days: 2))),
    // Puedes agregar más eventos según tus necesidades
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: const BoxDecoration(
          color: Color(0xff4ECDC4),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Mostrar la lista de eventos
            Padding(
              padding: const EdgeInsets.only(top: 35),
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStatePropertyAll(const Color(0xffF7FFF7)),
                ),
                onPressed: () {
                  FirebaseService.signInWithGoogle(context);
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Logo(Logos.google, size: 20),
                    const SizedBox(width: 8.0),
                    const Text(
                      'Iniciar Sesión con Google',
                      style: TextStyle(
                        color: Color(0xff292F36),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: eventos.length,
                itemBuilder: (context, index) {
                  return CardEvento(evento: eventos[index]);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Clase de modelo para representar un evento
class Evento {
  final String nombre;
  final String descripcion;
  final DateTime fecha;

  Evento(this.nombre, this.descripcion, this.fecha);
}
