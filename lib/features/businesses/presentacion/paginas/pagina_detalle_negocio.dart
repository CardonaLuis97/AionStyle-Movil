import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/router/enrutador.dart';
import '../../../../app/theme/colores.dart';
import '../../../../app/widgets/logo_aionstyle.dart';
import '../modelos_vista/datos_negocios_mock.dart';
import '../modelos_vista/negocio_vista.dart';

class PaginaDetalleNegocio extends StatelessWidget {
  const PaginaDetalleNegocio({
    super.key,
    required this.negocioId,
  });

  final String negocioId;

  @override
  Widget build(BuildContext context) {
    final negocio = obtenerNegocioPorId(negocioId);
    if (negocio == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Detalle del negocio')),
        body: Center(
          child: Text(
            'No se encontro el negocio.',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
      );
    }

    final tema = Theme.of(context);
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            backgroundColor: ColoresApp.primario,
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    negocio.imagenUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) {
                      return Container(
                        color: ColoresApp.fondo,
                        alignment: Alignment.center,
                        child: const Icon(
                          Icons.image_not_supported_outlined,
                          color: ColoresApp.terceario,
                          size: 36,
                        ),
                      );
                    },
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          ColoresApp.primario.withValues(alpha: 0.05),
                          ColoresApp.primario.withValues(alpha: 0.82),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    left: 16,
                    right: 16,
                    bottom: 24,
                    child: _BloqueHeroNegocio(negocio: negocio),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Barberos disponibles',
                    style: tema.textTheme.titleSmall?.copyWith(
                      color: ColoresApp.primario,
                      fontWeight: FontWeight.w700,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 10),
                  ...negocio.barberos.map(
                    (barbero) => _TarjetaBarberoDetalle(
                      negocio: negocio,
                      barbero: barbero,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BloqueHeroNegocio extends StatelessWidget {
  const _BloqueHeroNegocio({required this.negocio});

  final NegocioVista negocio;

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _LogoEmpresa(),
        const SizedBox(height: 8),
        Text(
          negocio.nombre,
          style: tema.textTheme.titleLarge?.copyWith(
            color: ColoresApp.secundario,
            fontWeight: FontWeight.w800,
            fontSize: 24,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 6,
          children: [
            _TagInfo(icono: Icons.location_on_outlined, texto: negocio.ubicacion),
            _TagInfo(icono: Icons.schedule_outlined, texto: negocio.horarios),
            _TagInfo(
              icono: Icons.star_rounded,
              texto: '${negocio.calificacion.toStringAsFixed(1)} (${negocio.totalCalificaciones})',
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          'Servicios: ${negocio.servicios.join(', ')}',
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: tema.textTheme.bodySmall?.copyWith(
            color: ColoresApp.secundario.withValues(alpha: 0.95),
            fontSize: 11,
          ),
        ),
      ],
    );
  }
}

class _TarjetaBarberoDetalle extends StatelessWidget {
  const _TarjetaBarberoDetalle({
    required this.negocio,
    required this.barbero,
  });

  final NegocioVista negocio;
  final BarberoVista barbero;

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: ColoresApp.secundario,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: ColoresApp.terceario.withValues(alpha: 0.2)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.network(
              barbero.fotoUrl,
              width: 96,
              height: 120,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) {
                return Container(
                  width: 96,
                  height: 120,
                  color: ColoresApp.fondo,
                  alignment: Alignment.center,
                  child: const Icon(Icons.person, color: ColoresApp.terceario),
                );
              },
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  barbero.nombre,
                  style: tema.textTheme.labelLarge?.copyWith(
                    color: ColoresApp.primario,
                    fontWeight: FontWeight.w700,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  barbero.experiencia,
                  style: tema.textTheme.bodySmall?.copyWith(
                    color: ColoresApp.textoClaro,
                    fontSize: 10,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  barbero.especialidades.join(' • '),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: tema.textTheme.bodySmall?.copyWith(
                    color: ColoresApp.texto,
                    fontSize: 10,
                  ),
                ),
                const SizedBox(height: 6),
                _EstrellasCalificacion(calificacion: barbero.calificacion),
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      context.push(
                        '${Rutas.agendarCita}?negocio=${Uri.encodeComponent(negocio.nombre)}&barbero=${Uri.encodeComponent(barbero.nombre)}&especialidades=${Uri.encodeComponent(barbero.especialidades.join('|'))}',
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ColoresApp.primario,
                      foregroundColor: ColoresApp.secundario,
                      minimumSize: const Size.fromHeight(34),
                    ),
                    child: const Text('Agendar cita'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _EstrellasCalificacion extends StatelessWidget {
  const _EstrellasCalificacion({required this.calificacion});

  final double calificacion;

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    final completas = calificacion.floor();
    final media = (calificacion - completas) >= 0.5;
    return Row(
      children: [
        for (var i = 0; i < 5; i++)
          Icon(
            i < completas
                ? Icons.star_rounded
                : (i == completas && media)
                    ? Icons.star_half_rounded
                    : Icons.star_border_rounded,
            color: ColoresApp.acento,
            size: 14,
          ),
        const SizedBox(width: 4),
        Text(
          calificacion.toStringAsFixed(1),
          style: tema.textTheme.bodySmall?.copyWith(
            color: ColoresApp.textoClaro,
            fontSize: 10,
          ),
        ),
      ],
    );
  }
}

class _TagInfo extends StatelessWidget {
  const _TagInfo({required this.icono, required this.texto});

  final IconData icono;
  final String texto;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      decoration: BoxDecoration(
        color: ColoresApp.secundario.withValues(alpha: 0.16),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: ColoresApp.secundario.withValues(alpha: 0.24)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icono, size: 12, color: ColoresApp.secundario),
          const SizedBox(width: 4),
          Text(
            texto,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: ColoresApp.secundario,
                  fontSize: 10,
                ),
          ),
        ],
      ),
    );
  }
}

class _LogoEmpresa extends StatelessWidget {
  const _LogoEmpresa();

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      width: 86,
      height: 32,
      child: LogoAionStyle(
        ajuste: BoxFit.cover,
        borde: BorderRadius.all(Radius.circular(10)),
      ),
    );
  }
}
