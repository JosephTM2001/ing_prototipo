import 'package:flutter/material.dart';
import 'o_partida.dart';

class S_gameloop extends StatefulWidget {

  final List<TextEditingController> nombres;
  S_gameloop({required this.nombres});

  @override
  State<S_gameloop> createState() => _s_gameloop(nombres_: nombres);
}

class _s_gameloop extends State<S_gameloop>
{
  final List<TextEditingController> nombres_;
  _s_gameloop({required this.nombres_});

    @override
  Widget build(BuildContext context) 
  {
    //Partida con los jugadores actuales
    Partida rondactual = GeneratedPlayers();

    //index del jugador actual
    int indexjugadores = rondactual.randomPlayerSelected();
    int playerturno = -1;
    List<Widget> listaW = [];

    listaW = listWGenerated(listaW,indexjugadores,playerturno);

    return Scaffold(
      body: ListView(
        children: listaW,
      )
    );
  }


  //Generar nueva Partida con los jugadores proporcionados
  Partida GeneratedPlayers()
  {
    Partida n = Partida(nombres_.length, nombres_);
    
    return n;    
  }

  //Generador de lista de widgets
  List<Widget> listWGenerated(List<Widget> listW_ ,int indexp,int indexactual)
  {
    List<Widget> aux = listW_;

    if(indexactual == -1)
    {
      aux.add(Text('${nombres_[indexp].text}'));
      aux.add(TextField());
      aux.add(TextField());
    }

    else if(indexp != indexactual){
      
    }

    else
    {
      return listWGenerated(listW_ ,indexp,indexactual+1);
    }

    return aux;
  }
}



