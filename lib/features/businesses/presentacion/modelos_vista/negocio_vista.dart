enum CategoriaNegocioVista { barberia, salonBelleza }

class BarberoVista {
  const BarberoVista({
    required this.nombre,
    required this.fotoUrl,
    required this.experiencia,
    required this.especialidades,
    required this.calificacion,
  });

  final String nombre;
  final String fotoUrl;
  final String experiencia;
  final List<String> especialidades;
  final double calificacion;
}

class NegocioVista {
  const NegocioVista({
    required this.id,
    required this.nombre,
    required this.categoria,
    required this.imagenUrl,
    required this.ubicacion,
    required this.horarios,
    required this.servicios,
    required this.estilos,
    required this.calificacion,
    required this.totalCalificaciones,
    required this.barberos,
  });

  final String id;
  final String nombre;
  final CategoriaNegocioVista categoria;
  final String imagenUrl;
  final String ubicacion;
  final String horarios;
  final List<String> servicios;
  final List<String> estilos;
  final double calificacion;
  final int totalCalificaciones;
  final List<BarberoVista> barberos;
}
