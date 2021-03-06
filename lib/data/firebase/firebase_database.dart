import 'package:andes/model/registry.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseRemoteServer {
  static String uid;
  static FirebaseRemoteServer helper = FirebaseRemoteServer._createInstance();
  FirebaseRemoteServer._createInstance();

  final CollectionReference userCollection = FirebaseFirestore.instance.collection("users");

  includeUserData(
    String uid,
    String fullName,
    String address,
    int state,
    String phone,
    String username) async {
    await userCollection.doc(uid).set({
      "fullName": fullName,
      "address": address,
      "state": state,
      "phone": phone,
      "username": username
    });
  }

  List _userListFromSnapshot(QuerySnapshot snapshot) {
    List<RegistryData> userList  = [];
    List<String> idList = [];

    for(var doc in snapshot.docs) {
      RegistryData user = RegistryData.fromMap(doc.data());
      userList.add(user);
      idList.add(doc.id);
    }
    return [userList, idList];
  }

  Future<List<dynamic>>getUserList() async {
    QuerySnapshot snapshot = await userCollection.get();
    return _userListFromSnapshot(snapshot);
  }

  insertUser(RegistryData user) async {
    await userCollection
      .doc(uid)
      .collection("profile")
      .add({"fullName": user.fullName,
        "address": user.address,
        "state": user.state,
        "phone": user.phone,
        "username": user.username})
      .then((a) => print("INSERT successful"))
      .catchError((e) => print("Error on ADD: $e"));
  }

  updateUser(RegistryData user) async {
    await userCollection
      .doc(uid)
      .update({"fullName": user.fullName,
        "address": user.address,
        "state": user.state,
        "phone": user.phone,
        "username": user.username})
      .then((a) => print("UPDATE successful"))
      .catchError((e) => print("Error on UPDATE: $e"));
  }


  Stream get stream {
    return userCollection
      .doc(uid)
      .collection("profile")
      .snapshots()
      .map(_userListFromSnapshot);
  }
}