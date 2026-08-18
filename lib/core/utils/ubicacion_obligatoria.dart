import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import '../../app/theme/colores.dart';

Future<bool> exigirUbicacionAntesDeInicio(BuildContext context) async {
  while (context.mounted) {
    final servicioActivo = await Geolocator.isLocationServiceEnabled();
    final permiso = await Geolocator.checkPermission();
    final permitido = servicioActivo &&
        (permiso == LocationPermission.whileInUse ||
            permiso == LocationPermission.always);

    if (permitido) return true;

    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        final tema = Theme.of(dialogContext);
        return PopScope(
          canPop: false,
          child: AlertDialog(
            backgroundColor: ColoresApp.secundario,
            title: Text(
              'Permiso de ubicacion obligatorio',
              style: tema.textTheme.titleMedium?.copyWith(
                color: ColoresApp.primario,
                fontWeight: FontWeight.w700,
              ),
            ),
            content: Text(
              'Pedimos tu ubicacion para mostrarte negocios cercanos a ti.',
              style: tema.textTheme.bodyMedium?.copyWith(
                color: ColoresApp.texto,
              ),
            ),
            actions: [
              ElevatedButton(
                onPressed: () async {
                  final servicioAhora =
                      await Geolocator.isLocationServiceEnabled();
                  final permisoAhora = await Geolocator.checkPermission();

                  if (!servicioAhora) {
                    await Geolocator.openLocationSettings();
                  } else if (permisoAhora == LocationPermission.denied) {
                    await Geolocator.requestPermission();
                  } else if (permisoAhora == LocationPermission.deniedForever) {
                    await Geolocator.openAppSettings();
                  }

                  if (dialogContext.mounted) {
                    Navigator.of(dialogContext).pop();
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: ColoresApp.primario,
                  foregroundColor: ColoresApp.secundario,
                ),
                child: const Text('Activar ubicacion'),
              ),
            ],
          ),
        );
      },
    );
  }

  return false;
}
