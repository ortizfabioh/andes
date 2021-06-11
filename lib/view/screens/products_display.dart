import 'package:andes/logic/manage_auth/auth_bloc.dart';
import 'package:andes/logic/manage_auth/auth_state.dart';
import 'package:andes/logic/monitor_db/monitor_db_bloc.dart';
import 'package:andes/logic/monitor_db/monitor_db_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MainProducts extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MonitorBloc, MonitorState>(
      builder: (context, state) => listView(state.productList, state.idList)
    );
  }

  Widget listView(productList, idList) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (BuildContext ctx, AuthState state) {
        return ListView.builder(
          itemCount: productList.length,
          itemBuilder: (context, index){
            return Card(
              color: Colors.brown[300],
              elevation: 4,
              child: ListTile(
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("${productList[index].name}",
                      style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    Text(
                      "\$ ${productList[index].price}",
                      style: TextStyle(color: Colors.white, fontSize: 14),
                    )
                  ]
                ),
                leading: Image.asset(
                  '${productList[index].imageSmall}',
                    height: 40,
                ),
                trailing: GestureDetector(
                  child: Icon(Icons.add_shopping_cart_sharp),
                  onTap: () {
                    if(state is Authenticated) {
                      snackBar(context);
                      addCart();
                    } else {
                      loginDialog(context);
                    }
                  },
                ),
                onTap: () {
                  showBottomSheet(
                    context: context,
                    builder: (_) {
                      return detailPage(context, productList, index, state);
                    }
                  );
                },
              ),
            );
          }
        );
      }
    );
  }

  Widget detailPage(BuildContext context, productList, int index, AuthState state) {
    return SingleChildScrollView(
      child: Expanded(
        child: Column(
          children: [
            Image.asset('${productList[index].imageBig}', height: 250,),
            Text(
              "${productList[index].name}",
              style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 35),
            ),
            Text(
              "Por \$${productList[index].price}",
              style: TextStyle(color: Colors.deepOrangeAccent, fontWeight: FontWeight.bold, fontSize: 20),
            ),
            Divider(),
            Text(
              "${productList[index].description}",
              style: TextStyle(color: Colors.black, fontSize: 20),
            ),
            ElevatedButton(
              child: Text("Adicionar ao carrinho"),
              onPressed: () {
                if(state is Authenticated) {
                  snackBar(context);
                  addCart();
                } else {
                  loginDialog(context);
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  snackBar(context) {
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Adicionado ao carrinho"),
          duration: Duration(seconds: 2)
        )
    );
  }

  Future<void> loginDialog(BuildContext context) {
    return showDialog(
      barrierDismissible: true,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Você precisa se logar antes"),
          actions: [
            TextButton(
              child: Text("Ok"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
        );
      }
    );
  }
}

void addCart() {
  //TODO ADD PRODUCT TO CART PAGE (LOCAL DB)
}