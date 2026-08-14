import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/router/enrutador.dart';
import '../../../../app/theme/colores.dart';
import '../modelos_vista/datos_negocios_mock.dart';
import '../modelos_vista/negocio_vista.dart';

class VistaNegocios extends StatefulWidget {
  const VistaNegocios({
    super.key,
    required this.titulo,
    this.mostrarEncabezado = true,
  });

  final String titulo;
  final bool mostrarEncabezado;

  @override
  State<VistaNegocios> createState() => _VistaNegociosState();
}

class _VistaNegociosState extends State<VistaNegocios> {
  final TextEditingController _busquedaCtrl = TextEditingController();
  CategoriaNegocioVista _categoriaActiva = CategoriaNegocioVista.barberia;

  @override
  void dispose() {
    _busquedaCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    final negociosCategoria = negociosMockVista
        .where((negocio) => negocio.categoria == _categoriaActiva)
        .toList();

    final busqueda = _busquedaCtrl.text.trim().toLowerCase();
    final resultadosNegocios = busqueda.isEmpty
        ? negociosCategoria
        : negociosCategoria.where((negocio) {
            final coincideNegocio =
                negocio.nombre.toLowerCase().contains(busqueda);
            final coincideBarbero = negocio.barberos.any(
              (barbero) =>
                  barbero.nombre.toLowerCase().contains(busqueda) ||
                  barbero.especialidades
                      .any((estilo) => estilo.toLowerCase().contains(busqueda)),
            );
            final coincideEstilo = negocio.estilos.any(
              (estilo) => estilo.toLowerCase().contains(busqueda),
            );
            return coincideNegocio || coincideBarbero || coincideEstilo;
          }).toList();

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          if (widget.mostrarEncabezado) ...[
            Text(
              widget.titulo,
              style: tema.textTheme.titleMedium?.copyWith(
                color: ColoresApp.primario,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Explora y busca por negocio, barbero o estilo.',
              style: tema.textTheme.bodySmall?.copyWith(
                color: ColoresApp.textoClaro,
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 14),
          ],
          _buildSelectorCategoria(tema),
          const SizedBox(height: 12),
          _buildBuscador(tema),
          const SizedBox(height: 20),
          Text(
            _categoriaActiva == CategoriaNegocioVista.barberia
                ? 'Barberias'
                : 'Salones de belleza',
            style: tema.textTheme.titleSmall?.copyWith(
              color: ColoresApp.primario,
              fontWeight: FontWeight.w700,
              fontSize: 15,
            ),
          ),
          const SizedBox(height: 10),
          if (resultadosNegocios.isEmpty)
            _buildSinResultados(tema, 'No se encontraron negocios para esta busqueda.')
          else
            ...resultadosNegocios.map(
              (negocio) => _TarjetaNegocio(
                negocio: negocio,
                onTap: () {
                  context.push('${Rutas.negocios}/${negocio.id}');
                },
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildSelectorCategoria(ThemeData tema) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: ColoresApp.secundario,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: ColoresApp.terceario.withValues(alpha: 0.25),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(6),
        child: Row(
          children: [
            Expanded(
              child: _BotonCategoria(
                etiqueta: 'Barberia',
                activa: _categoriaActiva == CategoriaNegocioVista.barberia,
                onTap: () {
                  setState(() {
                    _categoriaActiva = CategoriaNegocioVista.barberia;
                    _busquedaCtrl.clear();
                  });
                },
              ),
            ),
            const SizedBox(width: 6),
            Expanded(
              child: _BotonCategoria(
                etiqueta: 'Salon de belleza',
                activa: _categoriaActiva == CategoriaNegocioVista.salonBelleza,
                onTap: () {
                  setState(() {
                    _categoriaActiva = CategoriaNegocioVista.salonBelleza;
                    _busquedaCtrl.clear();
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBuscador(ThemeData tema) {
    return TextField(
      controller: _busquedaCtrl,
      onChanged: (_) => setState(() {}),
      style: tema.textTheme.bodyMedium?.copyWith(
        color: ColoresApp.texto,
        fontSize: 13,
      ),
      decoration: InputDecoration(
        filled: true,
        fillColor: ColoresApp.secundario,
        prefixIcon: const Icon(Icons.search, color: ColoresApp.terceario),
        hintText: 'Buscar barberia, barbero o estilo',
        hintStyle: tema.textTheme.bodySmall?.copyWith(
          color: ColoresApp.textoClaro,
          fontSize: 12,
        ),
        suffixIcon: IconButton(
          onPressed: () {
            _busquedaCtrl.clear();
            setState(() {});
          },
          icon: const Icon(Icons.close, color: ColoresApp.terceario),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(
            color: ColoresApp.terceario.withValues(alpha: 0.3),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(
            color: ColoresApp.terceario.withValues(alpha: 0.3),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: ColoresApp.primario),
        ),
      ),
    );
  }

  Widget _buildSinResultados(ThemeData tema, String texto) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: ColoresApp.secundario,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: ColoresApp.terceario.withValues(alpha: 0.2),
        ),
      ),
      child: Text(
        texto,
        style: tema.textTheme.bodySmall?.copyWith(
          color: ColoresApp.textoClaro,
          fontSize: 12,
        ),
      ),
    );
  }
}

class _BotonCategoria extends StatelessWidget {
  const _BotonCategoria({
    required this.etiqueta,
    required this.activa,
    required this.onTap,
  });

  final String etiqueta;
  final bool activa;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    return Material(
      color: activa ? ColoresApp.primario : ColoresApp.secundario,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          child: Center(
            child: Text(
              etiqueta,
              style: tema.textTheme.labelMedium?.copyWith(
                color: activa ? ColoresApp.secundario : ColoresApp.primario,
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}

class _TarjetaNegocio extends StatelessWidget {
  const _TarjetaNegocio({
    required this.negocio,
    required this.onTap,
  });

  final NegocioVista negocio;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: ColoresApp.secundario,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: ColoresApp.terceario.withValues(alpha: 0.2)),
          boxShadow: [
            BoxShadow(
              color: ColoresApp.terceario.withValues(alpha: 0.12),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Stack(
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: 120,
                    child: Image.network(
                      negocio.imagenUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) {
                        return Container(
                          color: ColoresApp.fondo,
                          alignment: Alignment.center,
                          child: const Icon(
                            Icons.image_not_supported_outlined,
                            color: ColoresApp.terceario,
                            size: 28,
                          ),
                        );
                      },
                    ),
                  ),
                  const Positioned(
                    top: 8,
                    left: 8,
                    child: _LogoEmpresa(),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Text(
              negocio.nombre,
              style: tema.textTheme.titleSmall?.copyWith(
                color: ColoresApp.primario,
                fontWeight: FontWeight.w700,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 6),
            _detalleFila(context, Icons.location_on_outlined, 'Ubicacion', negocio.ubicacion),
            _detalleFila(context, Icons.schedule_outlined, 'Horarios', negocio.horarios),
            _detalleFila(context, Icons.build_outlined, 'Servicios', negocio.servicios.join(', ')),
            const SizedBox(height: 4),
            _calificacionConEstrellas(context),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: ColoresApp.terceario),
                const SizedBox(width: 4),
                Text(
                  'Ver detalles y barberos',
                  style: tema.textTheme.bodySmall?.copyWith(
                    color: ColoresApp.textoClaro,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _calificacionConEstrellas(BuildContext context) {
    final tema = Theme.of(context);
    final estrellasCompletas = negocio.calificacion.floor();
    final tieneMedia = (negocio.calificacion - estrellasCompletas) >= 0.5;

    return Row(
      children: [
        for (var i = 0; i < 5; i++)
          Icon(
            i < estrellasCompletas
                ? Icons.star_rounded
                : (i == estrellasCompletas && tieneMedia)
                    ? Icons.star_half_rounded
                    : Icons.star_border_rounded,
            color: ColoresApp.acento,
            size: 16,
          ),
        const SizedBox(width: 6),
        Text(
          '${negocio.calificacion} (${negocio.totalCalificaciones})',
          style: tema.textTheme.bodySmall?.copyWith(
            color: ColoresApp.textoClaro,
            fontSize: 11,
          ),
        ),
      ],
    );
  }

  Widget _detalleFila(
    BuildContext context,
    IconData icono,
    String etiqueta,
    String valor,
  ) {
    final tema = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icono, size: 14, color: ColoresApp.terceario),
          const SizedBox(width: 6),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: tema.textTheme.bodySmall?.copyWith(
                  color: ColoresApp.texto,
                  fontSize: 11,
                ),
                children: [
                  TextSpan(
                    text: '$etiqueta: ',
                    style: tema.textTheme.bodySmall?.copyWith(
                      color: ColoresApp.texto,
                      fontWeight: FontWeight.w600,
                      fontSize: 11,
                    ),
                  ),
                  TextSpan(
                    text: valor,
                    style: tema.textTheme.bodySmall?.copyWith(
                      color: ColoresApp.textoClaro,
                      fontSize: 11,
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

class _LogoEmpresa extends StatelessWidget {
  const _LogoEmpresa();

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      decoration: BoxDecoration(
        color: ColoresApp.primario.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.content_cut,
            size: 12,
            color: ColoresApp.secundario,
          ),
          const SizedBox(width: 4),
          Text(
            'AionStyle',
            style: tema.textTheme.labelSmall?.copyWith(
              color: ColoresApp.secundario,
              fontWeight: FontWeight.w700,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }
}

