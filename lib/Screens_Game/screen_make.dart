import 'package:flutter/material.dart';
import 'package:ing_prototipo/Screens_Game/screen_game.dart';

class Screen_make extends StatefulWidget
{
  @override
  State<Screen_make> createState() => _Screen_makeState();
}

class _Screen_makeState extends State<Screen_make> {

  int playersNumber = 0,maxpoints = 0;


  @override
  Widget build(BuildContext context) {

     return Scaffold(
      body: Center(
        child: Column(
          children: generatedChildrens(),
        )
      )
    );    
  }

  List<Widget> generatedChildrens()
  {
    List<Widget> childrenList = [];

    childrenList.add(Text("Seleccionar cantidad de jugadores"));

    for(int i = 3;i <= 6;i++)
    {
      childrenList.add(TextButton(
        onPressed: ()=> {
          playersNumber = i,
          
          },
         child: Text("${i} jugadores")));
    }   

    childrenList.add(Text("Seleccionar Puntaje maximo"));
    for(int i = 1;i <= 4;i++)
    {
      childrenList.add(TextButton(
        onPressed: ()=> {
          maxpoints = i*5,
          },
         child: Text("${i*5} puntos maximos")));
    }  

    childrenList.add(
      TextButton(onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => Screen_game(pn: playersNumber,mp: maxpoints))), 
      child: Text('Setear opciones'))
    );


    return childrenList;
  }

  



}
