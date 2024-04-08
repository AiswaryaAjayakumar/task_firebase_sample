// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, unnecessary_string_interpolations, prefer_typing_uninitialized_variables, unrelated_type_equality_checks, unused_local_variable

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({super.key});

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  CollectionReference collectionReference =
      FirebaseFirestore.instance.collection("admins");

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
        List<QueryDocumentSnapshot> users = snapshot.data!.docs;
        List<QueryDocumentSnapshot> admins =
            users.where((user) => user['type'] == "Admin").toList();

        return ListView.builder(
            itemCount: admins.length,
            itemBuilder: (context, index) {
              return ListTile(
                leading: CircleAvatar(
                    radius: 40,
                    backgroundImage: NetworkImage(
                      admins[index]["image"],
                    )),
                title: Text(admins[index]["email"]),
                subtitle: Text(admins[index]["name"]),
              );
            });
      },
    );
  }
}
