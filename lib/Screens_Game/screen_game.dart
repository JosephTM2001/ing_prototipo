import 'package:flutter/material.dart';

class Screen_game extends StatefulWidget
{
  @override
  State<Screen_game> createState() => _Screen_gameState();
}

//estado 
class _Screen_gameState extends State<Screen_game> {

  Map<String,dynamic> savegame = {};
  List<String> namesList = [],phrasesList = [];
  List<int> electionList = [], pointList = []; 

  String theme = ' ';
  int indexSelector = 0,indexTurnPlayer = 0,indexRound = 1;

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

  List<Widget> childrenSelector()
  {
    switch(indexSelector)
    {
      case 0: return getNames();
      case 1: return gameLoopPhrases();
      case 2: return gameLoopSelected();
      case 3: return resultRound();

      default: break;
    }

    List<Widget> except = [];
    return except;
  }

  //Funcion para pedir los nombres
  List<Widget> getNames()
  {
    List<TextEditingController> namesSave = [];
    List<Widget> childrenList = [];

    for(int i = 0; i < 4; i++)
    {
      childrenList.add(Text('Introducir nombre de jugador ${i+1}'));

      namesSave.add(TextEditingController());
      childrenList.add(TextField(controller: namesSave[i],));
    }

    childrenList.add(TextButton(
      onPressed: ()=> setState(() { putValues(namesSave);}), 
      child: Text('Continuar'))
    );
    return childrenList;
  }

  //Colocar nombres en la lista y comenzar juego
  void putValues(List<TextEditingController> tNames)
  {
    List<String> tnamelist = [];

    for(int i = 0; i < tNames.length; i++)
    {
      tnamelist.add(tNames[i].text);
    }    
    namesList = tnamelist;

    List<int> tpoint = [];

    pointList = List.generate(namesList.length, (index) => 0);
    indexSelector = 1;
  }

  //GameLoop para elegir frase
  List<Widget> gameLoopPhrases()
  {
    List<Widget> childrenList = [];
    TextEditingController controllertheme = TextEditingController(), controllerphrase = TextEditingController();
    controllertheme.text = theme;

    if(indexTurnPlayer == 0)
    {
      childrenList.add(Text('Turno de ${namesList[indexTurnPlayer]}'));
      childrenList.add(Text('Introduce el tema'));
      childrenList.add(TextField(controller: controllertheme,));    
    }

    else if (indexTurnPlayer < namesList.length)
    {
      childrenList.add(Text('Turno de ${namesList[indexTurnPlayer]}'));
      childrenList.add(Text('Temas: ${theme}'));
    }

    childrenList.add(Text('Introduce tu frase'));
    childrenList.add(TextField(controller: controllerphrase,));

    childrenList.add(TextButton(
      onPressed: ()=> setState(() { 
        phrasesList.add(controllerphrase.text);
        theme = controllertheme.text;
      }), 
      child: Text('Pasar al siguiente jugador'))
    );

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
    List<int> random = List.generate(4, (index) => index);

    random.shuffle();

    if(indexTurnPlayer < namesList.length)
    {childrenList.add(Text('Elije una frase jugador: ${namesList[indexTurnPlayer]}'));}

    for(int i = 0; i < phrasesList.length;i++)
    {
      childrenList.add(TextButton(
        onPressed: () => setState(() {
          electionList.add(random[i]);
        }),
        child: Text('${phrasesList[random[i]]}')));
    }

    indexTurnPlayer++;
    if(indexTurnPlayer == namesList.length)
    {
      indexTurnPlayer = 0;
      indexSelector = 3;
    } 

    return childrenList;
  }

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

      //Se le da puntos a quien haya engañado a otro jugador
      for(int j = 1; j < namesList.length;j++)
      {
        if(electionList[i] == j && i != j-1)
        {
          pointList[j] += 1;
        }
      }
    }

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

    savegame['jugadores ronda ${indexRound}'] = namesList;
    savegame['Tema ronda ${indexRound}'] = theme;
    savegame['frases ronda ${indexRound}'] = phrasesList;
    savegame['puntajes ronda ${indexRound}'] = pointList;

    for(int i = 0; i < pointList.length;i++)
    {
      childrenList.add(Text('El jugador ${namesList[i]} tiene ${pointList[i]} puntos'));
    }

    childrenList.add(TextButton(onPressed: ()=> Navigator.pop(context), child: Text('volver al menu principal')));  
    childrenList.add(TextButton(onPressed: ()=> setState(() {}), child: Text('Continuar')));  

    indexRound++;
    indexSelector = 1;
    indexTurnPlayer = 0;
    electionList = [];
    phrasesList = [];
    theme = '';
    namesList.add(namesList[0]);
    namesList.removeAt(0);

    print(' ${savegame} \n');


    return childrenList;
  }


}


