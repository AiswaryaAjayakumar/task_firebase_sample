// ignore_for_file: prefer_const_constructors, unused_local_variable, use_build_context_synchronously, avoid_print, prefer_const_literals_to_create_immutables, sort_child_properties_last, prefer_typing_uninitialized_variables, unnecessary_string_interpolations

import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:task_firebase_sample/view/login_screen/login_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  TextEditingController mail = TextEditingController();
  TextEditingController pass = TextEditingController();
  TextEditingController name = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  CollectionReference collectionReference =
      FirebaseFirestore.instance.collection("admins");

  final List<String> loginPerson = ["None", "Admin", "User"];
  String selectedLogin = "None";
  var url;

  XFile? pickedImage;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InkWell(
                onTap: () async {
                  pickedImage =
                      await ImagePicker().pickImage(source: ImageSource.camera);
                  // setState(() {});

                  if (pickedImage != null) {
                    final uniqueImage =
                        DateTime.timestamp().microsecondsSinceEpoch.toString();
                    final storageRef = FirebaseStorage.instance.ref();
                    final imagesRef = storageRef.child("admins");
                    final uploadRef = imagesRef.child("$uniqueImage");
                    await uploadRef.putFile(File(pickedImage!.path));
                    url = await uploadRef.getDownloadURL();
                    setState(() {});
                    if (url != null) {
                      log("image added successfully");

                      log(url.toString());
                    } else {
                      log("failed to upload image");
                    }
                  }
                },
                child: CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.black,
                  backgroundImage: url != null ? NetworkImage(url) : null,
                ),
              ),
              DropdownButton(
                borderRadius: BorderRadius.circular(20),
                dropdownColor: Colors.grey.shade500,
                elevation: 4,
                icon: Icon(Icons.person),
                value: selectedLogin,
                items: List.generate(
                    loginPerson.length,
                    (index) => DropdownMenuItem(
                          child: Text(loginPerson[index]),
                          value: loginPerson[index],
                        )),
                onChanged: (value) {
                  if (value != null) {
                    selectedLogin = value;
                  }
                  setState(() {});
                },
              ),
              SizedBox(
                height: 10,
              ),
              TextFormField(
                validator: (value) {
                  if (RegExp(
                          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                      .hasMatch(mail.text)) {
                    return null;
                  } else {
                    return "enter a valid email";
                  }
                },
                controller: mail,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10))),
              ),
              SizedBox(
                height: 10,
              ),
              TextFormField(
                controller: pass,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10))),
                validator: (value) {
                  if (value != null && value.length >= 6) {
                    return null;
                  } else {
                    return "enter a valid password";
                  }
                },
              ),
              SizedBox(
                height: 10,
              ),
              TextFormField(
                controller: name,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10))),
                validator: (value) {
                  if (value != null) {
                    return null;
                  } else {
                    return "enter a valid name";
                  }
                },
              ),
              SizedBox(
                height: 10,
              ),
              ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      try {
                        final cred = await FirebaseAuth.instance
                            .createUserWithEmailAndPassword(
                          email: mail.text,
                          password: pass.text,
                        );
                        if (cred.user?.uid != null) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => LoginScreen(),
                              ));
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text(
                                  "Failed to create Account, try again..")));
                        }
                      } on FirebaseAuthException catch (e) {
                        if (e.code == 'weak-password') {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text("The password is too weak..")));
                        } else if (e.code == 'email-already-in-use') {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text("The account is already used")));
                        }
                      } catch (e) {
                        print(e);
                      }
                    }
                    collectionReference.add({
                      "email": mail.text,
                      "name": name.text,
                      "image": url,
                      "type": selectedLogin
                    });
                  },
                  child: Text("Register")),
              SizedBox(
                height: 10,
              ),
              TextButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LoginScreen(),
                        ));
                  },
                  child: Text("Already have an account, Login now")),
            ],
          ),
        ),
      ),
    );
  }
}
