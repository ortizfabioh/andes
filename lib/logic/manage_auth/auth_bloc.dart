import 'dart:async';

import 'package:andes/auth_provider/firebase_auth.dart';
import 'package:andes/data/firebase/firebase_database.dart';
import 'package:andes/logic/manage_auth/auth_event.dart';
import 'package:andes/logic/manage_auth/auth_state.dart';
import 'package:andes/model/user.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  FirebaseAuthenticationService _authenticationService;
  StreamSubscription _authenticationStream;

  AuthBloc() : super(Unauthenticated()) {
    _authenticationService = FirebaseAuthenticationService();
    _authenticationStream = _authenticationService.user.listen((UserModel userModel) {
      add(InnerServerEvent(userModel));
    });
  }

  @override
  Stream<AuthState> mapEventToState(AuthEvent event) async* {
    try {
      if(event == null) {
        yield Unauthenticated();
      } else if(event is RegisterUser) {
        await _authenticationService.createUserWithEmailAndPassword(
            email: event.email,
            password: event.password,
            fullName: event.fullName,
            address: event.address,
            state: event.state,
            phone: event.phone,
            username: event.username
        );
      }
      if(event is LoginUser) {
        await _authenticationService.signInWithEmailAndPassword(
            email: event.email, password: event.password
        );
      } else if(event is InnerServerEvent) {
        if(event.userModel == null) {
          yield Unauthenticated();
        } else {
          FirebaseRemoteServer.uid = event.userModel.uid;
          yield Authenticated(user:event.userModel);
        }
      } else if(event is LogOut) {
        await _authenticationService.signOut();
      }
    } catch(e) {
      yield AuthError(message: e.toString());
    }
  }
}