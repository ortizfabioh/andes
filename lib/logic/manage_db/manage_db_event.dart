import 'package:andes/model/product.dart';
import 'package:andes/model/registry.dart';

abstract class ManageEvent {}

class DeleteEvent extends ManageEvent {
  var id;
  DeleteEvent({this.id});
}

class UpdateRequest extends ManageEvent {
  int productId;
  ProductData previousProduct;

  UpdateRequest({this.productId, this.previousProduct});
}

class UpdateRequestUser extends ManageEvent {
  String userId;
  RegistryData previousUser;

  UpdateRequestUser({this.userId, this.previousUser});
}

class SubmitEvent extends ManageEvent {
  ProductData product;
  SubmitEvent(this.product);
}
class SubmitEventUser extends ManageEvent {
  RegistryData user;
  SubmitEventUser({this.user});
}