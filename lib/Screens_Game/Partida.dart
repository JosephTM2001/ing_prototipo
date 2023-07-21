import 'package:flutter/material.dart';
import 'package:ing_prototipo/Class_Game/BaseDeDatos.dart';
import 'package:ing_prototipo/Class_Game/Usuario.dart';
import 'package:ing_prototipo/Class_Game/Ronda.dart';
import 'package:ing_prototipo/Class_Game/BaseDeDatos.dart';

class Partida extends StatefulWidget {
  final int pn, mp;
  Partida({required this.pn, required this.mp});

  @override
  State<Partida> createState() =>
      _Screen_gameState(numeroDeJugadores: pn, maximoRondas: mp);
}

//estado
class _Screen_gameState extends State<Partida> {
  final int numeroDeJugadores, maximoRondas;
  _Screen_gameState(
      {required this.numeroDeJugadores, required this.maximoRondas});

  //Variebles globales que se usaran
  Map<String, dynamic> guardarJuego =
      {}; //Guardador principal de toda la informacion, tratar de enviar esto a la base de datos
  int selectorDeIndice = 0,
      indiceDeTrunoDeUsuario = 0,
      indiceDeRonda = 1,
      mayorPuntaje =
          0; //Variables que serviran de index, para seleccionar el menu, el turno del jugador, y el numero de la ronda, respectivamente

  List<Usuario> listaDeJugadores = [];
  late Ronda rondaActual;
  BaseDeDatos datamain = BaseDeDatos();

  var tamanio;

  //Menú principal
  @override
  Widget build(BuildContext context) {
    tamanio = MediaQuery.of(context).size;
    return Scaffold(
        body: Center(
            child: Column(
      children: childrenSelector(),
    )));
  }

  //Función encargada de seleccionar el menu en el que se encuentra el jugador
  List<Widget> childrenSelector() {
    switch (selectorDeIndice) {
      case 0:
        return getNames(); // -> Obtener nombres
      case 1:
        return gameLoopPhrases(); // -> Dar frases
      case 2:
        return gameLoopSelected(); // -> Elegir las frases
      case 3:
        return resultRound(); // -> Mostrar frases

      //si existe un fallo se rompera el programa
      default:
        break;
    }

    //Return preventivo requerido de la función
    List<Widget> except = [];
    return except;
  }

  List<String> list = <String>[
    'assets/Cerdo.png',
    'assets/Elefante.png',
    'assets/Gato.png',
    'assets/Jabali.png',
    'assets/Oso.png',
    'assets/Raton.png',
    'assets/zorro.png'
  ];

  List<int> list2 = [];

  List<int> generarIconos() {
    List<int> listTemp;

    if (list2.length == 0) {
      listTemp = List.generate(numeroDeJugadores, (index) => index);
    } else {
      listTemp = list2;
    }

    return listTemp;
  }

  int indiceIcono = 0;

  //Función para pedir los nombres
  List<Widget> getNames() {
    String dropdownValue = list.first;
    List<TextEditingController> namesSave = []; //Guardar los nombres
    List<Widget> childrenList = [];
    List<Widget> grid = [];

    list2 = generarIconos();

    //for que crea widgets para los nombres
    for (int i = 0; i < numeroDeJugadores; i++) {
      //childrenList.add(Image(image: AssetImage('assets/Cerdo.png')));
      childrenList.add(InkWell(
        onTap: () => setState(() {
          indiceIcono = list2[i];
          indiceIcono++;
          if (indiceIcono < 7) {
            list2[i] = indiceIcono;
            print(list2[i]);
          } else {
            list2[i] = 0;
          }
        }),
        child: Container(
            height: 120.0,
            width: 120.0,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(list[list2[i]]),
                fit: BoxFit.scaleDown,
              ),
              shape: BoxShape.circle,
            ),
            margin: const EdgeInsets.all(30.0),
            //color: Colors.amber,
            child: Text('', textAlign: TextAlign.center)),
      ));

