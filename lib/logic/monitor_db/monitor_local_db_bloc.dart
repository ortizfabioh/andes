import 'dart:async';

import 'package:andes/data/local/local_database.dart';
import 'package:andes/logic/monitor_db/monitor_db_event.dart';
import 'package:andes/logic/monitor_db/monitor_db_state.dart';
import 'package:andes/model/product.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MonitorLocalBloc extends Bloc<MonitorEvent, MonitorState> {
  StreamSubscription _localSubscription;

  List<ProductData> productList;
  List<int> idList;

  MonitorLocalBloc() : super(MonitorState(productList: [], idList: [])) {
    add(AskNewList());
    _localSubscription = DatabaseLocalServer.helper.stream.listen((response) {
      try {
        productList = response[0];
        idList = response[1];
        add(UpdateList(productList: productList, idList: idList));
      } catch(e) {}
    });
  }

  @override
  Stream<MonitorState> mapEventToState(MonitorEvent event) async* {
    if(event is AskNewList) {
      var localResponse = await DatabaseLocalServer.helper.getItemList();

      productList = localResponse[0];
      idList = localResponse[1];

      yield MonitorState(productList: productList, idList: idList);
    } else if(event is UpdateList) {
      yield MonitorState(idList: event.idList, productList: event.productList);
    }
  }

  close() {
    _localSubscription.cancel();
    return super.close();
  }
}