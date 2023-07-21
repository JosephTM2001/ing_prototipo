import 'package:flutter/material.dart';
import 'package:ing_prototipo/Screens_Game/Sala.dart';

class Sistema extends StatefulWidget {
  @override
  State<Sistema> createState() => _Screen_homeState();
}

class _Screen_homeState extends State<Sistema> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: Column(
      children: [
        TextButton(
            onPressed: () => {
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (context) => Sala()))
                },
            child: Text('Crear sala')),
      ],
    )));
  }
}
