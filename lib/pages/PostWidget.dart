import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:informatortfzr/Common/PopupMenu.dart';
import 'package:informatortfzr/models/PostModel.dart';
import 'package:informatortfzr/pages/FullPost.dart';

import 'CardTypes.dart';

class PostWidget extends StatelessWidget {
  final _databaseReference = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Container(
        child: StreamBuilder(
      stream: getFollowingList(),
      builder: (
        context,
        snapshot,
      ) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold();
        } else {
          return StreamBuilder(
              stream: getPostList(snapshot.data['following']),
              builder: (context, snap) {
                if (snap.connectionState == ConnectionState.waiting) {
                  return Center(child: Text('Učitavanje...'));
                } else if (!snap.hasData) {
                  return Center(
                    child: Text('Tabla je prazna'),
                  );
                } else {
                  return new ListView(children:
                      snap.data.docs.map<Widget>((DocumentSnapshot document) {
                    if (document['author'] ==
                        FirebaseAuth.instance.currentUser.uid) {
                      var cardType = document['cardType'];
                      if (cardType == 'student')
                        return CardTypes.getStudentCard(
                            context, document, true);
                      else if (cardType == 'professor')
                        return CardTypes.getProfessorCard(
                            context, document, true);
                      else if (cardType == 'office')
                        return CardTypes.getOfficeCard(context, document, true);
                      else if (cardType == 'parlament')
                        return CardTypes.getParlamentCard(
                            context, document, true);
                      else if (cardType == 'admin')
                        return CardTypes.getAdminCard(context, document, true);
                      else
                        return null;
                    } else {
                      var cardType = document['cardType'];
                      if (cardType == 'student')
                        return CardTypes.getStudentCard(
                            context, document, false);
                      else if (cardType == 'professor')
                        return CardTypes.getProfessorCard(
                            context, document, false);
                      else if (cardType == 'office')
                        return CardTypes.getOfficeCard(
                            context, document, false);
                      else if (cardType == 'parlament')
                        return CardTypes.getParlamentCard(
                            context, document, false);
                      else if (cardType == 'admin')
                        return CardTypes.getAdminCard(context, document, false);
                      else
                        return null;
                    }
                  }).toList());
                }
              });
        }
      },
    ));
  }

  Stream getPostList(List<dynamic> following) {
    return _databaseReference
        .collection('posts')
        .where('author', whereIn: following)
        .orderBy("timestamp", descending: true)
        .snapshots();
  }

  Stream<DocumentSnapshot> getFollowingList() {
    return _databaseReference
        .collection('following')
        .doc(FirebaseAuth.instance.currentUser.uid)
        .snapshots();
  }
}
