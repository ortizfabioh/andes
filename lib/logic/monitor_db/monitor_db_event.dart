import 'package:andes/model/product.dart';
import 'package:andes/model/registry.dart';

abstract class MonitorEvent {}

class AskNewList extends MonitorEvent {}

class UpdateList extends MonitorEvent {
  List<ProductData> productList;
  List<int> idList;

  UpdateList({this.productList, this.idList});
}

class UpdateListUser extends MonitorEvent {
  List<RegistryData> userList;
  List<String> idList;

  UpdateListUser({this.userList, this.idList});
}