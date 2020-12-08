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
        child: FutureBuilder(
      future: getPostList(),
      builder: (
        context,
        snapshot,
      ) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: Text('Učitavanje...'));
        } else {
          return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (_, index) {
                if (snapshot.data[index].data()['author'] ==
                    FirebaseAuth.instance.currentUser.uid) {
                  var cardType = snapshot.data[index].data()['cardType'];
                  if (cardType == 'student')
                    return CardTypes.getStudentCard(
                        context, snapshot.data[index], true);
                  else if (cardType == 'professor')
                    return CardTypes.getProfessorCard(
                        context, snapshot.data[index], true);
                  else if (cardType == 'office')
                    return CardTypes.getOfficeCard(
                        context, snapshot.data[index], true);
                  else if (cardType == 'parlament')
                    return CardTypes.getParlamentCard(
                        context, snapshot.data[index], true);
                  else if (cardType == 'admin')
                    return CardTypes.getAdminCard(
                        context, snapshot.data[index], true);
                  else
                    return null;
                } else {
                  var cardType = snapshot.data[index].data()['cardType'];
                  if (cardType == 'student')
                    return CardTypes.getStudentCard(
                        context, snapshot.data[index], false);
                  else if (cardType == 'professor')
                    return CardTypes.getProfessorCard(
                        context, snapshot.data[index], false);
                  else if (cardType == 'office')
                    return CardTypes.getOfficeCard(
                        context, snapshot.data[index], false);
                  else if (cardType == 'parlament')
                    return CardTypes.getParlamentCard(
                        context, snapshot.data[index], false);
                  else if (cardType == 'admin')
                    return CardTypes.getAdminCard(
                        context, snapshot.data[index], false);
                  else
                    return null;
                }
              });
        }
      },
    ));
  }

  Future getPostList() async {
    QuerySnapshot qn = await _databaseReference
        .collection('posts')
        .orderBy("timestamp", descending: true)
        .get();
    return qn.docs;
  }
}
