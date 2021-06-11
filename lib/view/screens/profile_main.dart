import 'package:andes/model/registry.dart';
import 'package:flutter/material.dart';

class MainProfile extends StatefulWidget {
  @override
  _MainProfileState createState() => _MainProfileState();
}

class _MainProfileState extends State<MainProfile> {
  final GlobalKey<FormState> formKey = new GlobalKey<FormState>();
  final RegistryData registry = new RegistryData();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Alterar dados"),
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Form(
            key: formKey,
            child: Column(children: [
              usernameTextField(),  // Disabled, but showing the username on field
              addressTextField(),
              Column(children: [
                Text("Selecione seu estado:", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                Row(children: [
                  Row(children: [stateRadio(1), Text("SP")]),
                  Row(children: [stateRadio(2), Text("RJ")]),
                  Row(children: [stateRadio(3), Text("MG")]),
                  Row(children: [stateRadio(4), Text("ES")]),
                ]),
              ]),
              phoneTextField(),
              emailTextField(),
              passwordFormField(),
              confirmPasswordFormField(),
              submitButton(),
            ]),
          ),
        ),
      ),
    );
  }

  Widget addressTextField() {
    return TextFormField(
      keyboardType: TextInputType.streetAddress,
      initialValue: "endereço X",
      validator: (String inValue) {
        return (inValue.length == 0) ? "Insira seu endereco" : null;
      },
      onSaved: (String inValue) {
        registry.address = inValue;
      },
      decoration: InputDecoration(
        hintText: "Endereço",
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
      initialValue: "(99)91234-5678",
      validator: (String inValue) {
        return (inValue.length == 0) ? "Insira seu número de telefone" : null;
      },
      onSaved: (String inValue) {
        registry.phone = inValue;
      },
      decoration: InputDecoration(
        hintText: "Telefone",
        labelText: "Seu número de telefone",
      ),
    );
  }

  Widget emailTextField() {
    return TextFormField(
      keyboardType: TextInputType.emailAddress,
      initialValue: "email@gmail.com",
      validator: (String inValue) {
        return (inValue.length == 0) ? "Insira seu E-mail" : null;
      },
      onSaved: (String inValue) {
        registry.email = inValue;
      },
      decoration: InputDecoration(
        hintText: "E-mail",
        labelText: "Seu E-mail",
      ),
    );
  }

  Widget usernameTextField() {
    return TextFormField(
      keyboardType: TextInputType.name,
      enabled: false,
      initialValue: "username",
      decoration: InputDecoration(
        labelText: "Seu nome de usuário",
      ),
    );
  }

  Widget passwordFormField() {
    return TextFormField(
      obscureText: true,
      validator: (String inValue) {
        return (inValue.length < 8) ? "Sua senha deve conter pelo menos 8 dígitos" : null;
      },
      onSaved: (String inValue) {
        registry.password = inValue;
      },
      decoration: InputDecoration(
        labelText: "Insira uma senha forte",
      ),
    );
  }

  Widget confirmPasswordFormField() {
    return TextFormField(
      obscureText: true,
      validator: (String inValue) {
        return null;
        return (inValue.length <= 8) ? "Deve conter 8 dígitos" : null;
        // TODO COMPARE WITH TYPED PASSWORD
      },
      onSaved: (String inValue) {
        registry.password = inValue;
      },
      decoration: InputDecoration(
        labelText: "Digite novamente sua senha",
      ),
    );
  }

  Widget submitButton() {
    return RaisedButton(
      child: Text("Alterar"),
      color: Colors.blue,
      onPressed: () {
        if (formKey.currentState.validate()) {
          validateRegistry();
        }
      },
    );
  }

  snackBar() {
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Dados do suário \"${registry.username}\" alterados com sucesso!"),
          duration: Duration(seconds: 2),
        )
    );
  }

  void validateRegistry() {
    formKey.currentState.save();
    registry.printer();
    Navigator.of(context).pop();
    snackBar();
  }
}
