import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import '../models/modelo.dart';

class DatabaseHelper {

  DatabaseHelper._privateConstructor(); // Name constructor to create instance of database
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;

  Future<Database> get database async {
    _database ??= await initializeDatabase();
    return _database!;
  }

  Future<Database> initializeDatabase() async {

    Directory directory = await getApplicationDocumentsDirectory();
    String path = '${directory.path}/despesa.db';

    var despesaDatabase = await openDatabase(
      path,
      version: 1,
      onCreate: _createDb,
    );

    return despesaDatabase;
  }

  void _createDb(Database db, int newVersion) async {
    await db.execute('''Create TABLE despesa (
                  id INTEGER PRIMARY KEY AUTOINCREMENT,
                  data TEXT,
                  categoria TEXT,
                  tipo TEXT,
                  concepte TEXT,
                  quantitat INTEGER,
                  km INTEGER )
    
    ''');
  }
  void setDespesa(data,categoria,tipo,concepte,quantitat,km){
    Despesa().setDespesa2(data,categoria, tipo,concepte,quantitat,km);
    insertDespesa(Despesa());
  }
  void actualizarDespesa(id,data,categoria,tipo,concepte,quantitat,km){
    Despesa().updateDespesa(id, data,categoria,tipo,concepte,quantitat,km);
    updateDespesa(Despesa());
  }
  Future<int> insertDespesa(Despesa despesa) async {

    Database db = await instance.database;
    int result = await db.insert('despesa', despesa.toMap());
    return result;
  }

  Future<List<Despesa>> getAllDespesa() async {
    List<Despesa> despeses = [];

    Database db = await instance.database;

    List<Map<String, dynamic>> listMap = await db.query('despesa');

    for (var despesaMap in listMap) {
      Despesa despesa = Despesa.fromMap(despesaMap);
      despeses.add(despesa);

    }

    return despeses;
  }


  // delete
  Future<int> deleteDespesa(int id) async {
    Database db = await instance.database;
    int result = await db.delete('despesa', where: 'id=?', whereArgs: [id]);
    return result;
  }

  // update
  Future<int> updateDespesa(Despesa despesa) async {
    Database db = await instance.database;
    int result = await db.update('despesa', despesa.toMap(), where: 'id=?', whereArgs: [despesa.id]);
    return result;
  }

}
