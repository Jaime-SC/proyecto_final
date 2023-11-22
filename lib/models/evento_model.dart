// Archivo: evento_model.dart

class Evento {
  final String id;
  final String nombre;
  final String descripcion;
  final DateTime fecha;
  final String tipo;

  Evento({
    required this.id,
    required this.nombre,
    required this.descripcion,
    required this.fecha,
    required this.tipo,
  });
}
