import 'package:andes/logic/manage_db/manage_db_event.dart';
import 'package:andes/logic/manage_db/manage_local_db_bloc.dart';
import 'package:andes/logic/monitor_db/monitor_db_bloc.dart';
import 'package:andes/logic/monitor_db/monitor_db_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MainCart extends StatefulWidget {
  @override
  _MainCartState createState() => _MainCartState();
}

class _MainCartState extends State<MainCart> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MonitorBloc, MonitorState>(
      builder: (context, state) {
        return listView(state.productList, state.idList);
      }
    );
  }

  Widget listView(productList, idList) {
    print("productList: $productList");
    print("idList: $idList");
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
      return Column(children: [
        ListView.builder(
          itemCount: productList.length,
          itemBuilder: (context, index) {
            return ListTile(
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
                child: Icon(Icons.delete),
                onTap: () {
                  BlocProvider.of<ManageLocalBloc>(context).add(DeleteEvent(productId: idList[index]));
                },
              )
            );
          }
        ),
        Row(children: [
          Text("Total: $total   ",
              style: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold)
          ),
          RaisedButton(child: Text("Finalizar compra"), color: Colors.green, onPressed: () {},)
        ])
      ]);
    }
  }
}