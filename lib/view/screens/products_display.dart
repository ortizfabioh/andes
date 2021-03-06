import 'package:andes/logic/manage_auth/auth_bloc.dart';
import 'package:andes/logic/manage_auth/auth_state.dart';
import 'package:andes/logic/manage_db/manage_db_event.dart';
import 'package:andes/logic/manage_db/manage_db_state.dart';
import 'package:andes/logic/manage_db/manage_local_db_bloc.dart';
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
      builder: (ctx, state) {
        return BlocBuilder<ManageLocalBloc, ManageState>(
          builder: (ctx, stt) {
            return ListView.builder(
              itemCount: productList.length,
              itemBuilder: (context, index) {
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
                        Text("\$ ${productList[index].price}",
                          style: TextStyle(color: Colors.white, fontSize: 14),
                        )
                      ]
                    ),
                    leading: Image.asset('${productList[index].imageSmall}', height: 40,),
                    trailing: GestureDetector(
                      child: Icon(Icons.add_shopping_cart_sharp),
                      onTap: () {
                        if(state is Authenticated) {
                          snackBar(context);
                          addCart(ctx, productList[index]);
                        } else {
                          loginDialog(context);
                        }
                      },
                    ),
                    onTap: () {
                      showBottomSheet(
                        context: context,
                        builder: (_) => detailPage(context, ctx, productList[index], state)
                      );
                    },
                  ),
                );
              }
            );
          }
        );
      }
    );
  }

  Widget detailPage(context, ctx, product, state) {
    return SingleChildScrollView(
      child: Column(children: [
        Image.asset('${product.imageBig}', height: 250,),
        Text("${product.name}",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 35),
        ),
        Text("\$ ${product.price}",
          style: TextStyle(color: Colors.deepOrangeAccent, fontWeight: FontWeight.bold, fontSize: 28),
        ),
        Divider(),
        Text("${product.description}",
          style: TextStyle(color: Colors.black, fontSize: 20),
        ),
        ElevatedButton(
          child: Text("Add to Cart"),
          onPressed: () {
            if(state is Authenticated) {
              snackBar(context);
              addCart(ctx, product);
            } else {
              loginDialog(context);
            }
          },
        ),
      ]),
    );
  }

  snackBar(context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Added to your Shopping cart!"),
        duration: Duration(milliseconds: 500)
      )
    );
  }

  Future<void> loginDialog(context) {
    return showDialog(
      barrierDismissible: true,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("You need to log in first"),
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

addCart(context, product) {
  BlocProvider.of<ManageLocalBloc>(context).add(SubmitEvent(product));
}