import 'package:andes/auth_provider/firebase_auth.dart';
import 'package:andes/logic/manage_auth/auth_bloc.dart';
import 'package:andes/logic/manage_auth/auth_event.dart';
import 'package:andes/logic/manage_db/manage_db_event.dart';
import 'package:andes/logic/manage_db/manage_db_state.dart';
import 'package:andes/logic/manage_db/manage_firebase_db_bloc.dart';
import 'package:andes/model/registry.dart';
import 'package:andes/model/user.dart';
import 'package:andes/view/screens/cart_main.dart';
import 'package:andes/view/screens/login_main.dart';
import 'package:andes/view/screens/products_display.dart';
import 'package:andes/view/screens/profile_main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NavigationLayoutNotLogged extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      initialIndex: 0,
      child: Scaffold(
        appBar: AppBar(
          title: Image.asset('assets/logo.gif', height: 40),
          bottom: TabBar(tabs: [
            Tab(icon: Icon(Icons.account_circle), text: "Login"),
            Tab(icon: Icon(Icons.coffee_rounded), text: "Products"),
          ]),
        ),
        body: TabBarView(children: [
          MainLogin(),
          MainProducts(),
        ]),
      ),
    );
  }
}

class NavigationLayoutLogged extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      initialIndex: 0,
      child: Scaffold(
        appBar: AppBar(
          title: Image.asset('assets/logo.gif', height: 40,),
          bottom: TabBar(tabs: [
            Tab(icon: Icon(Icons.coffee_rounded), text: "Products"),
            Tab(icon: Icon(Icons.shopping_cart_sharp), text: "Shopping Cart"),
          ]),
        ),
        body: TabBarView(children: [
          MainProducts(),
          MainCart(),
        ]),
        drawer: MyDrawer(),
      ),
    );
  }
}

class MyDrawer extends StatelessWidget {
  final User userAuth = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: FutureBuilder(
        future: FirebaseFirestore.instance.collection('users').doc(userAuth.uid).get(),
        builder: (context, snapshot) {
          Map<String, dynamic> data = snapshot.data.data() as Map<String, dynamic>;
          return ListView(
            padding: EdgeInsets.zero,
            children: [
              Container(
                padding: EdgeInsets.only(top: 50, left: 8, right: 8, bottom: 30),
                color: Colors.brown[300],
                child: Row(children: [
                  RichText(
                    text: TextSpan(children: [
                      TextSpan(
                        text: "${data['fullName']}\n",
                        style: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Montserrat', color: Colors.black87, fontSize: 16)
                      ),
                      TextSpan(
                        text: "@${data['username']}",
                        style: TextStyle(fontFamily: 'Montserrat', color: Colors.black54, fontSize: 14)
                      ),
                    ])
                  ),
                ]),
              ),
              Container(
                child: Column(children: [
                  ListTile(
                    leading: Icon(Icons.account_box),
                    title: Text("Profile info"),
                    onTap: () {
                      Navigator.of(context).pushNamed('/profile');
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.logout),
                    title: Text("Log Out"),
                    onTap: () {
                      BlocProvider.of<AuthBloc>(context).add(LogOut());
                    },
                  ),
                ]),
              ),
            ]
          );
        }
      ),
    );
  }
}
