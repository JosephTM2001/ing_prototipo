import 'package:ing_prototipo/Class_Game/Usuario.dart';
import 'package:ing_prototipo/Screens_Game/Partida.dart';

class BaseDeDatos {
  String datosDelUsuario = "";
  final List<Usuario> usuariosPorPartida = List.empty();

  BaseDeDatos() {}

  void getData(Map<String, dynamic> savegame) {}

  void uploadData() {}
}
