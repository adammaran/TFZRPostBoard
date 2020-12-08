import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'file:///C:/Android/informator_tfzr/lib/pages/UserProfileWidget.dart';

class SearchWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SearchWidgetState();
}

class _SearchWidgetState extends State<SearchWidget> {
  final _databaseReference = FirebaseFirestore.instance;

  String searchKey = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          TextField(
            onChanged: (text) {
              setState(() {
                searchKey = text;
              });
            },
            decoration: InputDecoration(
                contentPadding: EdgeInsets.all(10),
                hintText: 'Uneti ime'),
          ),
          Expanded(
              child: StreamBuilder<QuerySnapshot>(
            stream: (searchKey == null || searchKey.trim() == '')
                ? _databaseReference.collection('users').snapshots()
                : _databaseReference
                    .collection('users')
                    .where('caseSearch', arrayContains: searchKey)
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
                  return Text('Korisnik nije pronadjen');
                default:
                  return new ListView(
                    children:
                        snapshot.data.docs.map((DocumentSnapshot document) {
                      return new Card(
                        child: ListTile(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => UserProfile(document['uid']))
                            );
                          },
                          title: Text(document['username']),
                        ),
                      );
                    }).toList(),
                  );
              }
            },
          ))
        ],
      ),
    );
  }
}
