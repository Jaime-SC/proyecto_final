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
  bool isUpdating = false;
  List<bool> isSelected = [true, false]; // Un valor para cada opción

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

  Future<void> _toggleEventoState(String eventoId, int currentLikeCount) async {
    if (isUpdating) {
      return;
    }

    try {
      setState(() {
        isUpdating = true;
      });

      final eventoRef = db.collection('eventos').doc(eventoId);
      final currentUserId = FirebaseService.getCurrentUserId();

      final eventoDoc = await eventoRef.get();
      final eventData = eventoDoc.data() as Map<String, dynamic>;

      final bool alreadyLiked =
          (eventData['likes'] as List<dynamic>?)?.contains(currentUserId) ??
              false;

      if (alreadyLiked) {
        await eventoRef.update({
          'like': FieldValue.increment(-1),
          'likes': FieldValue.arrayRemove([currentUserId]),
        });
      } else {
        await eventoRef.update({
          'like': FieldValue.increment(1),
          'likes': FieldValue.arrayUnion([currentUserId]),
        });
      }
    } catch (e) {
      print('Error al cambiar el estado del evento: $e');
    } finally {
      setState(() {
        isUpdating = false;
      });
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
      appBar: AppBar(
          backgroundColor: Color(0xffF71735),
          foregroundColor: Color(0xffFDFFFC),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Gestor de Eventos'),
              ElevatedButton(
                onPressed: () {
                  FirebaseService.signInWithGoogle(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xffFDFFFC),
                  elevation: 4, // Ajusta el valor según sea necesario
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Logo(Logos.google, size: 20),
                  ],
                ),
              ),
            ],
          )),
      body: Container(
        //padding: const EdgeInsets.all(15.0),
        decoration: const BoxDecoration(
          color: Color(0xff011627),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Nuevo: Botón para alternar entre eventos futuros y pasados

            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Color(0xff41EAD4),
                ),
                child: ToggleButtons(
                  onPressed: (int index) {
                    setState(() {
                      if (index == 0) {
                        showFutureEvents = false;
                        showUpcomingEventsOnly = false;
                      } else if (index == 1) {
                        showFutureEvents = true;
                        showUpcomingEventsOnly = false;
                      } else {
                        showFutureEvents = false;
                        showUpcomingEventsOnly = true;
                      }
                    });
                  },
                  isSelected: [
                    !showFutureEvents && !showUpcomingEventsOnly,
                    showFutureEvents,
                    showUpcomingEventsOnly
                  ],
                  borderRadius: BorderRadius.circular(10),
                  selectedBorderColor: Color(0xffFDFFFC),
                  selectedColor: Color(0xffFDFFFC),
                  fillColor: Color(0xffF71735),
                  color: Color(0xff011627),
                  borderColor: Color(0xffFDFFFC),
                  splashColor: Color(0xff9D061A),
                  children: const [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.0),
                      child: Row(
                        children: [
                          Icon(FontAwesome.clock_rotate_left),
                          SizedBox(width: 8.0),
                          Text('Pasados'),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.0),
                      child: Row(
                        children: [
                          Icon(FontAwesome.play),
                          SizedBox(width: 8.0),
                          Text('Activos'),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.0),
                      child: Row(
                        children: [
                          Icon(FontAwesome.calendar),
                          SizedBox(width: 8.0),
                          Text('Próximos'),
                        ],
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
                  final filteredEventos = filterEventos(
                      showFutureEvents, showUpcomingEventsOnly, eventos);

                  return ListView.builder(
                    itemCount: filteredEventos.length,
                    itemBuilder: (context, index) {
                      return CardEventoHome(
                        evento: filteredEventos[index],
                        onToggleState: () => _toggleEventoState(
                            filteredEventos[index].id,
                            filteredEventos[index].like),
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
