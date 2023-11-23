// Archivo: evento_model.dart

class Evento {
  final String id;
  final String nombre;
  final String descripcion;
  final DateTime fecha;
  final String tipo;
  final String imagenURL;


  Evento({
    required this.id,
    required this.nombre,
    required this.descripcion,
    required this.fecha,
    required this.tipo,
    required this.imagenURL,

  });
}

