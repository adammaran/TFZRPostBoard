import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:informatortfzr/pages/EditNote.dart';

class PopUpMenu extends StatelessWidget {
  final DocumentSnapshot snapshot;
  final int index;

  PopUpMenu({this.snapshot, this.index});

  BuildContext context;

  void showMenuSelection(String value) {
    switch (value) {
      case 'Delete':
        deletePost();
        break;
      case 'Edit':
        editPost();
        break;
    }
  }

  Future<void> editPost() async {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => EditNote(snapshot: snapshot)));
  }

  Future<void> deletePost() async {
    FirebaseFirestore.instance
        .collection('posts')
        .doc(snapshot.id)
        .delete();
  }

  @override
  Widget build(BuildContext context) {
    this.context = context;
    return PopupMenuButton<String>(
      padding: EdgeInsets.zero,
      icon: Icon(Icons.more_vert),
      onSelected: showMenuSelection,
      itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
        const PopupMenuItem<String>(
            value: 'Delete', child: ListTile(title: Text('Obriši'))),
        const PopupMenuItem(
            value: 'Edit', child: ListTile(title: Text('Izmeni')))
      ],
    );
  }
}
