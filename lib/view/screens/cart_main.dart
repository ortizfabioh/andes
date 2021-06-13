import 'package:andes/logic/manage_db/manage_db_event.dart';
import 'package:andes/logic/manage_db/manage_local_db_bloc.dart';
import 'package:andes/logic/monitor_db/monitor_db_bloc.dart';
import 'package:andes/logic/monitor_db/monitor_db_state.dart';
import 'package:andes/logic/monitor_db/monitor_local_db_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MainCart extends StatefulWidget {
  @override
  _MainCartState createState() => _MainCartState();
}

class _MainCartState extends State<MainCart> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MonitorLocalBloc, MonitorState>(
      builder: (context, state) => listView(state.productList, state.idList)
    );
  }

  Widget listView(productList, idList) {
    if(productList.length == 0) {
      return Container(
        child: Text("Não há produtos no carrinho no momento",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 30),
          textAlign: TextAlign.center,
        ),
      );
    } else {
      var total = 0;
      for(var product in productList) {
        total += product.price;
      }
      return CustomScrollView(slivers: [
        SliverList(
          delegate: SliverChildListDelegate([
            ListView.builder(
              shrinkWrap: true,
              itemCount: productList.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("${productList[index].name}",
                        style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      Text("\$ ${productList[index].price}",
                        style: TextStyle(color: Colors.grey[700], fontSize: 14),
                      )
                    ]
                  ),
                  leading: Image.asset('${productList[index].imageSmall}', height: 40),
                  trailing: GestureDetector(
                    child: Icon(Icons.delete),
                    onTap: () {
                      BlocProvider.of<ManageLocalBloc>(context).add(DeleteEvent(id: idList[index]));
                    },
                  )
                );
              }
            ),
          ]),
        ),
        SliverFillRemaining(
          hasScrollBody: false,
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Row(children: [
              Text("Total: $total  ",
                style: (TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 26)),
              ),
              RaisedButton(
                child: Text("Finalizar compra"),
                color: Colors.green,
                onPressed: () {
                  snackBar(context);
                  for(int i=0; i<productList.length; i++) {
                    BlocProvider.of<ManageLocalBloc>(context).add(DeleteEvent(id: idList[i]));
                  }
                },
              )
            ]),
          )
        )
      ]);
    }
  }

  snackBar(context) {
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Vendido!"), duration: Duration(seconds: 2))
    );
  }
}