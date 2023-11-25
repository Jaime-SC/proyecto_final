class Evento {
  final String id;
  final String nombre;
  final String descripcion;
  final String lugar;
  final DateTime fecha;
  final String tipo;
  final bool finalizado;
  late final int like;
  final Set<String> usuariosLiked; // Nuevo campo
  final String imageUrl;
  

  Evento({
    required this.id,
    required this.nombre,
    required this.descripcion,
    required this.lugar,
    required this.fecha,
    required this.tipo,
    this.finalizado = false,
    this.like = 0,
    required this.imageUrl,

    Set<String>? usuariosLiked, // Nuevo parámetro opcional
  }) : usuariosLiked = usuariosLiked ?? {}; // Inicializa el conjunto si es nulo
}
