import 'dart:async';

import 'package:andes/model/product.dart';
import 'package:dio/dio.dart';
import 'package:socket_io_client/socket_io_client.dart';

class DatabaseRemoteServer {
  // Creating Singleton
  static DatabaseRemoteServer helper = DatabaseRemoteServer._createInstance();
  DatabaseRemoteServer._createInstance();

  String databaseUrl = "https://andes-mobile.herokuapp.com/products";

  Dio _dio = Dio();

  Future<List<dynamic>>getProductList() async {
    Response response = await _dio.request(
        this.databaseUrl,
        options: Options(method: "GET", headers: {"Accept": "application/json"})
    );

    List<ProductData> productList = [];
    List<int> idList = [];

    response.data.forEach(
      (element) {
        ProductData product = ProductData.fromMap(element);
        productList.add(product);
        idList.add(element["id"]);
      }
    );
    return [productList, idList];
  }


  ///************ STREAM *************/
  notify() async {
    if(_controller != null) {
      var response = await getProductList();
      _controller.sink.add(response);
    }
  }

  Stream get stream {
    if(_controller == null) {
      _controller = StreamController.broadcast();

      Socket socket = io(
          "https://andes-mobile.herokuapp.com/products",
          OptionBuilder().setTransports(["websocket"]).build()
      );
      socket.on("invalidate", (_) => notify());
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