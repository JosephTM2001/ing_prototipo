import 'package:flutter/material.dart';
import 'package:ing_prototipo/Screens_Game/screen_make.dart';

class Screen_home extends StatefulWidget
{
  @override
  State<Screen_home> createState() => _Screen_homeState();
}

class _Screen_homeState extends State<Screen_home> {
  @override
  Widget build(BuildContext context) {

     return Scaffold(
      body: Center(
        child: Column(
          children: [TextButton(onPressed: () => {Navigator.of(context).push(MaterialPageRoute(builder: (context) => Screen_make()))} , child: Text('Crear sala')),],
        )
      )
    );    
  }
}
