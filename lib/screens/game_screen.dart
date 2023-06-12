import 'package:flutter/material.dart';
import 'o_ronda.dart';

class s_game extends StatefulWidget {

  @override
  State<s_game> createState() => _s_gameState();
}

class _s_gameState extends State<s_game> {
  @override
  Widget build(BuildContext context) 
  {
    return Scaffold(
      body: Center(
        child: Column(
          //mainAxisAlignment: MainAxisAlignment.center,
          children: [
            columGenerator(),
            Container(
              child: TextButton.icon(
                icon: Icon(Icons.back_hand), 
                label: Text('regresar'),
                onPressed: () => Navigator.pop(context)
              ),
            ),
          ],
        ),
     ),
   );
  }
}

Widget columGenerator()
{
  Column columna = new Column(children: [],);

  columna.children.add(Text('Ingresar numero de jugadores'));
  columna.children.add(SizedBox(height: 100,));

  for(int i = 0; i < 4; i++)
  { 
      columna.children.add(TextField());
  }

  return columna;
}

