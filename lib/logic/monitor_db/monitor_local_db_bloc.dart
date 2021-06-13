import 'dart:async';

import 'package:andes/data/local/local_database.dart';
import 'package:andes/logic/monitor_db/monitor_db_event.dart';
import 'package:andes/logic/monitor_db/monitor_db_state.dart';
import 'package:andes/model/product.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MonitorLocalBloc extends Bloc<MonitorEvent, MonitorState> {
  StreamSubscription _localSubscription;  // produtos adicionados no carrinho

  List<ProductData> localProductList;
  List<int> localIdList;

  MonitorLocalBloc() : super(MonitorState(productList: [], idList: [])) {
    add(AskNewList());
    _localSubscription = DatabaseLocalServer.helper.stream.listen((response) {
      try {
        localProductList = response[0];
        localIdList = response[1];
        add(UpdateList(
          productList: localProductList,
          idList: localIdList
        ));
      } catch(e) {}
    });
  }

  @override
  Stream<MonitorState> mapEventToState(MonitorEvent event) async* {
    if(event is AskNewList) {
      var localResponse = await DatabaseLocalServer.helper.getItemList();

      localProductList = localResponse[0];
      localIdList = localResponse[1];
      yield MonitorState(
        productList: localProductList,
        idList: localIdList
      );
    } else if(event is UpdateList) {
      yield MonitorState(idList: event.idList, productList: event.productList);
    }
  }

  close() {
    _localSubscription.cancel();
    return super.close();
  }
}