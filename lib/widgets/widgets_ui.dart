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
  final VoidCallback onToggleState;

  const CardEventoHome({
    Key? key,
    required this.evento,
    required this.onToggleState,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Material(
        elevation: 4, // Agrega elevación para la sombra
        borderRadius: BorderRadius.circular(10.0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: ExpansionTile(
            backgroundColor: Color(0xffFDFFFC),
            collapsedBackgroundColor: Color(0xffB6F7EE),
            shape: InputBorder.none,
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
                      'Estado: ${evento.finalizado ? "Finalizado" : "Activo"}',
                      style: TextStyle(
                        color: evento.finalizado
                            ? Color(0xffFF0000)
                            : Color(0xff00CC00),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                ElevatedButton(
                  onPressed: () {
                    onToggleState();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xffF71735),
                    elevation: 4, // Ajusta el valor según sea necesario
                  ),
                  child: Row(
                    children: [
                      const Icon(BoxIcons.bxs_heart, color: Color(0xffFDFFFC)),
                      SizedBox(width: 8.0),
                      Text(
                        '${evento.like}',
                        style: const TextStyle(fontSize: 14.0, color: Color(0xffFDFFFC)),
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
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
