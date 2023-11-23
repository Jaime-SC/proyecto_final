import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import '../models/evento_model.dart';
import '../services/firebase_service.dart';
import '../widgets/widgets_ui.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final db = FirebaseFirestore.instance;
  late Stream<List<Evento>> _eventosStream;
  bool showFutureEvents =
      true; // Nuevo: Variable para alternar entre eventos futuros y pasados
  bool showUpcomingEventsOnly = false;

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
          like: data['like'] ?? 0,
          finalizado: data['finalizado'] ?? false,
        );
      }).toList();
    });
  }

  Future<void> _toggleEventoState(String eventoId, bool currentState) async {
    try {
      final eventoRef = db.collection('eventos').doc(eventoId);

      // Actualiza el contador de likes en la colección de eventos
      await eventoRef.update({
        'like':
            currentState ? FieldValue.increment(-1) : FieldValue.increment(1),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Me gusta actualizado')),
      );

      // Recarga la lista de eventos
      _eventosStream = _getEventosStream();
    } catch (e) {
      print('Error al cambiar el estado del evento: $e');
    }
  }

  List<Evento> filterEventos(
      bool showFutureEvents, bool showUpcomingEvents, List<Evento> eventos) {
    final now = DateTime.now();

    if (showUpcomingEvents) {
      return eventos
          .where((evento) =>
              !evento.finalizado &&
              evento.fecha.isBefore(now.add(const Duration(days: 3))))
          .toList();
    } else if (showFutureEvents) {
      return eventos.where((evento) => !evento.finalizado).toList();
    } else {
      return eventos.where((evento) => evento.finalizado).toList();
    }
  }

  List<Evento> getUpcomingEvents(List<Evento> eventos) {
    final now = DateTime.now();
    final upcomingEvents = eventos
        .where((evento) =>
            !evento.finalizado &&
            evento.fecha.isBefore(now.add(const Duration(days: 3))))
        .toList();
    return upcomingEvents;
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

            // Nuevo: Botón para alternar entre eventos futuros y pasados
            ElevatedButton(
              onPressed: () {
                setState(() {
                  showFutureEvents = !showFutureEvents;
                  showUpcomingEventsOnly =
                      false; // Restablecer el filtro de eventos próximos
                });
              },
              child: Text(showFutureEvents
                  ? 'Ver Eventos Pasados'
                  : 'Ver Eventos Futuros'),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  showUpcomingEventsOnly = !showUpcomingEventsOnly;
                });
              },
              child: Text('Ver Eventos Próximos'),
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
                final filteredEventos = filterEventos(
                    showFutureEvents, showUpcomingEventsOnly, eventos);

                return ListView.builder(
                  itemCount: filteredEventos.length,
                  itemBuilder: (context, index) {
                    return CardEventoHome(
                      evento: filteredEventos[index],
                      onToggleState: () => _toggleEventoState(
                          filteredEventos[index].id,
                          filteredEventos[index].finalizado),
                    );
                  },
                );
              },
            )),
          ],
        ),
      ),
    );
  }
}
