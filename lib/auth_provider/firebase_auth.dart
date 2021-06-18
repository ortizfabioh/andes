import 'package:andes/data/firebase/firebase_database.dart';
import 'package:andes/model/user.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthenticationService {
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Stream<UserModel> get user {
    return _firebaseAuth
      .authStateChanges()
      .map((User user) => _userFromFirebaseUser(user));
  }

  UserModel _userFromFirebaseUser(User user) {
    return user != null ? UserModel(user.uid) : null;
  }

  signInWithEmailAndPassword({String email, String password}) async {
    UserCredential authResult = await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password
    );
    User user = authResult.user;
    return UserModel(user.uid);
  }

  createUserWithEmailAndPassword({String email, String password, String fullName, String address, int state, String phone, String username}) async {
    UserCredential authResult = await _firebaseAuth.createUserWithEmailAndPassword(
      email: email, password: password
    );
    User user = authResult.user;

    FirebaseRemoteServer.helper.includeUserData(user.uid, fullName, address, state, phone, username);

    return UserModel(user.uid);
  }

  includeUserData({String uid, String fullName, String address, int state, String phone, String username}) {
    FirebaseRemoteServer.helper.includeUserData(uid, fullName, address, state, phone, username);
  }

  currentUser() async {
    _firebaseAuth.currentUser;
  }

  signOut() async {
    await _firebaseAuth.signOut();
  }
}