import 'package:flutter/material.dart';
import 'package:ing_prototipo/Screens_Game/Sistema.dart';
import 'package:ing_prototipo/Screens_Game/Sala.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material App',
      home: Sala(),
    );
  }
}
