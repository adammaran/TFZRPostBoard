import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:informatortfzr/pages/Login.dart';

class NavDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    if (FirebaseAuth.instance.currentUser.uid ==
        'qanAiL9frfeloxTjULQK1pXu33w1') {
      return getAdminDrawer(context);
    } else
      return getRegularDrawer(context);
  }

  Drawer getAdminDrawer(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.only(top: 30),
        children: <Widget>[
          ListTile(
              leading: Icon(Icons.settings),
              title: Text('Podešavanja'),
              onTap: () {
                Navigator.pushReplacementNamed(context, '/Settings');
              }),
          ListTile(
              leading: Icon(Icons.power_settings_new),
              title: Text('Odjava'),
              onTap: () {
                FirebaseAuth.instance.signOut();
                Navigator.pushReplacementNamed(context, '/Login');
              }),
          Divider(),
          ListTile(
              leading: Icon(Icons.assignment_turned_in),
              title: Text('Zahtevi'),
              onTap: () {
                Navigator.pushReplacementNamed(context, '/TeacherRequests');
              })
        ],
      ),
    );
  }

  Drawer getRegularDrawer(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.only(top: 30),
        children: <Widget>[
          ListTile(
              leading: Icon(Icons.settings),
              title: Text('Podešavanja'),
              onTap: () {}),
          ListTile(
              leading: Icon(Icons.power_settings_new),
              title: Text('Odjava'),
              onTap: () {
                FirebaseAuth.instance.signOut();
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => LoginPage()));
              }),
        ],
      ),
    );
  }
}
