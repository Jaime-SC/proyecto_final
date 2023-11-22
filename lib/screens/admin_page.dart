import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:datetime_picker_formfield_new/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../fire_functions.dart';
import '../models/evento_model.dart';
import '../widgets/widgets_ui.dart';
import 'home_page.dart';

class AdminPage extends StatefulWidget {
  const AdminPage({Key? key}) : super(key: key);

  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  final db = FirebaseFirestore.instance;
  final _formKey = GlobalKey<FormState>();
  String _eventName = '';
  DateTime _eventDateTime = DateTime.now();
  
  String _eventDescription = '';
  String _eventLugar = '';
  String _eventType = '';
  int _eventLikes = 0;
  List<String> _eventTypes = [];
  late Stream<List<Evento>> _eventosStream;

  @override
  void initState() {
    super.initState();
    _loadEventTypes();
    _eventosStream = _getEventosStream();
  }

  Future<void> _loadEventTypes() async {
    try {
      var querySnapshot = await db.collection('tipo').get();
      var types =
          querySnapshot.docs.map((doc) => doc['nombre'].toString()).toList();
      setState(() {
        _eventTypes = types;
      });
    } catch (e) {
      print('Error al cargar tipos de eventos: $e');
    }
  }

  Future<void> _deleteEvento(String eventoId) async {
    try {
      await db.collection('eventos').doc(eventoId).delete();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Evento eliminado con éxito')),
      );
    } catch (e) {
      print('Error al eliminar el evento: $e');
    }
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

  Stream<List<Evento>> _getEventosStream() {
    return db.collection('eventos').snapshots().map((snapshot) {
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

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      await db.collection('eventos').add({
        'nombre': _eventName,
        'fecha_hora': _eventDateTime,
        
        'descripcion': _eventDescription,
        'lugar': _eventLugar,
        'tipo': _eventType,
        'like': _eventLikes,
        'finalizado': false, // Set the default value to false
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Evento creado con éxito')),
      );
      setState(() {
        _eventName = '';
        _eventDateTime = DateTime.now();
        
        _eventDescription = '';
        _eventLugar = '';
        _eventType = '';
        _eventLikes = 0;
      });
      Navigator.pop(context);
    }
  }

  Future<void> _signOut() async {
    await FirebaseService.signOutFromGoogle();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const HomePage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Admin Page'),
            ElevatedButton(
              onPressed: _signOut,
              child: const Text('Cerrar Sesión'),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
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
                return CardEventoAdmin(
                  evento: eventos[index],
                  onDelete: () => _deleteEvento(eventos[index].id),
                  onToggleState: () => _toggleEventoState(
                      eventos[index].id, eventos[index].finalizado),
                );
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return _buildAddEventDialog();
            },
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildAddEventDialog() {
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                decoration:
                    const InputDecoration(labelText: 'Nombre del evento'),
                onChanged: (value) => _eventName = value,
                keyboardType: TextInputType.text,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, ingrese un nombre';
                  }
                  return null;
                },
              ),
              DateTimeField(
                decoration: const InputDecoration(labelText: 'Fecha y hora'),
                format: DateFormat('yyyy-MM-dd HH:mm'),
                onShowPicker: (context, currentValue) async {
                  return await showDatePicker(
                    context: context,
                    firstDate: DateTime(2000),
                    initialDate: currentValue ?? DateTime.now(),
                    lastDate: DateTime(2100),
                  ).then((selectedDate) async {
                    if (selectedDate != null) {
                      return await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.fromDateTime(
                            currentValue ?? DateTime.now()),
                      ).then((selectedTime) {
                        if (selectedTime != null) {
                          return DateTimeField.combine(
                            selectedDate,
                            selectedTime,
                          );
                        } else {
                          return currentValue;
                        }
                      });
                    } else {
                      return currentValue;
                    }
                  });
                },
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _eventDateTime = value;
                    });
                  }
                },
                validator: (value) {
                  if (value == null) {
                    return 'Por favor, ingrese una fecha y hora';
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Lugar'),
                onChanged: (value) => _eventLugar = value,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, ingrese un lugar';
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Descripción'),
                onChanged: (value) => _eventDescription = value,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, ingrese una descripción';
                  }
                  return null;
                },
              ),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: 'Tipo de evento'),
                onChanged: (value) => _eventType = value!,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, seleccione un tipo de evento';
                  }
                  return null;
                },
                items:
                    _eventTypes.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
              const SizedBox(height: 16.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('Cancelar'),
                  ),
                  ElevatedButton(
                    onPressed: _submitForm,
                    child: const Text('Agregar Evento'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
