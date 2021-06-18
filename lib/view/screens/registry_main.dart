import 'package:andes/logic/manage_auth/auth_bloc.dart';
import 'package:andes/logic/manage_auth/auth_event.dart';
import 'package:andes/logic/manage_db/manage_db_event.dart';
import 'package:andes/logic/manage_db/manage_db_state.dart';
import 'package:andes/logic/manage_db/manage_firebase_db_bloc.dart';
import 'package:andes/model/registry.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MainRegistry extends StatefulWidget {
  @override
  _MainRegistryState createState() => _MainRegistryState();
}

class _MainRegistryState extends State<MainRegistry> {
  final GlobalKey<FormState> formKey = new GlobalKey<FormState>();
  final RegisterUser authData = new RegisterUser();
  bool _passwordVisible = true;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ManageFirebaseBloc, ManageState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(title: Text("User Registry"),),
          body: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(children: [
                fullNameTextField(),
                addressTextField(),
                Column(children: [
                  Text("Select the state you live in:",
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)
                  ),
                  Row(children: [
                    Row(children: [stateRadio(1), Text("SP")]),
                    Row(children: [stateRadio(2), Text("RJ")]),
                    Row(children: [stateRadio(3), Text("MG")]),
                    Row(children: [stateRadio(4), Text("ES")]),
                  ]),
                ]),
                phoneTextField(),
                emailTextField(),
                usernameTextField(),
                passwordFormField(),
                submitButton(context),
              ]),
            )
          ),
        );
      }
    );
  }

  Widget fullNameTextField() {
    return TextFormField(
      keyboardType: TextInputType.name,
      validator: (String inValue) =>
        (inValue.length == 0) ? "Insert your full name" : null,
      onSaved: (String inValue) {
        authData.fullName = inValue;
      },
      decoration: InputDecoration(
        hintText: "John Doe",
        labelText: "Full name",
      ),
    );
  }

  Widget addressTextField() {
    return TextFormField(
      keyboardType: TextInputType.streetAddress,
      validator: (String inValue) =>
        (inValue.length == 0) ? "Insert your address" : null,
      onSaved: (String inValue) {
        authData.address = inValue;
      },
      decoration: InputDecoration(
        hintText: "X Street",
        labelText: "Address",
      ),
    );
  }

  Widget stateRadio(int value) {
    return Radio(
      value: value,
      groupValue: authData.state,
      onChanged: (int inValue) {
        setState(() {
          authData.state = inValue;
        });
      }
    );
  }

  Widget phoneTextField() {
    return TextFormField(
      keyboardType: TextInputType.phone,
      validator: (String inValue)
        => (inValue.length == 0) ? "Insert your phone number" : null,
      onSaved: (String inValue) {
        authData.phone = inValue;
      },
      decoration: InputDecoration(
        hintText: "(99)99999-9999",
        labelText: "Phone number",
      ),
    );
  }

  Widget emailTextField() {
    return TextFormField(
      keyboardType: TextInputType.emailAddress,
      validator: (String inValue)
        => (inValue.length == 0) ? "Insert an E-mail" : null,
      onSaved: (String inValue) {
        authData.email = inValue;
      },
      decoration: InputDecoration(
        hintText: "johndoe@email.com",
        labelText: "E-mail",
      ),
    );
  }

  Widget usernameTextField() {
    return TextFormField(
      keyboardType: TextInputType.name,
      validator: (String inValue)
        => (inValue.length == 0) ? "Insert an username" : null,
      onSaved: (String inValue) {
        authData.username = inValue;
      },
      decoration: InputDecoration(
        labelText: "Username",
      ),
    );
  }

  Widget passwordFormField() {
    return TextFormField(
      obscureText: _passwordVisible,
      validator: (String inValue)
        => (inValue.length < 6) ? "Your password must have at least 6 characters" : null,
      onSaved: (String inValue) {
        authData.password = inValue;
      },
      decoration: InputDecoration(
        labelText: "Password",
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

  Widget submitButton(BuildContext context) {
    return RaisedButton(
      child: Text("Register"),
      color: Colors.blue,
      onPressed: () {
        if(formKey.currentState.validate()) {
          BlocProvider.of<AuthBloc>(context).add(authData);

          formKey.currentState.save();
          Navigator.of(context).pop();
          snackBar();
        }
      },
    );
  }

  snackBar() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("User \'${authData.username}\' successfully registered!"),
        duration: Duration(seconds: 2),
      )
    );
  }
}
