
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:informatortfzr/pages/userPage/UserTypes.dart';

class UserProfile extends StatelessWidget {
  final String userUid;

  UserProfile(this.userUid);

  @override
  Widget build(BuildContext context) {
    if(userUid == FirebaseAuth.instance.currentUser.uid){
      return UserTypes.getCurrentUserPage(userUid);
    } else return UserTypes.getForeignUser(userUid);
  }
}
