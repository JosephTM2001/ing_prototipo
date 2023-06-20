import 'package:flutter/material.dart';
import 'gameloop_screen.dart';

class S_game extends StatefulWidget {

  @override
  State<S_game> createState() => _s_gameState();
}

class _s_gameState extends State<S_game> {
  
  List<TextEditingController> listcontroller = List.generate(4, (index) => TextEditingController() );

  @override
  Widget build(BuildContext context) 
  {
    return Scaffold(
      body: ListView(
        children :<Widget> [
          gridGenerator(context, listcontroller),       
          Container(
            child: TextButton.icon(
              icon: Icon(Icons.back_hand), 
              label: Text('regresar'),
              onPressed: () => Navigator.pop(context)
            ),
          ),
          Container(
            child: TextButton.icon(
              icon: Icon(Icons.back_hand), 
              label: Text('siguiente'),
              onPressed: () => Navigator.pushReplacement(context, MaterialPageRoute( builder: (context) => S_gameloop(nombres: listcontroller) )) 
            ),
          ),
      ]
        ),
     );
  }
}

Widget gridGenerator(BuildContext context, List<TextEditingController> controllers)
{
  var size = MediaQuery.of(context).size;

  final double itemHeight = (size.height - kToolbarHeight - 24) / 8;
  final double itemWidth = size.width / 2;

  List<Widget> a = [];

  for(int i = 0; i < 4; i++)
  {
    a.add(TextField(controller: controllers[i],));

    a.add(
      Container(
        child: Text('jugador ${i+1}')
      ), 
    );
  }

  return  GridView.count(
  shrinkWrap: true,
  crossAxisCount: 2,
  childAspectRatio: (itemWidth / itemHeight),
  children: a,
  );
}
