import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:linkwell/linkwell.dart';

import 'UserProfileWidget.dart';

class FullPost extends StatelessWidget {
  final DocumentSnapshot snapshot;

  FullPost({this.snapshot});

  @override
  Widget build(BuildContext context) {
    var post = snapshot.data();

    return Scaffold(
      appBar: AppBar(
        title: Text(post['title']),
        backgroundColor: Colors.red,
      ),
      body: Builder(
          builder: (context) => Center(
              child: Column(
                children: <Widget>[
                  Text(post['title'],
                  style: TextStyle(
                      fontSize: 28, height: 1.5, color: Colors.black87)),
                  InkWell(
                    child: Text('Autor: ' + post['authorUsername'],
                        style: TextStyle(
                            fontSize: 18, height: 1.5, color: Colors.black87, decoration: TextDecoration.underline)),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => UserProfile(post['author']))
                      );
                    },
                  ),
                  SizedBox(height: 20),
                  LinkWell(post['desc'],
                      style: TextStyle(
                          fontSize: 22, height: 1.5, color: Colors.black87))
                ],
              ))),
    );
  }
}
