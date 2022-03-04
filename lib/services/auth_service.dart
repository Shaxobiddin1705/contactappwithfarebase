import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../pages/sign_in_page.dart';
import 'hive_service.dart';

class AuthService{

  static final FirebaseAuth _auth = FirebaseAuth.instance;

  static Future<User?> signUpUser(String name, String email, String password, context) async{
    SnackBar? snackBar;
    try{
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      User? user = userCredential.user;
      if (kDebugMode) {
        print(user.toString());
      }
      return user;
    } on FirebaseAuthException catch (e) {
      if(e.code == "weak-password") {
        if (kDebugMode) {
          print('The password provided is too weak.');
        }
        snackBar = const SnackBar(
            content: Text('The password provided is too weak.', style: TextStyle(color: Colors.blue)),
            backgroundColor: Colors.white,
        );
      } else if(e.code == 'email-already-in-use') {
        if (kDebugMode) {
          print('The account already exists for that email.');
        }
        snackBar = const SnackBar(
            content: Text('The account already exists for that email.', style: TextStyle(color: Colors.blue),),
            backgroundColor: Colors.white,
        );
      }
    }catch(e) {
      if (kDebugMode) {
        print(e);
      }
      snackBar = SnackBar(
        content: Text(e.toString(), style: const TextStyle(color: Colors.blue)),
        backgroundColor: Colors.white,
      );
    }
    if(snackBar != null) {
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
    return null;
  }


  static Future<User?> signInUser(String email, String password, context) async{
    SnackBar? snackBar;
    try{
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(email: email, password: password);
      User? user = userCredential.user;
      if (kDebugMode) {
        print(user.toString());
      }
      return user;
    } on FirebaseAuthException catch (e) {
      if(e.code == "user-not-found") {
        if (kDebugMode) {
          print('No user found for that email.');
        }
        snackBar = const SnackBar(
          content: Text('No user found for that email.', style: TextStyle(color: Colors.blue)),
          backgroundColor: Colors.white,
        );
      } else if(e.code == 'wrong-password') {
        if (kDebugMode) {
          print('Wrong password provided for that email.');
        }
        snackBar = const SnackBar(
          content: Text('Wrong password provided for that email.', style: TextStyle(color: Colors.blue)),
          backgroundColor: Colors.white,
        );
      }
    }catch(e) {
      if (kDebugMode) {
        print(e);
      }
      snackBar = SnackBar(
        content: Text(e.toString(), style: const TextStyle(color: Colors.blue)),
        backgroundColor: Colors.white,
      );
    }
    if(snackBar != null) {
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
    return null;
  }

  static void singOutUser(BuildContext context) async{
    await _auth.signOut();
    Navigator.pushReplacementNamed(context, SignInPage.id);
  }

  static void deleteUser(context) async {
    SnackBar? snackBar;
    try{
      HiveDB.removeUser(_auth.currentUser!.uid);
      await _auth.currentUser!.delete();
      Navigator.pushReplacementNamed(context, SignInPage.id);
    }on FirebaseAuthException catch (e) {
      if (e.code == 'requires-recent-login') {
        print('The user must authenticate before this operation can be executed.');
      }
      snackBar = const SnackBar(
        content: Text('The user must authenticate before this operation can be executed.', style: TextStyle(color: Colors.blue)),
        backgroundColor: Colors.white,
      );
    }
    if(snackBar != null) {
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }
}