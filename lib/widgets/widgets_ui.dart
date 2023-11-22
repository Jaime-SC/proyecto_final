// widgets_ui.dart

import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import '../models/evento_model.dart';

// Archivo: widgets_ui.dart

class CardEvento extends StatelessWidget {
  final Evento evento;

  const CardEvento({Key? key, required this.evento}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              evento.nombre,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18.0,
              ),
            ),
            const SizedBox(height: 8.0),
            Text(
              evento.descripcion,
              style: const TextStyle(fontSize: 16.0),
            ),
            const SizedBox(height: 8.0),
            Text(
              'Fecha del evento: ${evento.fecha}',
              style: const TextStyle(fontSize: 14.0),
            ),
            const SizedBox(height: 8.0),
            Row(
              children: [
                Text(
                  'Estado: ${evento.finalizado ? "Finalizado" : "En curso"}',
                  style: TextStyle(
                    color: evento.finalizado ? Colors.red : Colors.green,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                ElevatedButton(
                  onPressed: () {
                    // Funcionalidad para indicar que me gusta un evento
                    // Puedes implementar esta función según tus necesidades
                    // Ejemplo: FirebaseService.indicarMeGusta(evento);
                  },
                  child: const Text('Me gusta'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class TextFieldLogin extends StatelessWidget {
  final String labelText;
  final TextInputType keyboardType;
  final bool isPassword;

  const TextFieldLogin({
    Key? key,
    required this.labelText,
    required this.keyboardType,
    this.isPassword = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      obscureText: isPassword,
      decoration: InputDecoration(
        labelText: labelText,
        filled: true,
        fillColor: const Color(0x75292F36),
        labelStyle: const TextStyle(
          color: Colors.white,
        ), // Cambia el color del texto del label
        hintStyle: const TextStyle(
          color: Colors.white,
        ), // Cambia el color del texto de hint (cuando no hay texto)
      ),
      keyboardType: keyboardType,
      style: const TextStyle(
        color: Colors.white,
      ), // Cambia el color del texto del input
    );
  }
}

// widgets_ui.dart
class CardEventoAdmin extends StatelessWidget {
  final Evento evento;
  final VoidCallback onDelete;
  final VoidCallback onToggleState; // Add this line

  const CardEventoAdmin({
    Key? key,
    required this.evento,
    required this.onDelete,
    required this.onToggleState, // Add this line
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              evento.nombre,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18.0,
              ),
            ),
            const SizedBox(height: 8.0),
            Text(
              evento.descripcion,
              style: const TextStyle(fontSize: 16.0),
            ),
            const SizedBox(height: 8.0),
            Text(
              'Fecha del evento: ${evento.fecha}',
              style: const TextStyle(fontSize: 14.0),
            ),
            const SizedBox(height: 8.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () {
                    // Funcionalidad para indicar que me gusta un evento
                    // Puedes implementar esta función según tus necesidades
                    // Ejemplo: FirebaseService.indicarMeGusta(evento);
                  },
                  child: const Icon(HeroIcons.heart),
                ),
                ElevatedButton(
                  onPressed: onDelete,
                  child: const Icon(HeroIcons.trash),
                ),
              ],
            ),
            const SizedBox(height: 8.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Estado: ${evento.finalizado ? "Finalizado" : "En curso"}',
                  style: TextStyle(
                    color: evento.finalizado ? Colors.red : Colors.green,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                ElevatedButton(
                  onPressed: onToggleState, // Use onToggleState here
                  child: const Icon(HeroIcons.arrow_path),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class CardEventoHome extends StatelessWidget {
  final Evento evento;
  final VoidCallback onToggleState; // Add this line

  const CardEventoHome({
    Key? key,
    required this.evento,
    required this.onToggleState, // Add this line
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      backgroundColor: Color(0xffC9DEF4),     
      collapsedBackgroundColor: Color(0xffF5CCD4),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      
      
      
      

      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                evento.nombre,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18.0,
                ),
              ),
              Text(
                'Estado: ${evento.finalizado ? "Finalizado" : "En curso"}',
                style: TextStyle(
                  color: evento.finalizado ? Colors.red : Colors.green,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          ElevatedButton(
            onPressed: () {
              // Funcionalidad para indicar que me gusta un evento
              // Puedes implementar esta función según tus necesidades
              // Ejemplo: FirebaseService.indicarMeGusta(evento);
            },
            child: const Icon(HeroIcons.heart),
          ),
        ],
      ),
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Descripción: ${evento.descripcion}',
                style: const TextStyle(fontSize: 16.0),
              ),
              const SizedBox(height: 8.0),
              Text(
                'Fecha del evento: ${evento.fecha}',
                style: const TextStyle(fontSize: 14.0),
              ),
              const SizedBox(height: 8.0),
              Text(
                'Lugar: ${evento.lugar}',
                style: const TextStyle(fontSize: 14.0),
              ),
              const SizedBox(height: 8.0),
              Text(
                'Tipo: ${evento.tipo}',
                style: const TextStyle(fontSize: 14.0),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

