import 'package:flutter/material.dart';
import 'o_ronda.dart';

class S_game extends StatefulWidget {

  @override
  State<S_game> createState() => _s_gameState();
}

class _s_gameState extends State<S_game> {
  
  Widget widgaux =  SizedBox(width: 0, height: 0);

  @override
  Widget build(BuildContext context) 
  {
    return Scaffold(
      body: Center(
        child: Column(
          //mainAxisAlignment: MainAxisAlignment.center,
          children: [
            widgaux,
            selectPlayers(widgaux, setState),
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


Widget selectPlayers(Widget intern, Function? callback)
{
  Column columna = new Column(children: [],);

  for(int i = 0; i < 6; i++)
  {
    columna.children.add(
      TextButton(
        onPressed:  () 
        {
          columnGenerator(i+1);
          callback;
        },
        child: Text("${i+1}"),
     )
    );
  }

  return columna;
}

Widget columnGenerator(int num)
{
  Column columna = new Column(children: [],);

  columna.children.add(Text('Ingresar numero de jugadores'));
  columna.children.add(SizedBox(height: 100,));

  for(int i = 0; i < num; i++)
  { 
      columna.children.add(TextField());
  }

  return columna;
}


