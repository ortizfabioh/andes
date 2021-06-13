import 'package:andes/logic/manage_auth/auth_bloc.dart';
import 'package:andes/logic/manage_auth/auth_event.dart';
import 'package:andes/logic/manage_db/manage_db_state.dart';
import 'package:andes/logic/manage_db/manage_firebase_db_bloc.dart';
import 'package:andes/view/screens/cart_main.dart';
import 'package:andes/view/screens/login_main.dart';
import 'package:andes/view/screens/products_display.dart';
import 'package:andes/view/screens/profile_main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
            Tab(icon: Icon(Icons.assistant_rounded), text: "Produtos"),
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
            Tab(icon: Icon(Icons.assistant_rounded), text: "Produtos"),
            Tab(icon: Icon(Icons.shopping_cart_sharp), text: "Carrinho"),
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
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection("user").snapshots(),
      builder: (context, snapshot) {
        return Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              Container(
                padding: EdgeInsets.only(top: 50, left: 8, right: 8, bottom: 30),
                color: Colors.brown[300],
                child: Row(children: [
                  RichText(
                    text: TextSpan(children: [
                      TextSpan(
                        //text: "User's full name\n",
                        text: "${snapshot.data.docs[0]["fullName"]}\n",
                        style: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Montserrat', color: Colors.black87, fontSize: 16)
                      ),
                      TextSpan(
                        text: "@${snapshot.data.docs[0]["username"]}",
                        style: TextStyle(fontFamily: 'Montserrat', color: Colors.black54, fontSize: 14)
                      ),
                    ])
                  ),
                ]),
              ),
              Container(
                child: ListTile(
                  leading: Icon(Icons.logout),
                  title: Text("Sair"),
                  onTap: () {
                    BlocProvider.of<AuthBloc>(context).add(LogOut());
                  },
                ),
              )
            ],
          ),
        );
      }
    );
  }
}
