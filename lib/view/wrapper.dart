import 'package:andes/logic/manage_auth/auth_bloc.dart';
import 'package:andes/logic/manage_auth/auth_state.dart';
import 'package:andes/logic/manage_db/manage_firebase_db_bloc.dart';
import 'package:andes/logic/manage_db/manage_local_db_bloc.dart';
import 'package:andes/logic/monitor_db/monitor_db_bloc.dart';
import 'package:andes/logic/monitor_db/monitor_local_db_bloc.dart';
import 'package:andes/view/navigation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => MonitorBloc()),
        BlocProvider(create: (_) => MonitorLocalBloc()),
        BlocProvider(create: (_) => ManageLocalBloc()),
        BlocProvider(create: (_) => ManageFirebaseBloc()),
      ],
      child: BlocConsumer<AuthBloc, AuthState>(
        builder: (context, state)
          => (state is Authenticated)
            ? NavigationLayoutLogged()
            : NavigationLayoutNotLogged(),
        listener: (context, state) {
          if(state is AuthError) {
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Text("Erro no servidor"),
                  content: Text("${state.message}"),
                  actions: [
                    ElevatedButton(
                      child: Text("OK"),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    )
                  ],
                );
              }
            );
          }
        },
      ),
    );
  }
}
