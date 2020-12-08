import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import 'main.dart';

class EditNote extends StatelessWidget {
  final DocumentSnapshot snapshot;

  EditNote({this.snapshot});

  final _titleController = TextEditingController();
  final _shortDescController = TextEditingController();
  final _descController = TextEditingController();

  final _databaseReference = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    _titleController.text = snapshot.data()['title'];
    _shortDescController.text = snapshot.data()['shortDesc'];
    _descController.text = snapshot.data()['desc'];
    return Scaffold(
        appBar: AppBar(
          title: Text('Dodavanje objave'),
          backgroundColor: Colors.red,
        ),
        body: Builder(
            builder: (context) =>
                Container(
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
                            labelText: 'Kratak opis',
                            border: OutlineInputBorder()),
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
                              child: Text('Sačuvaj izmene')))
                    ]))));
  }

  void addPostToDb() async {
    await _databaseReference
        .collection('posts')
        .doc(snapshot.data()['uuid'])
        .update({
      'title': _titleController.text,
      'shortDesc': _shortDescController.text,
      'desc': _descController.text,
    })
        .then((value) => print('Post edited'))
        .catchError((error) => print('Failed to add Post: $error'));
  }
}
