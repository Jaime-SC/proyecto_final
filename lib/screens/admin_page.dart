import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:datetime_picker_formfield_new/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import '../models/evento_model.dart';
import '../services/firebase_service.dart';
import '../widgets/widgets_ui.dart';
import 'home_page.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class AdminPage extends StatefulWidget {
  const AdminPage({Key? key}) : super(key: key);

  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  final db = FirebaseFirestore.instance;
  final _formKey = GlobalKey<FormState>();
  final _picker = ImagePicker();

  String _imageUrl = ''; // Nuevo campo

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

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final imageFile = File(pickedFile.path);

      // Subir la imagen a Firebase Storage
      final storageRef = firebase_storage.FirebaseStorage.instance
          .ref()
          .child('event_images')
          .child('${DateTime.now().millisecondsSinceEpoch}.jpg');
      await storageRef.putFile(imageFile);

      // Obtener la URL de la imagen
      final imageUrl = await storageRef.getDownloadURL();

      setState(() {
        _imageUrl = imageUrl;
      });
    }
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

  Future<void> _editEvento(Evento evento) async {
    // Muestra un cuadro de diálogo para editar la información del evento
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return _buildEditEventDialog(evento);
      },
    );
  }

  Future<void> _deleteEvento(String eventoId) async {
    bool confirmDelete = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmar eliminación'),
          content:
              const Text('¿Estás seguro de que quieres eliminar este evento?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true); // Confirma la eliminación
              },
              child: const Text('Sí'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false); // Cancela la eliminación
              },
              child: const Text('No'),
            ),
          ],
        );
      },
    );

    if (confirmDelete) {
      try {
        await db.collection('eventos').doc(eventoId).delete();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Evento eliminado con éxito')),
        );
      } catch (e) {
        print('Error al eliminar el evento: $e');
      }
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
          like: data['like'] ?? 0,
          finalizado: data['finalizado'] ?? false,
          imageUrl: data['imageUrl'] ?? '', // Asegúrate de agregar esto
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
        'finalizado': false,
        'imageUrl': _imageUrl, // Asegúrate de agregar esto
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

  Widget _buildEditEventDialog(Evento evento) {
    final TextEditingController nombreController = TextEditingController();
    final TextEditingController descripcionController = TextEditingController();
    final TextEditingController lugarController = TextEditingController();
    final TextEditingController fechaController = TextEditingController();
    final TextEditingController tipoController = TextEditingController();
    final TextEditingController imageUrlController = TextEditingController();

    // Llena los controladores con la información actual del evento
    nombreController.text = evento.nombre;
    descripcionController.text = evento.descripcion;
    lugarController.text = evento.lugar;
    fechaController.text = DateFormat('yyyy-MM-dd HH:mm').format(evento.fecha);
    tipoController.text = evento.tipo;
    imageUrlController.text = evento.imageUrl; // Agrega esta línea

    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: nombreController,
                decoration:
                    const InputDecoration(labelText: 'Nombre del evento'),
                keyboardType: TextInputType.text,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, ingrese un nombre';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 8.0),
              TextFormField(
                controller: descripcionController,
                decoration: const InputDecoration(labelText: 'Descripción'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, ingrese una descripción';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 8.0),
              TextFormField(
                controller: lugarController,
                decoration: const InputDecoration(labelText: 'Lugar'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, ingrese un lugar';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 8.0),
              DateTimeField(
                controller: fechaController,
                decoration: const InputDecoration(labelText: 'Fecha y hora'),
                format: DateFormat('yyyy-MM-dd HH:mm'),
                onShowPicker: (context, currentValue) async {
                  return await showDatePicker(
                    context: context,
                    firstDate: DateTime.now(),
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
              const SizedBox(height: 8.0),
              DropdownButtonFormField<String>(
                value: tipoController.text,
                items: _eventTypes.toSet().toList().map((tipo) {
                  return DropdownMenuItem<String>(
                    value: tipo,
                    child: Text(tipo),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    tipoController.text = value!;
                  });
                },
                decoration: const InputDecoration(labelText: 'Tipo de evento'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, seleccione un tipo de evento';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () async {
                  // Lógica para seleccionar una nueva imagen y actualizar la URL
                  await _pickImage();
                },
                child: const Text('Seleccionar Imagen'),
              ),
              const SizedBox(height: 16.0),
              Image.network(evento.imageUrl),
              // Mostrar la imagen seleccionada

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
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        // Realiza la lógica para actualizar la información en Firestore
                        await db.collection('eventos').doc(evento.id).update({
                          'nombre': nombreController.text,
                          'descripcion': descripcionController.text,
                          'lugar': lugarController.text,
                          'fecha_hora': DateTime.parse(fechaController.text),
                          'tipo': tipoController.text,
                          'imageUrl':
                              _imageUrl, // Actualiza la URL de la imagen
                        });

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Evento actualizado con éxito')),
                        );

                        // Cierra el cuadro de diálogo después de la edición
                        Navigator.pop(context);
                      }
                    },
                    child: const Text('Guardar Cambios'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xffF71735),
        foregroundColor: Color(0xffFDFFFC),
        leading: GestureDetector(
          onTap: () {
            // Utiliza Navigator.pushReplacement para reemplazar la página actual
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => HomePage()),
            );
          },
          child: const Padding(
            padding: EdgeInsets.all(8.0),
            child: Icon(FontAwesome.house),
          ),
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Admin Page'),
            GestureDetector(
              onTap: _signOut,
              child: const Padding(
                padding: EdgeInsets.all(8.0),
                child: Icon(FontAwesome.arrow_right_from_bracket),
              ),
            ),
          ],
        ),
      ),
      body: Container(
        color: Color(0xff011627),
        child: Padding(
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
                    onEdit: () =>
                        _editEvento(eventos[index]), // Agrega esta línea
                  );
                },
              );
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0xffF71735),
        foregroundColor: Color(0xffFDFFFC),
        elevation: 8,
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
      backgroundColor: Color(0xffB6F7EE),
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
                    firstDate: DateTime.now(),
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
              ElevatedButton(
                onPressed: () async {
                  // Lógica para seleccionar una nueva imagen y actualizar la URL
                  await _pickImage();
                },
                child: const Text('Seleccionar Imagen'),
              ),
              // const SizedBox(height: 16.0),
              // Image.network(_imageUrl), // Mostrar la imagen seleccionada
              // const SizedBox(height: 16.0),
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
