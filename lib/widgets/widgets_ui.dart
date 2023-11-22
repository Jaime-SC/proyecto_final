import 'package:flutter/material.dart';
import '../models/evento_model.dart';

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
