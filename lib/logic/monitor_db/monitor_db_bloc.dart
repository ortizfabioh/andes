import 'dart:async';

import 'package:andes/data/firebase/firebase_database.dart';
import 'package:andes/data/remote/remote_database.dart';
import 'package:andes/logic/monitor_db/monitor_db_event.dart';
import 'package:andes/logic/monitor_db/monitor_db_state.dart';
import 'package:andes/model/product.dart';
import 'package:andes/model/registry.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MonitorBloc extends Bloc<MonitorEvent, MonitorState> {
  StreamSubscription _remoteSubscription;
  StreamSubscription _firebaseSubscription;

  List<ProductData> remoteProductList;
  List<int> remoteIdList;
  List<RegistryData> firebaseUserList;
  List<String> firebaseIdList;

  MonitorBloc() : super(MonitorState(productList: [], idList: [])) {
    add(AskNewList());
    _remoteSubscription = DatabaseRemoteServer.helper.stream.listen((response) {
      try {
        remoteProductList = response[0];
        remoteIdList = response[1];
        add(UpdateList(productList: remoteProductList, idList: remoteIdList));
      } catch(e) {}
    });
    _firebaseSubscription = FirebaseRemoteServer.helper.stream.listen((response) {
      try {
        firebaseUserList = response[0];
        firebaseIdList = response[1];
        add(UpdateListUser(userList: firebaseUserList, idList: firebaseIdList));
      } catch(e) {}
    });
  }

  @override
  Stream<MonitorState> mapEventToState(MonitorEvent event) async* {
    if(event is AskNewList) {
      var remoteResponse = await DatabaseRemoteServer.helper.getProductList();
      var firebaseResponse = await FirebaseRemoteServer.helper.getUserList();

      remoteProductList = remoteResponse[0];
      remoteIdList = remoteResponse[1];
      firebaseUserList = firebaseResponse[0];
      firebaseIdList = firebaseResponse[1];

      yield MonitorState(productList: remoteProductList, idList: remoteIdList);
    } else if(event is UpdateList) {
      yield MonitorState(idList: event.idList, productList: event.productList);
    }
  }

  close() {
    _remoteSubscription.cancel();
    _firebaseSubscription.cancel();
    return super.close();
  }
}