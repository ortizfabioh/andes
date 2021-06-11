import 'dart:async';
import 'dart:io';

import 'package:andes/model/product.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseLocalServer {
  // Creating Singleton
  static DatabaseLocalServer helper = DatabaseLocalServer._createInstance();
  DatabaseLocalServer._createInstance();

  static Database _database;

  String table = "products";

  Future<Database> get database async {
    if(_database == null) {
      _database = await initializeDatabase();
    }
    return _database;
  }

  Future<Database> initializeDatabase() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path+"products.db";

    var productsDatabase = await openDatabase(path, version: 1, onCreate: _createDb);
    return productsDatabase;
  }

  _createDb(Database db, int newVersion) async {
    await db.execute(
        "Create table $table ("
            "id INTEGER PRIMARY KEY AUTOINCREMENT, "
            "name TEXT, "
            "price INTEGER,"
            "imageSmall TEXT)"
    );
  }

  /**************** CRUD ******************/

  // INSERT
  Future<int> insertItem(ProductData product) async {
    Database db = await this.database;
    int result = await db.insert(table, product.toMap());
    notify();
    return result;
  }

  // SELECT
  Future<List<dynamic>>getItemList() async {
    Database db = await this.database;
    var productMapList = await db.rawQuery("SELECT * FROM $table");

    List<ProductData> productList = [];
    List<int> idList = [];

    for(int i=0; i<productMapList.length; i++) {
      ProductData product = ProductData.fromMap(productMapList[i]);
      productList.add(product);
      idList.add(productMapList[i]["id"]);
    }

    return [productList, idList];
  }

  // DELETE
  Future<int> deleteItem(int productId) async {
    Database db = await this.database;
    int result = await db.rawDelete("DELETE FROM $table WHERE id = $productId");
    notify();
    return result;
  }

  /********** STREAMS ************/

  notify() async {
    if(_controller != null) {
      var response = await getItemList();
      _controller.sink.add(response);
    }
  }

  Stream get stream {
    if(_controller == null) {
      _controller = StreamController.broadcast();
    }
    return _controller.stream.asBroadcastStream();
  }

  dispose() {
    if(!_controller.hasListener) {
      _controller.close();
      _controller = null;
    }
  }

  static StreamController _controller;
}