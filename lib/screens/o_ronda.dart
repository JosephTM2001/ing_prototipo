import 'O_player.dart';

class Ronda
{
  int np;
  List<Player> players =[];

  Ronda(this.np);

  //Agregar jugadores
  addPlayer(String name)
  {
    players.add(Player(name));
  }

  //Actualizar puntos
  updatePoints(List<int> p)
  {
    //Prevencion de errores
    if(p.length != players.length)
    {
      print("ERROR EN EL NUMERO DE PUNTOS");
    }

    //Actualizar puntos por medio de la lista entregada
    else
    {
      for(int i = 0; i < players.length;i++)
      {
        players[i].addPoints(p[i]);
      }
    }
  }


}