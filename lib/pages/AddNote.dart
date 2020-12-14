import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'main.dart';

class AddNote extends StatelessWidget {
  final _titleController = TextEditingController();
  final _shortDescController = TextEditingController();
  final _descController = TextEditingController();

  final _databaseReference = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Dodavanje objave'),
          backgroundColor: Colors.red,
        ),
        body: Builder(
            builder: (context) => Container(
                margin: EdgeInsets.only(
                    left: 30.0, top: 20.0, right: 30.0, bottom: 20.0),
                child: Column(children: <Widget>[
                  TextFormField(
                    controller: _titleController,
                    maxLength: 30,
                    maxLines: 1,
                    decoration: InputDecoration(
                        labelText: 'Naslov', border: OutlineInputBorder()),
                  ),
                  TextFormField(
                    controller: _shortDescController,
                    maxLength: 30,
                    maxLines: 2,
                    decoration: InputDecoration(
                        labelText: 'Kratak opis', border: OutlineInputBorder()),
                  ),
                  TextFormField(
                    controller: _descController,
                    maxLength: 150,
                    maxLines: 10,
                    decoration: InputDecoration(
                        labelText: 'Opis', border: OutlineInputBorder()),
                  ),
                  Align(
                      alignment: Alignment.centerRight,
                      child: RaisedButton(
                          onPressed: () {
                            addPostToDb();
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => MyHomePage()));
                          },
                          child: Text('Objavi')))
                ]))));
  }

  void addPostToDb() async {
    _databaseReference
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser.uid)
        .get()
        .then((value) {
      _databaseReference
          .collection('posts')
          .add({
            'title': _titleController.text,
            'shortDesc': _shortDescController.text,
            'desc': _descController.text,
            'author': FirebaseAuth.instance.currentUser.uid,
            'authorUsername': value['username'],
            'cardType': value['userType'],
            'timestamp': Timestamp.now()
          })
          .then((value) {
            _databaseReference.collection('posts').doc(value.id).update({
              'id': value.id
            });
            print('Post added to db under: ');}
            )
          .catchError((error) => print('Failed to add Post: $error'));
    });
  }
}
