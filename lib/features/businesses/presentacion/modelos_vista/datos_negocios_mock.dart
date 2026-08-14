import 'negocio_vista.dart';

const List<NegocioVista> negociosMockVista = [
  NegocioVista(
    id: 'neg_001',
    nombre: 'Barberia Alpha',
    categoria: CategoriaNegocioVista.barberia,
    imagenUrl:
        'https://images.unsplash.com/photo-1622286342621-4bd786c2447c?auto=format&fit=crop&w=1200&q=60',
    ubicacion: 'Calle 10 #12-30',
    horarios: 'Lun - Sab 08:00 a 20:00',
    servicios: ['Corte clasico', 'Barba premium', 'Afeitado tradicional'],
    estilos: ['Fade', 'Low Fade', 'Taper', 'Buzz Cut'],
    calificacion: 4.8,
    totalCalificaciones: 215,
    barberos: [
      BarberoVista(
        nombre: 'Carlos Martinez',
        fotoUrl:
            'https://images.unsplash.com/photo-1585747860715-2ba37e788b70?auto=format&fit=crop&w=640&q=60',
        experiencia: '7 anos de experiencia',
        especialidades: ['Fade', 'Low Fade', 'Diseno de barba'],
        calificacion: 4.9,
      ),
      BarberoVista(
        nombre: 'Andres Mejia',
        fotoUrl:
            'https://images.unsplash.com/photo-1503235930437-8c6293ba41f5?auto=format&fit=crop&w=640&q=60',
        experiencia: '5 anos de experiencia',
        especialidades: ['Taper', 'Buzz Cut', 'Afeitado tradicional'],
        calificacion: 4.7,
      ),
    ],
  ),
  NegocioVista(
    id: 'neg_002',
    nombre: 'Barberia Black',
    categoria: CategoriaNegocioVista.barberia,
    imagenUrl:
        'https://images.unsplash.com/photo-1512690459411-b0fd1c86b8ec?auto=format&fit=crop&w=1200&q=60',
    ubicacion: 'Av. Central 45-20',
    horarios: 'Lun - Dom 10:00 a 22:00',
    servicios: ['Corte moderno', 'Diseno de barba'],
    estilos: ['Mid Fade', 'Pompadour', 'French Crop'],
    calificacion: 4.6,
    totalCalificaciones: 142,
    barberos: [
      BarberoVista(
        nombre: 'Miguel Torres',
        fotoUrl:
            'https://images.unsplash.com/photo-1595152772835-219674b2a8a6?auto=format&fit=crop&w=640&q=60',
        experiencia: '8 anos de experiencia',
        especialidades: ['Mid Fade', 'Pompadour'],
        calificacion: 4.8,
      ),
      BarberoVista(
        nombre: 'Jairo Lopez',
        fotoUrl:
            'https://images.unsplash.com/photo-1552058544-f2b08422138a?auto=format&fit=crop&w=640&q=60',
        experiencia: '4 anos de experiencia',
        especialidades: ['French Crop', 'Diseno de barba'],
        calificacion: 4.6,
      ),
    ],
  ),
  NegocioVista(
    id: 'neg_003',
    nombre: 'Barberia Classic',
    categoria: CategoriaNegocioVista.barberia,
    imagenUrl:
        'https://images.unsplash.com/photo-1503951458645-643d53bfd90f?auto=format&fit=crop&w=1200&q=60',
    ubicacion: 'Cra. 8 #22-14',
    horarios: 'Mar - Dom 09:00 a 19:00',
    servicios: ['Corte ejecutivo', 'Perfilado de barba'],
    estilos: ['Side Part', 'Slick Back', 'Undercut'],
    calificacion: 4.7,
    totalCalificaciones: 97,
    barberos: [
      BarberoVista(
        nombre: 'Sebastian Rojas',
        fotoUrl:
            'https://images.unsplash.com/photo-1546961329-78bef0414d7c?auto=format&fit=crop&w=640&q=60',
        experiencia: '6 anos de experiencia',
        especialidades: ['Side Part', 'Slick Back', 'Undercut'],
        calificacion: 4.7,
      ),
    ],
  ),
  NegocioVista(
    id: 'neg_004',
    nombre: 'Barberia X',
    categoria: CategoriaNegocioVista.barberia,
    imagenUrl:
        'https://images.unsplash.com/photo-1521590832167-7bcbfaa6381f?auto=format&fit=crop&w=1200&q=60',
    ubicacion: 'Calle 72 #30-11',
    horarios: 'Lun - Sab 07:00 a 21:00',
    servicios: ['Corte urbano', 'Lavado capilar'],
    estilos: ['Skin Fade', 'Mullet Fade', 'Crew Cut'],
    calificacion: 4.5,
    totalCalificaciones: 61,
    barberos: [
      BarberoVista(
        nombre: 'Juan Camilo Perez',
        fotoUrl:
            'https://images.unsplash.com/photo-1568602471122-7832951cc4c5?auto=format&fit=crop&w=640&q=60',
        experiencia: '5 anos de experiencia',
        especialidades: ['Skin Fade', 'Crew Cut'],
        calificacion: 4.5,
      ),
      BarberoVista(
        nombre: 'David Pineda',
        fotoUrl:
            'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?auto=format&fit=crop&w=640&q=60',
        experiencia: '3 anos de experiencia',
        especialidades: ['Mullet Fade', 'Lavado capilar'],
        calificacion: 4.4,
      ),
    ],
  ),
  NegocioVista(
    id: 'neg_005',
    nombre: 'Salon Aurora',
    categoria: CategoriaNegocioVista.salonBelleza,
    imagenUrl:
        'https://images.unsplash.com/photo-1522337360788-8b13dee7a37e?auto=format&fit=crop&w=1200&q=60',
    ubicacion: 'Calle 50 #19-07',
    horarios: 'Lun - Sab 09:00 a 19:00',
    servicios: ['Peinado', 'Colorimetria', 'Tratamiento capilar'],
    estilos: ['Bob', 'Balayage', 'Pixie'],
    calificacion: 4.9,
    totalCalificaciones: 188,
    barberos: [
      BarberoVista(
        nombre: 'Laura Castro',
        fotoUrl:
            'https://images.unsplash.com/photo-1488426862026-3ee34a7d66df?auto=format&fit=crop&w=640&q=60',
        experiencia: '9 anos de experiencia',
        especialidades: ['Balayage', 'Colorimetria'],
        calificacion: 4.9,
      ),
      BarberoVista(
        nombre: 'Paola Marin',
        fotoUrl:
            'https://images.unsplash.com/photo-1544005313-94ddf0286df2?auto=format&fit=crop&w=640&q=60',
        experiencia: '6 anos de experiencia',
        especialidades: ['Bob', 'Pixie'],
        calificacion: 4.8,
      ),
    ],
  ),
  NegocioVista(
    id: 'neg_006',
    nombre: 'Salon Esencia',
    categoria: CategoriaNegocioVista.salonBelleza,
    imagenUrl:
        'https://images.unsplash.com/photo-1487412720507-e7ab37603c6f?auto=format&fit=crop&w=1200&q=60',
    ubicacion: 'Av. Prado #99-21',
    horarios: 'Mar - Dom 10:00 a 20:00',
    servicios: ['Maquillaje', 'Alisado', 'Corte en capas'],
    estilos: ['Shag', 'Lob', 'Butterfly Cut'],
    calificacion: 4.7,
    totalCalificaciones: 112,
    barberos: [
      BarberoVista(
        nombre: 'Daniela Ruiz',
        fotoUrl:
            'https://images.unsplash.com/photo-1480455624313-e29b44bbfde1?auto=format&fit=crop&w=640&q=60',
        experiencia: '7 anos de experiencia',
        especialidades: ['Lob', 'Butterfly Cut', 'Maquillaje'],
        calificacion: 4.7,
      ),
    ],
  ),
];

NegocioVista? obtenerNegocioPorId(String id) {
  for (final negocio in negociosMockVista) {
    if (negocio.id == id) {
      return negocio;
    }
  }
  return null;
}
