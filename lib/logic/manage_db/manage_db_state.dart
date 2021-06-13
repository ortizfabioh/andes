import 'package:andes/model/product.dart';
import 'package:andes/model/registry.dart';

abstract class ManageState {}

class UpdateState extends ManageState {
  int productId;
  ProductData previousProduct;

  UpdateState({this.productId, this.previousProduct});
}

class UpdateStateUser extends ManageState {
  String userId;
  RegistryData previousUser;

  UpdateStateUser({this.userId, this.previousUser});
}

class InsertState extends ManageState {}