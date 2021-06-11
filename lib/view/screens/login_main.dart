import 'package:andes/logic/manage_auth/auth_bloc.dart';
import 'package:andes/logic/manage_auth/auth_event.dart';
import 'package:andes/logic/manage_db/manage_firebase_db_bloc.dart';
import 'package:andes/view/navigation.dart';
import 'package:andes/view/screens/registry_main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MainLogin extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return MainLoginState();
  }
}

class MainLoginState extends State<MainLogin> {
  final GlobalKey<FormState> formKey = new GlobalKey<FormState>();
  final LoginUser login = new LoginUser();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Form(
        key: formKey,
        child: Column(
          children: [
            usernameFormField(),
            passwordFormField(),
            Row(
              children: [
                rememberMeFormField(),
                Text("Lembrar senha"),
              ],
            ),
            Text("Não possui uma conta?", style: TextStyle(fontSize: 15)),
            registerButton(),
            submitButton(),
          ],
        ),
      ),
    );
  }

  Widget usernameFormField() {
    return TextFormField(
      keyboardType: TextInputType.emailAddress,
      validator: (String inValue) {
        return (inValue.length == 0) ? "Insira seu nome de usuário" : null;
      },
      onSaved: (String inValue) {
        login.username = inValue;
      },
      decoration: InputDecoration(
          hintText: "Nome de usuário",
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  Widget passwordFormField() {
    return TextFormField(
      obscureText: true,
      validator: (String inValue) {
        return (inValue.length == 0) ? "Senha inválida" : null;
      },
      onSaved: (String inValue) {
        login.password = inValue;
      },
      decoration: InputDecoration(
        hintText: "Senha",
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  Widget rememberMeFormField() {
    return Checkbox(
      value: true,
      onChanged: (bool value) {
        setState(() {
          value = !value;
        });
      },
    );
  }

  Widget registerButton() {
    return TextButton(
      onPressed: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return BlocProvider(create: (_) => ManageFirebaseBloc(),
            child: MainRegistry()
          );
        }));
      },
      child: Text("Clique aqui para se cadastrar!",
        style: TextStyle(color: Colors.blue, fontSize: 15),
      ),
    );
  }

  Widget submitButton() {
    return RaisedButton(
      child: Text("Entrar"),
      color: Colors.green,
      onPressed: () {
        if (formKey.currentState.validate()) {
          NavigationLayoutLogged();
          formKey.currentState.save();
          BlocProvider.of<AuthBloc>(context).add(login);
        }
      },
    );
  }
}