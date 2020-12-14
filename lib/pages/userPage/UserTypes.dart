import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:informatortfzr/pages/CardTypes.dart';

class UserTypes {
  static final _databaseReference = FirebaseFirestore.instance;

  static Widget getCurrentUserPage(String userUid) {
    return Scaffold(
      body: FutureBuilder(
          future: getUser(userUid),
          builder: (context, user) {
            if (user.connectionState == ConnectionState.waiting) {
              return Center(
                child: Text('Učitavanje...'),
              );
            } else {
              return Center(
                  child: Column(
                children: [
                  Image.network(user.data.data()['avatarUrl'].toString().trim()),
                  Text(user.data.data()['username'],
                      style: TextStyle(
                          fontSize: 28, height: 1.5, color: Colors.black87)),
                  RaisedButton(
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, '/Settings');
                    },
                    child: Text('Podešavanja'),
                  ),
                  Expanded(
                      child: StreamBuilder<QuerySnapshot>(
                    stream: (userUid == null)
                        ? _databaseReference.collection('posts').snapshots()
                        : _databaseReference
                            .collection('posts')
                            .where('author', isEqualTo: userUid)
                            .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return Text('Error ${snapshot.error}');
                      }
                      switch (snapshot.connectionState) {
                        case ConnectionState.waiting:
                          return SizedBox(
                            child: Center(
                              child: Text('Učitavanje... '),
                            ),
                          );
                        case ConnectionState.none:
                          return Text('Korisnik jos uvek nije nista objavio');
                        default:
                          return new ListView(
                            children: snapshot.data.docs
                                .map((DocumentSnapshot document) {
                              if (userUid ==
                                  FirebaseAuth.instance.currentUser.uid) {
                                return CardTypes.getStudentCard(
                                    context, document, true);
                              } else
                                return CardTypes.getStudentCard(
                                    context, document, false);
                            }).toList(),
                          );
                      }
                    },
                  ))
                ],
              ));
            }
          }),
    );
  }

  static Widget getForeignUser(String userUid) {
    return Scaffold(
      body: FutureBuilder(
          future: getUser(userUid),
          builder: (context, user) {
            if (user.connectionState == ConnectionState.waiting) {
              return Center(
                child: Text('Učitavanje...'),
              );
            } else {
              return Center(
                  child: Column(
                children: [
                  Image.network(user.data.data()['avatarUrl']),
                  Text(user.data.data()['username'],
                      style: TextStyle(
                          fontSize: 28, height: 1.5, color: Colors.black87)),
                  StreamBuilder(
                      stream: getButton(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Scaffold();
                        } else {
                          List<dynamic> list = snapshot.data["following"];
                          if (list.contains(userUid))
                            return getUnfollowButton(userUid);
                          else
                            return getFollowButton(userUid);
                        }
                      }),
                  postList(userUid)
                ],
              ));
            }
          }),
    );
  }

  static Stream<DocumentSnapshot> getButton() {
    return _databaseReference
        .collection('following')
        .doc(FirebaseAuth.instance.currentUser.uid)
        .snapshots();
  }

  static RaisedButton getFollowButton(String userUid) {
    return RaisedButton(
      onPressed: () {
        addFollowing(userUid);
      },
      child: Text('Zaprati'),
    );
  }

  static RaisedButton getUnfollowButton(String userUid) {
    return RaisedButton(
      onPressed: () {
        removeFollow(userUid);
      },
      child: Text('Odprati'),
    );
  }

  static void removeFollow(String userUid) async {
    var unfollow = [];
    unfollow.add(userUid);
    _databaseReference
        .collection('following')
        .doc(FirebaseAuth.instance.currentUser.uid)
        .update({'following': FieldValue.arrayRemove(unfollow)});
  }

  static void addFollowing(String userUid) async {
    List<String> following = new List();
    following.add(userUid);
    await _databaseReference
        .collection('following')
        .doc(FirebaseAuth.instance.currentUser.uid)
        .update({"following": FieldValue.arrayUnion(following)});
  }

  static Future getUser(String userUid) async {
    return _databaseReference.collection('users').doc(userUid).get();
  }

  static Expanded postList(String userUid) {
    return Expanded(
        child: StreamBuilder<QuerySnapshot>(
      stream: (userUid == null)
          ? _databaseReference.collection('posts').snapshots()
          : _databaseReference
              .collection('posts')
              .where('author', isEqualTo: userUid)
              .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Error ${snapshot.error}');
        }
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return SizedBox(
              child: Center(
                child: Text('Učitavanje... '),
              ),
            );
          case ConnectionState.none:
            return Text('Korisnik jos uvek nije nista objavio');
          default:
            return new ListView(
              children: snapshot.data.docs.map((DocumentSnapshot document) {
                if (userUid == FirebaseAuth.instance.currentUser.uid) {
                  return CardTypes.getStudentCard(context, document, true);
                } else
                  return CardTypes.getStudentCard(context, document, false);
              }).toList(),
            );
        }
      },
    ));
  }
}
