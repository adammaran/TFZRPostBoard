import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:informatortfzr/Common/PopupMenu.dart';
import 'package:informatortfzr/pages/FullPost.dart';

class CardTypes {
  static final _databaseReference = FirebaseFirestore.instance;

  static Card getStudentCard(
      BuildContext context, DocumentSnapshot snapshot, bool hasPopUp) {
    var popUp;
    if (hasPopUp || FirebaseAuth.instance.currentUser.uid == 'VMNfQCPnl4SR9rKO7RFRC5QIsQC3') popUp = PopUpMenu(snapshot: snapshot);

    return Card(
        child: Column(children: <Widget>[
      ListTile(
        trailing: popUp,
        title: Text(snapshot['title']),
        subtitle: Text(snapshot['authorUsername']),
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => FullPost(snapshot: snapshot)));
        },
      ),
      Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            snapshot['shortDesc'],
            style: TextStyle(fontSize: 18),
          ))
    ]));
  }

  static Card getAdminCard(
      BuildContext context, DocumentSnapshot snapshot, bool hasPopUp) {
    var popUp;
    if (hasPopUp) popUp = PopUpMenu(snapshot: snapshot);

    return Card(
        color: Color(0xffED553B),
        child: Column(children: <Widget>[
          ListTile(
            trailing: popUp,
            title: Text(snapshot['title']),
            subtitle: Text(snapshot['authorUsername']),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => FullPost(snapshot: snapshot)));
            },
          ),
          Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                snapshot['shortDesc'],
                style: TextStyle(fontSize: 18),
              ))
        ]));
  }

  static Card getParlamentCard(
      BuildContext context, DocumentSnapshot snapshot, bool hasPopUp) {
    var popUp;
    if (hasPopUp) popUp = PopUpMenu(snapshot: snapshot);

    return Card(
        color: Color(0xff3CAEA3),
        child: Column(children: <Widget>[
          ListTile(
            trailing: popUp,
            title: Text(snapshot['title']),
            subtitle: Text(snapshot['authorUsername']),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => FullPost(snapshot: snapshot)));
            },
          ),
          Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                snapshot['shortDesc'],
                style: TextStyle(fontSize: 18),
              ))
        ]));
  }

  static Card getOfficeCard(
      BuildContext context, DocumentSnapshot snapshot, bool hasPopUp) {
    var popUp;
    if (hasPopUp) popUp = PopUpMenu(snapshot: snapshot);

    return Card(
        color: Color(0xffF6D55C),
        child: Column(children: <Widget>[
          ListTile(
            trailing: popUp,
            title: Text(snapshot['title']),
            subtitle: Text(snapshot['authorUsername']),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => FullPost(snapshot: snapshot)));
            },
          ),
          Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                snapshot['shortDesc'],
                style: TextStyle(fontSize: 18),
              ))
        ]));
  }

  static Card getProfessorCard(
      BuildContext context, DocumentSnapshot snapshot, bool hasPopUp) {
    var popUp;
    if (hasPopUp) popUp = PopUpMenu(snapshot: snapshot);

    return Card(
        color: Color(0xff20639B),
        child: Column(children: <Widget>[
          ListTile(
            trailing: popUp,
            title: Text(snapshot['title'],
                style: TextStyle(color: Color(0xffEFEFEF))),
            subtitle: Text(snapshot['authorUsername']),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => FullPost(snapshot: snapshot)));
            },
          ),
          Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                snapshot['shortDesc'],
                style: TextStyle(fontSize: 18, color: Color(0xffEFEFEF)),
              ))
        ]));
  }

  static Future getAuthorUsername(String authorId) async {
    return _databaseReference.collection('users').doc(authorId).get();
  }
}
