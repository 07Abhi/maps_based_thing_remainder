import 'dart:io';
import 'package:sqflite/sqflite.dart';
import 'package:newnativeproject/model/listdatamodel.dart';
import 'package:path/path.dart' as path;

class DBmanager {
  Database _database;
  String _dbName = 'remainder2.db';
  String _tableName = 'ramainders2';
  String colitem = 'item';
  String colmessage = 'message';
  String colimagepath = 'imagePath';
  String colid = 'id';
  String coladdress = 'address';
  String colmapurl = 'mapimageUrl';
  String collatitude = 'latitude';
  String collongitude = 'longitude';
  String coldatetime = 'datetime';
  Future _openDb() async {
    if (_database != null) {
      return _database;
    }
    _database = await openDatabase(path.join(await getDatabasesPath(), _dbName),
        version: 1, onCreate: _onCreate);
  }

  _onCreate(Database db, int version) async {
    await db.execute(
        'CREATE TABLE $_tableName($colid INTEGER PRIMARY KEY,$colitem TEXT,$colmessage TEXT,$colimagepath TEXT,$coladdress TEXT,$colmapurl TEXT,$collatitude REAL,$collongitude REAL,$coldatetime TEXT)');
  }

  Future<int> insertData(ListModel listdata) async {
    await _openDb();
    return await _database.insert(_tableName, listdata.toMap());
  }

  Future<List<ListModel>> queryDatabase() async {
    await _openDb();

    List<Map<String, dynamic>> map = await _database.query(_tableName);
    return List.generate(
      map.length,
      (index) => ListModel(
        
          id: map[index]['id'],
          item: map[index]['item'],
          message: map[index]['message'],
          imagePath: File(map[index]['imagePath']),
          address: map[index]['address'],
          mapimageUrl: map[index]['mapimageUrl'],
          latitude: map[index]['latitude'],
          longitude: map[index]['longitude'],
          datetime: map[index]['datetime']),
    );
  }

  Future<int> deleteTile(int condition) async {
    await _openDb();
    return await _database
        .delete(_tableName, where: 'id=?', whereArgs: [condition]);
  }
}
