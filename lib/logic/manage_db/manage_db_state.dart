import 'package:andes/model/product.dart';

abstract class ManageState {}

class UpdateState extends ManageState {
  int productId;
  ProductData previousProduct;

  UpdateState({this.productId, this.previousProduct});
}

class InsertState extends ManageState {}