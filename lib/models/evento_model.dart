class Evento {
  final String id;
  final String nombre;
  final String descripcion;
  final String lugar;
  final DateTime fecha;
  final String tipo;
  final bool finalizado;
  final int like;
  final List<String> likes; // Nuevo campo

  Evento({
    required this.id,
    required this.nombre,
    required this.descripcion,
    required this.lugar,
    required this.fecha,
    required this.tipo,
    this.finalizado = false,
    this.like = 0,
    this.likes = const [], // Valor predeterminado
  });
}
