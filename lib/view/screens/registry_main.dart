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
  final RegistryData registry = new RegistryData();
  final RegisterUser authData = new RegisterUser();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ManageFirebaseBloc, ManageState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: Text("Cadastro de usuário"),
          ),
          body: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(children: [
                fullNameTextField(),
                addressTextField(),
                Column(children: [
                  Text("Selecione seu estado:", style: TextStyle(
                      fontSize: 15, fontWeight: FontWeight.bold)),
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
      validator: (String inValue) {
        return (inValue.length == 0) ? "Insira seu nome completo" : null;
      },
      onSaved: (String inValue) {
        registry.fullName = inValue;
      },
      decoration: InputDecoration(
        hintText: "Fulano",
        labelText: "Seu nome completo",
      ),
    );
  }

  Widget addressTextField() {
    return TextFormField(
      keyboardType: TextInputType.streetAddress,
      validator: (String inValue) {
        return (inValue.length == 0) ? "Insira seu endereco" : null;
      },
      onSaved: (String inValue) {
        registry.address = inValue;
      },
      decoration: InputDecoration(
        hintText: "Rua X",
        labelText: "Seu endereço",
      ),
    );
  }

  Widget stateRadio(int value) {
    return Radio(
      value: value,
      groupValue: registry.state,
      onChanged: (int inValue) {
        setState(() {
          registry.state = inValue;
        });
      }
    );
  }

  Widget phoneTextField() {
    return TextFormField(
      keyboardType: TextInputType.phone,
      validator: (String inValue) {
        return (inValue.length == 0) ? "Insira seu número de telefone" : null;
      },
      onSaved: (String inValue) {
        registry.phone = inValue;
      },
      decoration: InputDecoration(
        hintText: "(99)99999-9999",
        labelText: "Seu número de telefone",
      ),
    );
  }

  Widget emailTextField() {
    return TextFormField(
      keyboardType: TextInputType.emailAddress,
      validator: (String inValue) {
        return (inValue.length == 0) ? "Insira seu E-mail" : null;
      },
      onSaved: (String inValue) {
        registry.email = inValue;
        authData.username = inValue;
      },
      decoration: InputDecoration(
        hintText: "fulano@email.com",
        labelText: "Seu E-mail",
      ),
    );
  }

  Widget usernameTextField() {
    return TextFormField(
      keyboardType: TextInputType.name,
      validator: (String inValue) {
        return (inValue.length == 0) ? "Insira seu nome de usuário" : null;
      },
      onSaved: (String inValue) {
        registry.username = inValue;
      },
      decoration: InputDecoration(
        labelText: "Seu nome de usuário",
      ),
    );
  }

  Widget passwordFormField() {
    return TextFormField(
      obscureText: true,
      validator: (String inValue) {
        return null;
      },
      onSaved: (String inValue) {
        registry.password = inValue;
        authData.password = inValue;
      },
      decoration: InputDecoration(
        labelText: "Insira uma senha forte",
      ),
    );
  }

  Widget submitButton(BuildContext context) {
    return RaisedButton(
      child: Text("Entrar"),
      color: Colors.blue,
      onPressed: () {
        if (formKey.currentState.validate()) {
          BlocProvider.of<ManageFirebaseBloc>(context).add(SubmitEventUser(user: registry));
          BlocProvider.of<AuthBloc>(context).add(authData);

          formKey.currentState.save();
          registry.printer();
          Navigator.of(context).pop();
          snackBar();
        }
      },
    );
  }

  snackBar() {
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Usuário \'${registry.username}\' cadastrado com sucesso!"),
          duration: Duration(seconds: 2),
        )
    );
  }
}
