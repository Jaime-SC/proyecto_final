// home_page.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:proyecto_final/fire_functions.dart';
import '../models/evento_model.dart';
import '../widgets/widgets_ui.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final db = FirebaseFirestore.instance;
  late Stream<List<Evento>> _eventosStream;

  @override
  void initState() {
    super.initState();
    _eventosStream = _getEventosStream();
  }

  Stream<List<Evento>> _getEventosStream() {
    return FirebaseFirestore.instance
        .collection('eventos')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return Evento(
          id: doc.id,
          nombre: data['nombre'] ?? '',
          descripcion: data['descripcion'] ?? '',
          lugar: data['lugar'] ?? '',
          fecha: (data['fecha_hora'] as Timestamp?)?.toDate() ?? DateTime.now(),
          tipo: data['tipo'] ?? '',
          finalizado: data['finalizado'] ?? false, // Agrega 'finalizado'
        );
      }).toList();
    });
  }

 Future<void> _toggleEventoState(String eventoId, bool currentState) async {
    try {
      await db.collection('eventos').doc(eventoId).update({
        'finalizado': !currentState, // Cambia el estado opuesto al actual
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Estado del evento actualizado')),
      );
      // Añade la siguiente línea para actualizar la lista de eventos en HomePage
      _eventosStream = _getEventosStream(); // Reasigna el stream
    } catch (e) {
      print('Error al cambiar el estado del evento: $e');
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(15.0),
        decoration: const BoxDecoration(
          color: Color(0xffB8A4C9),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 35),
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStatePropertyAll(const Color(0xffF7FFF7)),
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
              child: StreamBuilder<List<Evento>>(
                stream: _eventosStream,
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return const Center(child: Text('Error al cargar eventos'));
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final eventos = snapshot.data ?? [];

                  return ListView.builder(
                    itemCount: eventos.length,
                    itemBuilder: (context, index) {
                      return CardEventoHome(
                        evento: eventos[index],                        
                        onToggleState: () => _toggleEventoState(
                            eventos[index].id, eventos[index].finalizado),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
