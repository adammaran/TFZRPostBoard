import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:informatortfzr/Common/NavDrawer.dart';
import 'package:informatortfzr/pages/AddNote.dart';
import 'package:informatortfzr/pages/PostWidget.dart';
import 'package:informatortfzr/pages/SearchWidget.dart';
import 'package:informatortfzr/pages/userPage/UserProfileWidget.dart';
import 'Login.dart';

class MyHomePage extends StatefulWidget {
  final String title = 'Informaciona tabla';

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _currentIndex = 0;
  final _pageOptions = [
    PostWidget(),
    SearchWidget(),
    Text('Item 3'),
    UserProfile(FirebaseAuth.instance.currentUser.uid)
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: NavDrawer(),
      appBar: AppBar(
        title: Text(widget.title),
        automaticallyImplyLeading: false,
        backgroundColor: Colors.red,
      ),
      body: _pageOptions[_currentIndex],
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => AddNote()));
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.red,
        focusColor: Colors.red,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        iconSize: 28,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.view_stream),
            label: 'Objave',
            backgroundColor: Colors.red,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Pretraga',
            backgroundColor: Colors.red,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: 'Notifikacije',
            backgroundColor: Colors.red,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profil',
            backgroundColor: Colors.red,
          ),
        ],
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}
