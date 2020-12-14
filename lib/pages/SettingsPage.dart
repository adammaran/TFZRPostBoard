import 'dart:async';
import 'dart:core';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

class SettingsPage extends StatelessWidget {
  static final _databaseReference = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ListView(
      padding: EdgeInsets.only(top: 30),
      children: <Widget>[
        ListTile(
            leading: Icon(Icons.add_a_photo),
            title: Text('Promeni profilnu'),
            onTap: () {
              selectImage(context);
            }),
      ],
    ));
  }

  Future selectImage(BuildContext context) async {
    final picker = ImagePicker();
    final selectedFile = await picker.getImage(source: ImageSource.gallery);
    uploadImage(context, File(selectedFile.path));
  }

  Future uploadImage(BuildContext context, File image) async {
    String imageUrl;
    Uuid uuid = new Uuid();
    String fileName = uuid.v4();
    Reference storageRef =
        FirebaseStorage.instance.ref().child('avatars/$fileName');
    UploadTask uploadTask = storageRef.putFile(image);
    await uploadTask.whenComplete(() async {
      try {
        imageUrl = await storageRef.getDownloadURL();
        updateUser(imageUrl);
      } catch (onError) {
        print("failed while uploading image");
      }
    });
  }

  Future updateUser(String imageUrl) async {
    _databaseReference
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser.uid)
        .update({'avatarUrl': imageUrl});
  }
}
