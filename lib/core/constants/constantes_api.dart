abstract class ConstantesApi {
  // Autenticación
  static const login = '/auth/login';
  static const registro = '/auth/registro';
  static const cerrarSesion = '/auth/logout';
  static const refrescarToken = '/auth/refresh';
  static const loginGoogle = '/auth/google';

  // Usuarios / Perfil
  static const perfil = '/usuarios/perfil';
  static const actualizarPerfil = '/usuarios/perfil';

  // Negocios
  static const negocios = '/negocios';
  static String negocioPorId(String id) => '/negocios/$id';

  // Barberos
  static const barberos = '/barberos';
  static String barberoPorId(String id) => '/barberos/$id';
  static String barberosPorNegocio(String negocioId) => '/negocios/$negocioId/barberos';

  // Servicios
  static const servicios = '/servicios';
  static String serviciosPorNegocio(String negocioId) => '/negocios/$negocioId/servicios';

  // Citas
  static const citas = '/citas';
  static String citaPorId(String id) => '/citas/$id';
  static String citasPorUsuario(String usuarioId) => '/usuarios/$usuarioId/citas';
  static String cancelarCita(String id) => '/citas/$id/cancelar';

  // Pagos
  static const pagos = '/pagos';
  static const intentoPago = '/pagos/intento';
  static String confirmarPago(String pagoId) => '/pagos/$pagoId/confirmar';

  // QR
  static const validarQr = '/qr/validar';

  // Recibos
  static String reciboPorCita(String citaId) => '/citas/$citaId/recibo';
}
