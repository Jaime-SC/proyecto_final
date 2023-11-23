import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import '../models/evento_model.dart';

class CardEventoAdmin extends StatelessWidget {
  final Evento evento;
  final VoidCallback onDelete;
  final VoidCallback onToggleState;
  final VoidCallback onEdit; // Agrega esta línea

  const CardEventoAdmin({
    Key? key,
    required this.evento,
    required this.onDelete,
    required this.onToggleState,
    required this.onEdit, // Agrega esta línea
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
            Row(
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
                  onPressed: onToggleState,
                  child: const Icon(HeroIcons.arrow_path),
                ),
              ],
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
            Text(
              'Lugar: ${evento.lugar}',
              style: const TextStyle(fontSize: 14.0),
            ),
            const SizedBox(height: 8.0),
            Text(
              'Tipo: ${evento.tipo}',
              style: const TextStyle(fontSize: 14.0),
            ),
            const SizedBox(height: 8.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: onDelete,
                  child: const Icon(HeroIcons.trash),
                ),
                const SizedBox(height: 8.0),
                ElevatedButton(
                  onPressed: onEdit, // Usa onEdit aquí
                  child: const Icon(HeroIcons.pencil),
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
              onToggleState();
            },
            child: Row(
              
              children: [
                const Icon(HeroIcons.heart),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: Text(
                    '${evento.like}',
                    style: const TextStyle(fontSize: 14.0),
                  ),
                ),
              ],
            ),
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
              Text(
                'like: ${evento.like}',
                style: const TextStyle(fontSize: 14.0),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
