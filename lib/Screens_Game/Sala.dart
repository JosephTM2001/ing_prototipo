import 'dart:js_util';

import 'package:flutter/material.dart';
import 'package:ing_prototipo/Screens_Game/Partida.dart';
import 'package:flutter/material.dart';

class Sala extends StatefulWidget {
  @override
  State<Sala> createState() => _Screen_makeState();
}

class _Screen_makeState extends State<Sala> {
  int playersNumber = 0, maxpoints = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            margin: const EdgeInsets.all(50.0),
            alignment: Alignment.center,
            child: Column(
              children: generatedChildrens(),
            )));
  }

  List<bool> activadoList = [];
  List<bool> activadoList2 = [];

  List<bool> generarCheck(List<bool> aux, int aux2) {
    if (aux.length == 0) {
      aux = List.generate(aux2, (index) => false);
    }
    return aux;
  }

  bool activado = false;
  bool activado2 = false;

  List<Widget> generatedChildrens() {
    List<Widget> childrenList = [];

    childrenList.add(Text("Seleccionar cantidad de jugadores"));
    activadoList = generarCheck(activadoList, 3);
    activadoList2 = generarCheck(activadoList2, 4);

    for (int i = 0; i < 3; i++) {
      /*childrenList.add(TextButton(
          onPressed: () => {
                playersNumber = i,
              },
          child: Text("${i} jugadores")));*/
      childrenList.add(CheckboxListTile(
        title: Text("${i + 4} jugadores"),
        secondary: Icon(Icons.person),
        controlAffinity: ListTileControlAffinity.platform,
        value: activadoList[i],
        onChanged: (bool? value) {
          setState(() {
            for (int j = 0; j < activadoList.length; j++) {
              activadoList[j] = false;
            }
            activadoList[i] = true;
            playersNumber = i + 4;
            activado = true;
          });
        },
        activeColor: Colors.grey,
        checkColor: Colors.black,
      ));
    }

    childrenList.add(Text("Seleccionar Puntaje maximo"));
    for (int i = 0; i < 4; i++) {
      /*childrenList.add(TextButton(
          onPressed: () => {
                maxpoints = i * 5,
              },
          child: Text("${i * 5} puntos maximos")));*/
      childrenList.add(CheckboxListTile(
        title: Text("${(i + 1) * 5} puntos maximos"),
        secondary: Icon(Icons.abc_rounded),
        controlAffinity: ListTileControlAffinity.platform,
        value: activadoList2[i],
        onChanged: (bool? value) {
          setState(() {
            for (int j = 0; j < activadoList2.length; j++) {
              activadoList2[j] = false;
            }
            activadoList2[i] = true;
            maxpoints = (i + 1) * 5;
            activado2 = true;
          });
        },
        activeColor: Colors.grey,
        checkColor: Colors.black,
      ));
    }

    childrenList.add(OutlinedButton(
      onPressed: () => {
        if (activado && activado2)
          {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) =>
                    Partida(pn: playersNumber, mp: maxpoints))),
          }
      },
      style: ButtonStyle(
        shape: MaterialStateProperty.all(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(1.0))),
      ),
      child: const Text("Comenzar Juego"),
    ));

    return childrenList;
  }
}
