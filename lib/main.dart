import 'package:dogs_db_pseb_bridge/vista/afegir_screen.dart';
import 'package:flutter/material.dart';
import '../vista/orden_lista_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CRUD UF1 DAM2 Sergio Hernandez',
      theme: ThemeData(

        primarySwatch: Colors.blue,
      ),
      home: const ListaDespeses(),
    );
  }
}
