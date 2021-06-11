import 'package:andes/logic/manage_auth/auth_bloc.dart';
import 'package:andes/logic/manage_auth/auth_state.dart';
import 'package:andes/logic/monitor_db/monitor_db_bloc.dart';
import 'package:andes/view/navigation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => MonitorBloc(),
      child: BlocConsumer<AuthBloc, AuthState>(
        builder: (BuildContext context, AuthState state) {
          if(state is Authenticated) {
            return NavigationLayoutLogged();
          } else {
            return NavigationLayoutNotLogged();
          }
        },
        listener: (context, state) {
          if(state is AuthError) {
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Text("Erro no servidor"),
                  content: Text("${state.message}"),
                  actions: [ElevatedButton(
                    child: Text("OK"),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  )],
                );
              }
            );
          }
        },
      ),
    );
  }
}