      namesSave.add(TextEditingController());
      childrenList.add(
        Container(
          alignment: Alignment.center,
          child: SizedBox(
            height: 50,
            // set desired height here
            child: TextFormField(
              decoration: InputDecoration(
                labelText: 'Nombre del jugador ${i + 1}',
                border: OutlineInputBorder(),
              ),
              controller: namesSave[i],
            ),
          ),
        ),
      );
      /*TextField(
        controller: namesSave[i],
      )*/
    }

    grid.add(GridView.count(
      crossAxisCount: 2,
      childAspectRatio: ((tamanio.width / 2) /
          ((tamanio.height - kToolbarHeight - 24) / (childrenList.length / 2))),
      shrinkWrap: true,
      children: childrenList,
    ));

        //Boton para continuar a la siguiente parte del juego
    grid.add(Container(
      color: Colors.blueAccent,
      child: TextButton(
          onPressed: () => setState(() {
                bool confirmado = true;
                for (int i = 0; i < namesSave.length; i++) {
                  if (namesSave[i].text == "") {
                    confirmado = false;
                  }
                }
                if (confirmado) {
                  putValues(namesSave);
                }
              }),
          child: const Text(
            'Continuar',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
            ),
          )),
    ));


    grid.add(SizedBox(width: 10,height: 10,));

    grid.add(Container(
      color: Colors.blueAccent,
      child: TextButton(
          onPressed: () => setState(() {
            Navigator.pop(context);
              }),
          child: const Text(
            'Regresar',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
            ),
          )),
    ));

    return grid;
  }

  void putValues(List<TextEditingController> tNames) {
    for (int i = 0; i < tNames.length; i++) {
      listaDeJugadores.add(Usuario(tNames[i].text,list[list2[i]]));
    }

    rondaActual = Ronda(listaDeJugadores, indiceDeRonda);

    //actualRound = Round(playersList, indexRound);
    selectorDeIndice = 1;
  }

  //GameLoop para elegir frase
  List<Widget> gameLoopPhrases() {
    List<Widget> childrenList = [];

    //guardar el tema del juego en variables locales
    TextEditingController controllertheme = TextEditingController(),
        controllerphrase = TextEditingController();
    controllertheme.text = rondaActual.tema;

    //Si el jugador es el cuentacuentos debe colocar la frase y el tema
    if (indiceDeTrunoDeUsuario == 0) {
      childrenList.add(
          Text('Turno de ${listaDeJugadores[indiceDeTrunoDeUsuario].name}'));
      childrenList.add(      
        Container(
            height: 120.0,
            width: 120.0,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(listaDeJugadores[indiceDeTrunoDeUsuario].icon),
                fit: BoxFit.scaleDown,
              ),
              shape: BoxShape.circle,
            ),
            margin: const EdgeInsets.all(30.0),
            //color: Colors.amber,
            child: Text('', textAlign: TextAlign.center)),);
      childrenList.add(Text('Introduce el tema'));
      childrenList.add(TextField(
        controller: controllertheme,
      ));
    }

    //Si el jugador es un adivinante debe dejar su frase para engañar
    else if (indiceDeTrunoDeUsuario < listaDeJugadores.length) {
      childrenList.add(Container(
        child:
            Text('Turno de ${listaDeJugadores[indiceDeTrunoDeUsuario].name}'),
        alignment: Alignment.center,
      ));
      childrenList.add(      
        Container(
            height: 120.0,
            width: 120.0,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(listaDeJugadores[indiceDeTrunoDeUsuario].icon),
                fit: BoxFit.scaleDown,
              ),
              shape: BoxShape.circle,
            ),
            margin: const EdgeInsets.all(30.0),
            //color: Colors.amber,
            child: Text('', textAlign: TextAlign.center)),);
      childrenList.add(Text('Temas: ${rondaActual.tema}'));
    }

    childrenList.add(Text('Introduce tu frase'));
    childrenList.add(TextField(
      controller: controllerphrase,
    ));

    //pasar al siguiente jugador
    childrenList.add(TextButton(
        onPressed: () => setState(() {
              rondaActual.setFrase(controllerphrase.text);
              rondaActual.setTema(controllertheme.text);
            }),
        child: Text('Pasar al siguiente jugador')));

    //pasamos al siguiente jugador, si se terminan se pasa a la siguiente seccion del loop
    indiceDeTrunoDeUsuario++;
    if (indiceDeTrunoDeUsuario == listaDeJugadores.length) {
      indiceDeTrunoDeUsuario = 1;
      selectorDeIndice = 2;
    }

    return childrenList;
  }

  //GameLoop para la eleccion de la frase
  List<Widget> gameLoopSelected() {
    List<Widget> childrenList = [];

    //generamos una lista random para mezclar las frases
    List<int> random = List.generate(listaDeJugadores.length, (index) => index);
    random.shuffle();

    //verificacion para evitar desastres
    if (indiceDeTrunoDeUsuario < listaDeJugadores.length) {
      childrenList.add(Text(
          'Elije una frase jugador: ${rondaActual.listaJugadores[indiceDeTrunoDeUsuario].name}'));
      childrenList.add(      
        Container(
            height: 120.0,
            width: 120.0,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(listaDeJugadores[indiceDeTrunoDeUsuario].icon),
                fit: BoxFit.scaleDown,
              ),
              shape: BoxShape.circle,
            ),
            margin: const EdgeInsets.all(30.0),
            //color: Colors.amber,
            child: Text('', textAlign: TextAlign.center)),);
    }

    //for que nos dara las frases en distintos ordenes
    for (int i = 0; i < rondaActual.listaDeFrase.length; i++) {
      childrenList.add(TextButton(
          onPressed: () => setState(() {
                rondaActual.listaDeElecciones.add(random[i]);
              }),
          child: Text('${rondaActual.listaDeFrase[random[i]]}')));
    }

    //pasamos al siguiente jugador, cuando todos terminen pasamos a ver los resultados
    indiceDeTrunoDeUsuario++;
    if (indiceDeTrunoDeUsuario == listaDeJugadores.length) {
      indiceDeTrunoDeUsuario = 0;
      selectorDeIndice = 3;
    }

    return childrenList;
  }

  //Resultados
  List<Widget> resultRound() {
    List<Widget> childrenList = [];
    List<Widget> grid = [];

    //Se guarda todo el progreso del juego
    rondaActual.getPuntos();
    listaDeJugadores = rondaActual.getActualizacionDeUsuario();
    mayorPuntaje = rondaActual.getMayorPuntaje();
    guardarJuego = rondaActual.actualizarGuardadoDeJuego(guardarJuego);

    //Se muestra en pantalla los resultados
    for (int i = 0; i < listaDeJugadores.length; i++) {
      
      childrenList.add(      
        Container(
            height: 40.0,
            width: 40.0,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(listaDeJugadores[i].icon),
                fit: BoxFit.scaleDown,
              ),
              shape: BoxShape.circle,
            ),
            margin: const EdgeInsets.all(30.0),
            //color: Colors.amber,
            child: Text('', textAlign: TextAlign.center)),);
      childrenList.add(
                Container(
          alignment: Alignment.center,
          child: SizedBox(
            height: 50,
            // set desired height here
            child: Text('El jugador ${listaDeJugadores[i].name} tiene ${listaDeJugadores[i].points} puntos')
          ),
        ),);
    }

    grid.add(GridView.count(
      crossAxisCount: 2,
      childAspectRatio: ((tamanio.width / 2) /
          ((tamanio.height - kToolbarHeight - 24) / (childrenList.length / 2))),
      shrinkWrap: true,
      children: childrenList,
    ));


    //Botones para regresar o continuar jugando
    if (indiceDeRonda < maximoRondas) {
      grid.add(TextButton(
          onPressed: () => setState(() {}), child: Text('Continuar jugando')));
      grid.add(TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Volver al menu principal'))); //->enviar aqui el savegame
    } else {
      grid.add(TextButton(
          onPressed: () => {
                datamain.getData(guardarJuego),
                Navigator.pop(context),
              },
          child: Text('Terminar partida'))); //->enviar aqui el savegame
    }

    //Reinicio de todas las variables globales
    indiceDeRonda++;
    selectorDeIndice = 1;

    listaDeJugadores.add(listaDeJugadores[0]);
    listaDeJugadores.removeAt(0);

    rondaActual = Ronda(listaDeJugadores, indiceDeRonda);

    print(' ${guardarJuego} \n');

    return grid;
  }
}
