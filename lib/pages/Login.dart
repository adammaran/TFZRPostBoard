import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:informatortfzr/pages/Register.dart';
import 'package:informatortfzr/pages/main.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
        automaticallyImplyLeading: false,
      ),
      body: Builder(
          builder: (context) => Center(
                child: Column(children: <Widget>[
                  TextFormField(
                    controller: _emailController,
                    validator: (value) {
                      if (!value.endsWith('@tfzr.rs')) {
                        return 'Email mora da bude @tfzr.rs';
                      } else
                        return null;
                    },
                    decoration: const InputDecoration(
                      icon: Icon(Icons.email),
                      labelText: 'E-mail',
                    ),
                  ),
                  TextFormField(
                    controller: _passwordController,
                    validator: (value) {
                      if (value.length <= 6) {
                        return 'Uneti više od 6 karaktera';
                      } else
                        return null;
                    },
                    decoration: const InputDecoration(
                        icon: Icon(Icons.lock), labelText: 'Password'),
                    obscureText: true,
                  ),
                  RaisedButton(
                    onPressed: () {
                      loginUser(context);
                    },
                    child: Text('Login'),
                  ),
                  RichText(
                      text: TextSpan(children: <TextSpan>[
                    TextSpan(
                        text: 'Kreirajte novi nalog',
                        style: TextStyle(color: Colors.blue),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Navigator.pushReplacementNamed(context, '/Register');
                          })
                  ]))
                ]),
              )),
    );
  }

  void loginUser(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _emailController.text, password: _passwordController.text);
      Navigator.pushReplacementNamed(context, '/Home');
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        final snackBar = SnackBar(content: Text('Korisnik nije pronadjen'));
        Scaffold.of(context).showSnackBar(snackBar);
      } else if (e.code == 'wrong-password') {
        final snackBar = SnackBar(content: Text('Pogrešna šifra'));
        Scaffold.of(context).showSnackBar(snackBar);
      }
    }
  }
}
