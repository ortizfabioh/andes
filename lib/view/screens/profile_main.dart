import 'package:andes/logic/manage_db/manage_db_event.dart';
import 'package:andes/logic/manage_db/manage_db_state.dart';
import 'package:andes/logic/manage_db/manage_firebase_db_bloc.dart';
import 'package:andes/model/registry.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MainProfile extends StatefulWidget {
  @override
  _MainProfileState createState() => _MainProfileState();
}

class _MainProfileState extends State<MainProfile> {
  final GlobalKey<FormState> formKey = new GlobalKey<FormState>();
  final User userAuth = FirebaseAuth.instance.currentUser;
  bool _passwordVisible = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Profile info (Changeable)")),
      body: BlocBuilder<ManageFirebaseBloc, ManageState>(
        builder: (context, state) {
          return FutureBuilder(
            future: FirebaseFirestore.instance.collection('users').doc(userAuth.uid).get(),
            builder: (ctx, snapshot) {
              Map<String, dynamic> data = snapshot.data.data() as Map<String, dynamic>;
              BlocProvider.of<ManageFirebaseBloc>(context).add(UpdateRequestUser(
                userId: userAuth.uid,
                previousUser: RegistryData.fromMap(data)
              ));
              RegistryData user = (state is UpdateStateUser) ? state.previousUser : new RegistryData();
              return SingleChildScrollView(
                child: Container(
                  child: Form(
                    key: formKey,
                    child: Column(children: [
                      fullNameTextField(data, user),
                      addressTextField(data, user),
                      Column(children: [
                        Text("Select the state you live in:",
                          style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)
                        ),
                        Row(children: [
                          Row(children: [stateRadio(1, user), Text("SP")]),
                          Row(children: [stateRadio(2, user), Text("RJ")]),
                          Row(children: [stateRadio(3, user), Text("MG")]),
                          Row(children: [stateRadio(4, user), Text("ES")]),
                        ]),
                      ]),
                      phoneTextField(data, user),
                      emailTextField(user),
                      usernameTextField(data, user),
                      passwordFormField(data, user),
                      submitButton(context, userAuth.uid, user),
                    ]),
                  ),
                ),
              );
            }
          );
        }
      ),
    );
  }

  Widget fullNameTextField(data, user) {
    return TextFormField(
      keyboardType: TextInputType.name,
      initialValue: "${data['fullName']}",
      validator: (String inValue)
        => (inValue.length == 0) ? "Insert your full name" : null,
      onSaved: (String inValue) {
        user.fullName = inValue;
      },
      decoration: InputDecoration(
        hintText: "John Doe",
        labelText: "Full name",
      ),
    );
  }

  Widget addressTextField(data, user) {
    return TextFormField(
      keyboardType: TextInputType.streetAddress,
      initialValue: "${data['address']}",
      validator: (String inValue)
        => (inValue.length == 0) ? "Insert your address" : null,
      onSaved: (String inValue) {
        user.address = inValue;
      },
      decoration: InputDecoration(
        hintText: "Street X",
        labelText: "Address",
      ),
    );
  }

  Widget stateRadio(int value, RegistryData user) {
    return Radio(
      value: value,
      groupValue: user.state,
      onChanged: (int newValue) {
        setState(() {
          user.state = newValue;
        });
      }
    );
  }

  Widget phoneTextField(data, user) {
    return TextFormField(
      keyboardType: TextInputType.phone,
      initialValue: "${data['phone']}",
      validator: (String inValue)
        => (inValue.length == 0) ? "Insert your phone number" : null,
      onSaved: (String inValue) {
        user.phone = inValue;
      },
      decoration: InputDecoration(
        hintText: "(99)99999-9999",
        labelText: "Phone number",
      ),
    );
  }

  Widget emailTextField(user) {
    return TextFormField(
      keyboardType: TextInputType.emailAddress,
      initialValue: "${userAuth.email}",
      validator: (String inValue)
        => (inValue.length == 0) ? "Insert your E-mail" : null,
      onSaved: (String inValue) {
        user.email = inValue;
        userAuth.updateEmail(inValue);
      },
      decoration: InputDecoration(
        hintText: "Johndoe@email.com",
        labelText: "E-mail",
      ),
    );
  }

  Widget usernameTextField(data, user) {
    return TextFormField(
      keyboardType: TextInputType.name,
      initialValue: "${data['username']}",
      validator: (String inValue)
        => (inValue.length == 0) ? "Insert your username" : null,
      onSaved: (String inValue) {
        user.username = inValue;
      },
      decoration: InputDecoration(
        labelText: "Username",
      ),
    );
  }

  Widget passwordFormField(data, user) {
    return TextFormField(
      obscureText: _passwordVisible,
      validator: (String inValue)
        => (inValue.length != 0 && inValue.length < 6) ? "Your password must have at least 6 characters" : null,
      onSaved: (String inValue) {
        if(inValue.length >= 6) {
          user.password = inValue;
          userAuth.updatePassword(inValue);
        }
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
      )
    );
  }

  Widget submitButton(context, uid, user) {
    return RaisedButton(
      child: Text("Alter info"),
      color: Colors.blue,
      onPressed: () {
        if (formKey.currentState.validate()) {
          BlocProvider.of<ManageFirebaseBloc>(context).add(SubmitEventUser(user: user));

          formKey.currentState.save();
          user.printer();
          Navigator.of(context).pop();
          Navigator.of(context).pop();
          snackBar(context);
        }
      },
    );
  }

  snackBar(context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Data successfully altered!"),
        duration: Duration(seconds: 2)
      )
    );
  }
}
