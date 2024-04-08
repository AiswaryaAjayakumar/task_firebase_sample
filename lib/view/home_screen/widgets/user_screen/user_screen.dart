// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, unnecessary_string_interpolations, prefer_typing_uninitialized_variables, unused_local_variable

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UserScreen extends StatefulWidget {
  const UserScreen({super.key});

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  CollectionReference collectionReference =
      FirebaseFirestore.instance.collection("admins");

  var url;

  XFile? pickedImage;
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: collectionReference.snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text("Error");
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        List<QueryDocumentSnapshot> admins = snapshot.data!.docs;
        List<QueryDocumentSnapshot> users =
            admins.where((admin) => admin['type'] == "User").toList();

        return ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              return ListTile(
                leading: CircleAvatar(
                    radius: 40,
                    backgroundImage: NetworkImage(
                      users[index]["image"],
                    )),
                title: Text(users[index]["email"]),
                subtitle: Text(users[index]["name"]),
              );
            });
      },
    );
  }
}
