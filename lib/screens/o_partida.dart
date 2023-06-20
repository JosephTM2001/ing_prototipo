import 'dart:math';
import 'package:flutter/material.dart';
import 'O_player.dart';

class Partida
{
  int np;

  List<Player> _players = [];
  late List<int> _jugadoresfaltantes;

  Partida(this.np, List<TextEditingController> reqnombres)
  {
    for(int i = 0; i < reqnombres.length;i++)
    {
      addPlayer(reqnombres[i].text);
    }

    _jugadoresfaltantes = List.generate(4, (index) => index + 1 );
  }

  //Agregar jugadores
  addPlayer(String name)
  {
    _players.add(Player(name));
  }

  //Actualizar puntos
  updatePoints(List<int> p)
  {
    //Prevencion de errores
    if(p.length != _players.length)
    {
      print("ERROR EN EL NUMERO DE PUNTOS");
    }

    //Actualizar puntos por medio de la lista entregada
    else
    {
      for(int i = 0; i < _players.length;i++)
      {
        _players[i].addPoints(p[i]);
      }
    }
  }

  //seleccionar jugador random
  int randomPlayerSelected()
  {
    int aux = Random().nextInt(_jugadoresfaltantes.length);
    int a = _jugadoresfaltantes[aux];

    _jugadoresfaltantes.removeAt(aux);

    return a;    
  }


}