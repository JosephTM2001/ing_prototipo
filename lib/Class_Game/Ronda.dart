import 'Usuario.dart';

class Ronda {
  List<Usuario> listaJugadores = [];
  List<String> listaDeFrase = [];

  late int indexRound;
  late String tema, narrador;

  List<int> listaDeElecciones = [];

  Ronda(List<Usuario> pl, int ir) {
    listaJugadores = pl;
    indexRound = ir;
    tema = '';
    narrador = listaJugadores[0].name;
  }

  void setTema(String t) {
    tema = t;
  }

  void setFrase(String p) {
    listaDeFrase.add(p);
  }

  void setSeleccionDeUsuario(int ps) {
    listaDeElecciones.add(ps);
  }

  void getPuntos() {
    bool confirmed = false;
    int p = 0;

    for (int i = 0; i < listaDeElecciones.length; i++) {
      if (listaDeElecciones[i] == 0) {
        confirmed = true;
        p++;
      }

      if (p == listaJugadores.length - 1) {
        confirmed = false;
      }

      for (int j = 1; j < listaJugadores.length; j++) {
        if (listaDeElecciones[i] == j && i != j - 1) {
          listaJugadores[j].points += 1;
        }
      }
    }

    if (confirmed) {
      listaJugadores[0].points += 2;
      for (int i = 0; i < listaDeElecciones.length; i++) {
        if (listaDeElecciones[i] == 0) {
          listaJugadores[i + 1].points += 3;
        }
      }
    } else {
      for (int i = 0; i < listaDeElecciones.length; i++) {
        listaJugadores[i + 1].points += 2;
      }
    }
  }

  List<Usuario> getActualizacionDeUsuario() {
    return listaJugadores;
  }

  Map<String, dynamic> actualizarGuardadoDeJuego(savegamep) {
    savegamep['Ronda ${indexRound}'];
    savegamep['Ronda ${indexRound},Tema:'] = tema;
    savegamep['Ronda ${indexRound},Narrador:'] = narrador;
    savegamep['Ronda ${indexRound},Jugadores:'] = listaJugadores;
    savegamep['Ronda ${indexRound},Frases:'] = listaDeFrase;

    return savegamep;
  }

  int getMayorPuntaje() {
    int p = 0;

    for (int i = 0; i < listaJugadores.length; i++) {
      if (listaJugadores[i].points > p) {
        p = listaJugadores[i].points;
      }
    }

    return p;
  }
}
