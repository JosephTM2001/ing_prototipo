// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'game_screen.dart';

class Homescreen extends StatefulWidget {

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [buttonGame(context),SizedBox(height: 20,),buttonSettings()],
        ),
     ),
   );
  }
}

//Boton para inciar juego
Widget buttonGame(BuildContext context)
{
  return Container(
    color: Colors.blue,
    child: TextButton.icon(
      icon: Icon(Icons.gamepad),
      label: Text("Jugar"),
      style: TextButton.styleFrom(foregroundColor: Colors.white,),
      onPressed: () =>  Navigator.push(context, MaterialPageRoute( builder: (context) => S_game() )) 
    ),
  );
}

//Boton para iniciar configuraciones
Widget buttonSettings()
{
    return Container(
      color: Colors.blue,
      child: TextButton( 
        child: Text('Configuraciones'), 
        style: TextButton.styleFrom(foregroundColor: Colors.white,),
        onPressed: () => print("intentado configurar"),
      ),
    );
}
