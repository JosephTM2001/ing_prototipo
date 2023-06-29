import 'package:flutter/material.dart';
import 'package:ing_prototipo/Screens_Game/screen_home.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material App',
      home: Screen_home(),
    );
  }
}

