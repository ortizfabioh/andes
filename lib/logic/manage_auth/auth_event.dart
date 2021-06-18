import 'package:andes/model/user.dart';

abstract class AuthEvent {}

class RegisterUser extends AuthEvent {
  String email;
  String password;
  String fullName;
  String address;
  int state;
  String phone;
  String username;
}

class LoginUser extends AuthEvent {
  String email;
  String password;
}

class LoginAnonymousUser extends AuthEvent {}

class LogOut extends AuthEvent {}

class InnerServerEvent extends AuthEvent {
  final UserModel userModel;
  InnerServerEvent(this.userModel);
}