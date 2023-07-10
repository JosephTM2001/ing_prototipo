import 'package:flutter/material.dart';
import 'package:ing_prototipo/Class_Game/class_Player.dart';
import 'package:ing_prototipo/Class_Game/class_Round.dart';

class Screen_game extends StatefulWidget
{
  final int pn, mp;
  Screen_game({required this.pn,required this.mp});

  @override
  State<Screen_game> createState() => _Screen_gameState(playersnumber: pn,maxpoints: mp);
}

//estado 
class _Screen_gameState extends State<Screen_game> {

  final int playersnumber,maxpoints;
  _Screen_gameState({required this.playersnumber,required this.maxpoints});

  //Variebles globales que se usaran
  Map<String,dynamic> savegame = {};                          //Guardador principal de toda la informacion, tratar de enviar esto a la base de datos         
  int indexSelector = 0,indexTurnPlayer = 0,indexRound = 1, highpoint = 0;   //Variables que serviran de index, para seleccionar el menu, el turno del jugador, y el numero de la ronda, respectivamente

  List<Player> playersList = [];
  late Round actualRound;

  var size;

  //Menú principal
  @override
  Widget build(BuildContext context) {

  size = MediaQuery.of(context).size;
    return Scaffold(
      body: Center(
        child: Column(
          children: childrenSelector(),
        )
      )
    );    
  }

  //Función encargada de seleccionar el menu en el que se encuentra el jugador
  List<Widget> childrenSelector()
  {
    switch(indexSelector)
    {
      case 0: return getNames();          // -> Obtener nombres
      case 1: return gameLoopPhrases();   // -> Dar frases
      case 2: return gameLoopSelected();  // -> Elegir las frases 
      case 3: return resultRound();       // -> Mostrar frases

      //si existe un fallo se rompera el programa
      default: break;
    }

    //Return preventivo requerido de la función
    List<Widget> except = [];
    return except;
  }

  //Función para pedir los nombres
  List<Widget> getNames()
  {
    List<TextEditingController> namesSave = []; //Guardar los nombres
    List<Widget> childrenList = [];
    List<Widget> grid =[];

    //for que crea widgets para los nombres
    for(int i = 0; i < playersnumber; i++)
    {
      childrenList.add(Container( color: Colors.amber,child: Text('Introducir nombre de jugador ${i+1}',textAlign: TextAlign.center)));

      namesSave.add(TextEditingController());
      childrenList.add(TextField(controller: namesSave[i],));
    }

    grid.add(
      GridView.count(
        crossAxisCount: 2,
        childAspectRatio: ( (size.width/2) / ((size.height - kToolbarHeight - 24) / (childrenList.length/2))),
        shrinkWrap : true,
        children: childrenList,
      )
    );

    //Boton para continuar a la siguiente parte del juego
    grid.add(Container(
      color: Colors.blueAccent,
      child: TextButton(
        onPressed: ()=> setState(() { putValues(namesSave);}), 
        child: const Text('Continuar',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        )
          ),
    )
    );

    return grid;
  }

 
  void putValues(List<TextEditingController> tNames)
  {
    for(int i = 0; i < tNames.length; i++)
    {
      playersList.add(Player(tNames[i].text));
    }   

    actualRound = Round(playersList, indexRound);

    //actualRound = Round(playersList, indexRound);
    indexSelector = 1;
  }

  //GameLoop para elegir frase
  List<Widget> gameLoopPhrases()
  {
    List<Widget> childrenList = [];

    //guardar el tema del juego en variables locales
    TextEditingController controllertheme = TextEditingController(), controllerphrase = TextEditingController();
    controllertheme.text = actualRound.theme;

    //Si el jugador es el cuentacuentos debe colocar la frase y el tema
    if(indexTurnPlayer == 0)
    {
      childrenList.add(Text('Turno de ${playersList[indexTurnPlayer].name}'));
      childrenList.add(Text('Introduce el tema'));
      childrenList.add(TextField(controller: controllertheme,));    
    }

    //Si el jugador es un adivinante debe dejar su frase para engañar
    else if (indexTurnPlayer < playersList.length)
    {
      childrenList.add(Text('Turno de ${playersList[indexTurnPlayer].name}'));
      childrenList.add(Text('Temas: ${actualRound.theme}'));
    }

    childrenList.add(Text('Introduce tu frase'));
    childrenList.add(TextField(controller: controllerphrase,));

    //pasar al siguiente jugador
    childrenList.add(TextButton(
      onPressed: ()=> setState(() { 
        actualRound.setPhrase(controllerphrase.text);
        actualRound.setTheme(controllertheme.text);
      }), 
      child: Text('Pasar al siguiente jugador'))
    );

    //pasamos al siguiente jugador, si se terminan se pasa a la siguiente seccion del loop
    indexTurnPlayer++;
    if(indexTurnPlayer == playersList.length)
    {
      indexTurnPlayer = 1;
      indexSelector = 2;
    } 

    return childrenList;
  }

  //GameLoop para la eleccion de la frase
  List<Widget> gameLoopSelected()
  {
    List<Widget> childrenList = [];

    //generamos una lista random para mezclar las frases
    List<int> random = List.generate(playersList.length, (index) => index);
    random.shuffle();

    //verificacion para evitar desastres
    if(indexTurnPlayer < playersList.length)
    {childrenList.add(Text('Elije una frase jugador: ${actualRound.playersList[indexTurnPlayer].name}'));}

    //for que nos dara las frases en distintos ordenes
    for(int i = 0; i < actualRound.phrasesList.length;i++)
    {
      childrenList.add(TextButton(
        onPressed: () => setState(() {
          actualRound.electionList.add(random[i]);
        }),
        child: Text('${actualRound.phrasesList[random[i]]}')));
    }

    //pasamos al siguiente jugador, cuando todos terminen pasamos a ver los resultados
    indexTurnPlayer++;
    if(indexTurnPlayer == playersList.length)
    {
      indexTurnPlayer = 0;
      indexSelector = 3;
    } 

    return childrenList;
  }

  
  //Resultados
  List<Widget> resultRound()
  {
    List<Widget> childrenList = [];

    //Se guarda todo el progreso del juego
    actualRound.getPoints();    
    playersList = actualRound.getPlayerUpdate();
    highpoint = actualRound.getHighpoint();
    savegame = actualRound.updateSavegame(savegame);

    //Se muestra en pantalla los resultados
    for(int i = 0; i < playersList.length;i++)
    {
      childrenList.add(Text('El jugador ${playersList[i].name} tiene ${playersList[i].points} puntos'));
    }

    //Botones para regresar o continuar jugando
    if(highpoint < maxpoints)
    {
      childrenList.add(TextButton(onPressed: ()=> Navigator.pop(context), child: Text('Volver al menu principal')));  //->enviar aqui el savegame
      childrenList.add(TextButton(onPressed: ()=> setState(() {}), child: Text('Continuar jugando')));  
    }

    else
    {
      childrenList.add(TextButton(onPressed: ()=> Navigator.pop(context), child: Text('Terminar partida')));  //->enviar aqui el savegame
    }

    //Reinicio de todas las variables globales
    indexRound++;
    indexSelector = 1;

    playersList.add(playersList[0]);
    playersList.removeAt(0);

    actualRound = Round(playersList, indexRound);

    print(' ${savegame} \n');


    return childrenList;
  }


}


