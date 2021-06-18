import 'package:andes/logic/manage_auth/auth_bloc.dart';
import 'package:andes/logic/manage_db/manage_firebase_db_bloc.dart';
import 'package:andes/view/navigation.dart';
import 'package:andes/view/screens/profile_main.dart';
import 'package:andes/view/wrapper.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<AuthBloc>(
      create: (context) => AuthBloc(),
      child: MaterialApp(
        theme: ThemeData(
          primarySwatch: Colors.brown,
          visualDensity: VisualDensity.adaptivePlatformDensity),
        home: Wrapper(),
        routes: <String, WidgetBuilder>{
          '/profile': (BuildContext context)
            => BlocProvider(
              create: (_) => ManageFirebaseBloc(),
              child: new MainProfile()
            ),
        }
      ),
    );
  }
}