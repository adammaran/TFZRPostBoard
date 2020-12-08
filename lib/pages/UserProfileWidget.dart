import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'file:///C:/Android/informator_tfzr/lib/pages/CardTypes.dart';

class UserProfile extends StatelessWidget {
  final _databaseReference = FirebaseFirestore.instance;
  final String userUid;

  UserProfile(this.userUid);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: getUser(),
        builder: (context, user) {
          if (user.connectionState == ConnectionState.waiting) {
            return Center(
              child: Text('Učitavanje...'),
            );
          } else {
            return Center(
                child: Column(
                  children: [
                    Image.network(
                        'https://hatrabbits.com/wp-content/uploads/2017/01/random.jpg'),
                    Text(user.data.data()['username']),
                    Expanded(child:
                    FutureBuilder(
                        future: getPostList(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(child: Text('Učitavanje...'));
                          } else {
                            return ListView.builder(
                                itemCount: snapshot.data.length,
                                itemBuilder: (_, index) {
                                  if(userUid == snapshot.data[index].data()['author']) {
                                    if (user.data['uid'] ==
                                        FirebaseAuth.instance.currentUser.uid) {
                                      return CardTypes.getStudentCard(
                                          context, snapshot.data[index], true);
                                    } else {
                                      return CardTypes.getStudentCard(
                                          context, snapshot.data[index], false);
                                    }
                                  } else return null;
                                });
                          }
                        })
                    )
                  ],
                )
            );
          }
        }
      ),
    );
  }

  Future getUser() async{
    return _databaseReference.collection('users').doc(userUid).get();
  }

  Future getPostList() async {
    QuerySnapshot qn = await _databaseReference
        .collection('posts')
        .orderBy("timestamp", descending: true)
        .get();
    return qn.docs;
  }
}
