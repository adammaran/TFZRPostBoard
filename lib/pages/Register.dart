import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uuid/uuid.dart';

import 'main.dart';

class RegisterPageState extends StatefulWidget {
  RegisterPage createState() => RegisterPage();
}

class RegisterPage extends State<RegisterPageState> {
  final _emailController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _rePasswordController = TextEditingController();

  final _databaseReference = FirebaseFirestore.instance;

  String userType = 'student';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Register'),
          automaticallyImplyLeading: false,
        ),
        body: Builder(
          builder: (context) => Center(
            child: Column(
              children: <Widget>[
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    icon: Icon(Icons.email),
                    labelText: 'E-mail',
                  ),
                ),
                TextFormField(
                  controller: _usernameController,
                  decoration: const InputDecoration(
                    icon: Icon(Icons.person),
                    labelText: 'Username',
                  ),
                ),
                TextFormField(
                  controller: _passwordController,
                  decoration: const InputDecoration(
                    icon: Icon(Icons.lock),
                    labelText: 'Šifra',
                  ),
                  obscureText: true,
                ),
                TextFormField(
                  controller: _rePasswordController,
                  decoration: const InputDecoration(
                    icon: Icon(Icons.lock),
                    labelText: 'Ponoviti šifru',
                  ),
                  obscureText: true,
                ),
                RaisedButton(
                  onPressed: () async {
                    if (_passwordController.text !=
                        _rePasswordController.text) {
                      showSnackBar(context, 'Šifre nisu iste');
                    } else if (!_emailController.text.endsWith('@tfzr.rs')) {
                      showSnackBar(
                          context, 'Email mora da sadrži \'@tfzr.rs\'');
                    } else {
                      createUser(context);
                    }
                  },
                  child: Text('Registruj se'),
                ),
                ListTile(
                  title: const Text('Student'),
                  leading: Radio(
                    value: 'student',
                    groupValue: userType,
                    onChanged: (String value) {
                      setState(() {
                        userType = value;
                      });
                    },
                  ),
                ),
                ListTile(
                    title: const Text('Profesor'),
                    leading: Radio(
                      value: 'professor',
                      groupValue: userType,
                      onChanged: (String value) {
                        setState(() {
                          userType = value;
                        });
                      },
                    ))
              ],
            ),
          ),
        ));
  }

  Future<void> createUser(BuildContext context) async {
    if (userType == 'student')
      createStudent(context);
    else if (userType == 'professor') addUserToPending();
  }

  Future<void> createStudent(BuildContext context) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: _emailController.text, password: _passwordController.text);
      addUserToDB(context);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {}
    } catch (e) {
      print(e);
      _emailController.text = "";
      _usernameController.text = "";
      _passwordController.text = "";
      _rePasswordController.text = "";
    }
  }

  void addUserToDB(BuildContext context) async {
    await _databaseReference
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser.uid)
        .set({
      'uid': FirebaseAuth.instance.currentUser.uid,
      'username': _usernameController.text,
      'email': _emailController.text,
      'userType': userType,
      'caseSearch': FieldValue.arrayUnion(getKeyWordList())
    });
    Navigator.pushReplacementNamed(context, '/Home');
  }

  void addUserToPending() async {
    await _databaseReference.collection('pending_users').add({
      'email': _emailController.text,
      'password': _passwordController.text,
      'username': _usernameController.text,
      'userType': userType,
      'isApproved': false,
      'caseSearch': FieldValue.arrayUnion(getKeyWordList())
    });
  }


  List<String> getKeyWordList(){
    List<String> keyWords = new List<String>();
    String username = _usernameController.text;
    for(int i = 0; i < _usernameController.text.length; i++){
      keyWords.add(username.substring(0, i+1).toLowerCase());
    }
    return keyWords;
  }

  void showSnackBar(BuildContext context, String text) {
    final snackBar = SnackBar(content: Text(text));
    Scaffold.of(context).showSnackBar(snackBar);
  }
}
