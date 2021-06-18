import 'package:andes/logic/manage_auth/auth_bloc.dart';
import 'package:andes/logic/manage_auth/auth_event.dart';
import 'package:andes/logic/manage_db/manage_firebase_db_bloc.dart';
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
  bool _passwordVisible = true;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Form(
        key: formKey,
        child: Column(children: [
          usernameFormField(),
          passwordFormField(),
          Row(children: [
            rememberMeFormField(),
            Text("Remember password"),
          ]),
          Text("Doesn\'t have an account yet?", style: TextStyle(fontSize: 15)),
          registerButton(),
          submitButton(),
        ]),
      ),
    );
  }

  Widget usernameFormField() {
    return TextFormField(
      keyboardType: TextInputType.emailAddress,
      validator: (String inValue)
        => (inValue.length == 0) ? "Insert your username" : null,
      onSaved: (String inValue) {
        login.email = inValue;
      },
      decoration: InputDecoration(
        hintText: "User (E-mail)",
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  Widget passwordFormField() {
    return TextFormField(
      obscureText: _passwordVisible,
      validator: (String inValue)
        => (inValue.length == 0) ? "Incorrect password" : null,
      onSaved: (String inValue) {
        login.password = inValue;
      },
      decoration: InputDecoration(
        hintText: "Password",
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        suffixIcon: IconButton(
          icon: Icon(_passwordVisible ? Icons.visibility : Icons.visibility_off,
            color: Theme.of(context).primaryColorDark,
          ),
          onPressed: () {
            setState(() {
              _passwordVisible = !_passwordVisible;
            });
          },
        ),
      ),
    );
  }

  Widget rememberMeFormField() {
    bool state = true;
    return Checkbox(
      value: state,
      onChanged: (bool value) {
        setState(() {
          state = !value;
        });
      },
    );
  }

  Widget registerButton() {
    return TextButton(
      onPressed: () {
        Navigator.push(context, MaterialPageRoute(builder: (context)
          => BlocProvider(create: (_) => ManageFirebaseBloc(),
            child: MainRegistry()
          )
        ));
      },
      child: Text("Click here to register!",
        style: TextStyle(color: Colors.blue, fontSize: 15),
      ),
    );
  }

  Widget submitButton() {
    return RaisedButton(
      child: Text("Log in"),
      color: Colors.green,
      onPressed: () {
        if (formKey.currentState.validate()) {
          formKey.currentState.save();
          BlocProvider.of<AuthBloc>(context).add(login);
        }
      },
    );
  }
}