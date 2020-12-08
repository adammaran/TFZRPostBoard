import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class TeacherRequests extends StatelessWidget {
  final _databaseReference = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Container(
        child: FutureBuilder(
          future: getPendingUsersList(),
          builder: (
              context,
              snapshot,
              ) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: Text('Učitavanje'));
            } else {
              return ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (_, index) {
                  if (snapshot.data[index].data()['isApproved'] == false) {
                    return Card(
                      child: Column(
                        children: [
                          ListTile(
                            title:
                            Text(snapshot.data[index].data()['username']),
                            subtitle: const Text(
                                'Zahtev za kreiranje \'Profesor\' naloga'),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              TextButton(
                                  onPressed: () =>
                                      setUserApproval(snapshot.data[index]),
                                  child: const Text('Prihvati')),
                              TextButton(
                                  onPressed: () => deleteRequest(
                                      snapshot.data[index].data()['uuid']),
                                  child: const Text('Odbi'))
                            ],
                          )
                        ],
                      ),
                    );
                  } else
                    return null;
                },
              );
            }
          }
        ));
  }
  Future<void> setUserApproval(DocumentSnapshot user) async {
    _databaseReference
        .collection('pending_users')
        .doc(user['uuid'])
        .update({"isApproved": true});
  }

  void deleteRequest(String uuid) {
    _databaseReference.collection('pending_users').doc(uuid).delete();
  }

  Future getPendingUsersList() async {
    QuerySnapshot qn =
    await _databaseReference.collection('pending_users').get();
    return qn.docs;
  }
}
