import 'package:flutter/material.dart';

class Screen_game extends StatefulWidget
{
  @override
  State<Screen_game> createState() => _Screen_gameState();
}

//estado 
class _Screen_gameState extends State<Screen_game> {

  //Variebles globales que se usaran
  Map<String,dynamic> savegame = {};                          //Guardador principal de toda la informacion, tratar de enviar esto a la base de datos
  List<String> namesList = [],phrasesList = [];               //Listas que guardara los nombre de los participantes y la frases
  List<int> electionList = [], pointList = [];                //Listas que guardaran las elecciones de los jugadores y los puntos que tienen
  String theme = ' ';                                         //Variable que guardara el tema de la ronda
  int indexSelector = 0,indexTurnPlayer = 0,indexRound = 1;   //Variables que serviran de index, para seleccionar el menu, el turno del jugador, y el numero de la ronda, respectivamente


  //Menú principal
  @override
  Widget build(BuildContext context) {

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

    //for que crea widgets para los nombres
    for(int i = 0; i < 4; i++)
    {
      childrenList.add(Text('Introducir nombre de jugador ${i+1}'));

      namesSave.add(TextEditingController());
      childrenList.add(TextField(controller: namesSave[i],));
    }

    //Boton para continuar a la siguiente parte del juego
    childrenList.add(TextButton(
      onPressed: ()=> setState(() { putValues(namesSave);}), 
      child: Text('Continuar'))
    );

    return childrenList;
  }

  //Función encargada de iniciar todas las variables
  void putValues(List<TextEditingController> tNames)
  {
    //almacenar los nombres y guardarlos en la variable global
    List<String> tnamelist = [];
    for(int i = 0; i < tNames.length; i++)
    {
      tnamelist.add(tNames[i].text);
    }    
    namesList = tnamelist;
    
    //iniciar lista de puntajes
    List<int> tpoint = [];
    pointList = List.generate(namesList.length, (index) => 0);

    //siguiente parte del loop
    indexSelector = 1;
  }

  //GameLoop para elegir frase
  List<Widget> gameLoopPhrases()
  {
    List<Widget> childrenList = [];

    //guardar el tema del juego en variables locales
    TextEditingController controllertheme = TextEditingController(), controllerphrase = TextEditingController();
    controllertheme.text = theme;

    //Si el jugador es el cuentacuentos debe colocar la frase y el tema
    if(indexTurnPlayer == 0)
    {
      childrenList.add(Text('Turno de ${namesList[indexTurnPlayer]}'));
      childrenList.add(Text('Introduce el tema'));
      childrenList.add(TextField(controller: controllertheme,));    
    }

    //Si el jugador es un adivinante debe dejar su frase para engañar
    else if (indexTurnPlayer < namesList.length)
    {
      childrenList.add(Text('Turno de ${namesList[indexTurnPlayer]}'));
      childrenList.add(Text('Temas: ${theme}'));
    }

    childrenList.add(Text('Introduce tu frase'));
    childrenList.add(TextField(controller: controllerphrase,));

    //pasar al siguiente jugador
    childrenList.add(TextButton(
      onPressed: ()=> setState(() { 
        phrasesList.add(controllerphrase.text);
        theme = controllertheme.text;
      }), 
      child: Text('Pasar al siguiente jugador'))
    );

    //pasamos al siguiente jugador, si se terminan se pasa a la siguiente seccion del loop
    indexTurnPlayer++;
    if(indexTurnPlayer == namesList.length)
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
    List<int> random = List.generate(4, (index) => index);
    random.shuffle();

    //verificacion para evitar desastres
    if(indexTurnPlayer < namesList.length)
    {childrenList.add(Text('Elije una frase jugador: ${namesList[indexTurnPlayer]}'));}

    //for que nos dara las frases en distintos ordenes
    for(int i = 0; i < phrasesList.length;i++)
    {
      childrenList.add(TextButton(
        onPressed: () => setState(() {
          electionList.add(random[i]);
        }),
        child: Text('${phrasesList[random[i]]}')));
    }

    //pasamos al siguiente jugador, cuando todos terminen pasamos a ver los resultados
    indexTurnPlayer++;
    if(indexTurnPlayer == namesList.length)
    {
      indexTurnPlayer = 0;
      indexSelector = 3;
    } 

    return childrenList;
  }

  //Función para obtener los puntos designados
  void getPoints()
  {
    bool confirmed = false;
    int p = 0;

    //verificador de puntaje
    for(int i = 0; i < electionList.length;i++)
    {
      //Si se elije la respuesta del cuentacuentos entonces se le asigna un punto
      if(electionList[i] == 0)
      {
        confirmed = true;
        p++;
      }

      //Si todos eligieron la respuesta correcta entonces se dice que el cuenta cuentos perdio
      if(p == namesList.length - 1)
      {
        confirmed = false;
      }

      //Se le da puntos a quien haya engañado a otro jugador, no contaran autovotaciones
      for(int j = 1; j < namesList.length;j++)
      {
        if(electionList[i] == j && i != j-1)
        {
          pointList[j] += 1;
        }
      }
    }

    //alguien le acerto a la frase correcta
    if(confirmed)
    {  
      pointList[0] += 2;
      for(int i = 0; i < electionList.length;i++)
      {
        if(electionList[i] == 0)
        {
          pointList[i+1] += 3;
        }
      }
    }

    //Nadie o todos acertaron a la frase correcta
    else
    {
      for(int i = 0; i < electionList.length;i++)
      {
          pointList[i+1] += 2;
      }
    }
  }

  //Resultados
  List<Widget> resultRound()
  {
    List<Widget> childrenList = [];
    getPoints();    

    //Se guarda todo el progreso del juego
    savegame['jugadores ronda ${indexRound}'] = namesList;
    savegame['Tema ronda ${indexRound}'] = theme;
    savegame['frases ronda ${indexRound}'] = phrasesList;
    savegame['puntajes ronda ${indexRound}'] = pointList;

    //Se muestra en pantalla los resultados
    for(int i = 0; i < pointList.length;i++)
    {
      childrenList.add(Text('El jugador ${namesList[i]} tiene ${pointList[i]} puntos'));
    }

    //Botones para regresar o continuar jugando
    childrenList.add(TextButton(onPressed: ()=> Navigator.pop(context), child: Text('Volver al menu principal')));  //->enviar aqui el savegame
    childrenList.add(TextButton(onPressed: ()=> setState(() {}), child: Text('Continuar jugando')));  

    //Reinicio de todas las variables globales
    indexRound++;
    indexSelector = 1;
    indexTurnPlayer = 0;
    electionList = [];
    phrasesList = [];
    theme = '';

    //el primer jugador pasa a ser el ultimo
    namesList.add(namesList[0]);
    namesList.removeAt(0);

    print(' ${savegame} \n');


    return childrenList;
  }


}


