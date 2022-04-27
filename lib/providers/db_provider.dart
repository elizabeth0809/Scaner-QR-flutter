// @dart=2.9
import 'dart:io';
import 'package:path/path.dart';

import 'package:path_provider/path_provider.dart';
import 'package:qr_reader/models/scan_model.dart';
export 'package:qr_reader/models/scan_model.dart';
import 'package:sqflite/sqflite.dart';

class DBProvider {
  static Database _database;
  static final DBProvider db = DBProvider._();

  DBProvider._();

  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await initDB();
    return _database;
  }

  Future<Database> initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, 'ScansDB.db');
    print(path);

    //Crear base de datos
    return await openDatabase(path, version: 1, onOpen: (db) {},
        onCreate: (Database db, int version) async {
      await db.execute('''
CREATE TABLE Scans(
  id INTEGER PRIMARY KEY,
  tipo TEXT,
  valor TEXT
)
''');
    });
  }

  Future<int> nuevoScanRaw(ScanModel nuevoScan) async {
    final id = nuevoScan.id;
    final tipo = nuevoScan.id;
    final valor = nuevoScan.id;

//verificar la base de datos
    final db = await database;
    //insercion de los resultados
    final res = await db.rawInsert('''
INSERT INTO Scans(id,tipo,valor)
VALUES($id, '$tipo','$valor')
''');
    return res;
  }

  Future<int> nuevoScan(ScanModel nuevoScan) async {
    final db = await database;
    //no importa cuantos campos halla en la base de datos inserta todo lo definido ahi
    final res = await db.insert('Scans', nuevoScan.toJson());
    //esto regresa un id del ultimo registro insertado

    return res;
  }

  Future<ScanModel> getScanById(int id) async {
    final db = await database;
    //esto regresara un mapa de la base de datos
    final res = await db.query('Scans', where: 'id= ?', whereArgs: [id]);
    return res.isNotEmpty ? ScanModel.fromJson(res.first) : null;
  }

  Future<List<ScanModel>> getTodosLosScans() async {
    final db = await database;
    //esto regresara un mapa de la base de datos
    final res = await db.query('Scans');
    return res.isNotEmpty
        ? res.map((s) => ScanModel.fromJson(s)).toList()
        : null;
  }

  Future<List<ScanModel>> getScansPorTipo(String tipo) async {
    final db = await database;
    //esto es otra manera de regresar datos de la base de datos
    final res = await db.rawQuery('''
SELECT * FROM Scans WHERE tipo = '$tipo'
''');
    return res.isNotEmpty ? res.map((s) => ScanModel.fromJson(s)).toList() : [];
  }

  Future<int> updateScan(ScanModel nuevoScan) async {
    final db = await database;
    //esto actualizara en la base de datos los registros
    final res = await db.update('Scans', nuevoScan.toJson(),
        where: 'id = ?', whereArgs: [nuevoScan.id]);
    return res;
  }

//esto eliminara registris en la base de datos
  Future<int> deleteScan(int id) async {
    final db = await database;
    final res = await db.delete('Scans', where: 'id = ?', whereArgs: [id]);
    return res;
  }

  //esto eliminara todos los archivos en la base de datos
  Future<int> deleteAllScan() async {
    final db = await database;
    //esta es otra manera de ejecutar el codigo
    final res = await db.rawDelete('''
DELETE FROM Scans
''');
    return res;
  }
}
