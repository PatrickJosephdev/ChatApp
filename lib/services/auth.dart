// import 'dart:nativewrappers/_internal/vm/lib/core_patch.dart';

// import 'package:flutter/material.dart';
import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthServices {
  // for storing data in cloud firestore
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  // for authentication
  final FirebaseAuth _auth = FirebaseAuth.instance;

//for Sign up
  Future signUpUser({
    required String email,
    required String password,
    required String name,
  }) async {
    // ignore: unused_local_variable
    // String res = "Some error Occured";

    try {
      if (email.isNotEmpty || password.isNotEmpty || name.isNotEmpty) {
        // for registering user in firebase auth with email and password
        UserCredential credential = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);
        // for adding user to our cloud firestore
        await _firestore.collection("users").doc(credential.user!.uid).set({
          // we can't store user's password in our cloud firestore
          'name': name,
          'email': email,
          'uid': credential.user!.uid,
        });
        // res = 'Success';
        // print(res);
        return 'success';
      }
    } catch (e) {
      print(e.toString());
      return 'error occurred';
    }
  }

  //for sign in
  Future loginUser({
    required String email,
    required String password,
  }) async {
    try {
      if (email.isNotEmpty || password.isNotEmpty) {
        //login user with email and password
        await _auth.signInWithEmailAndPassword(
            email: email, password: password);
        return 'success';
      } else {
        return 'Please Enter all the Field';
      }
    } catch (e) {
      return e.toString();
    }
  }

  // for logout

  Future<void> signOut() async {
    await _auth.signOut();
  }
}

//for SignUp
