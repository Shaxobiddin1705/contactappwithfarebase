import 'package:contactappwithfarebase/pages/sign_up_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../services/auth_service.dart';
import '../services/hive_service.dart';
import 'home_page.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({Key? key}) : super(key: key);
  static const String id = "sign_in_page";

  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  TextEditingController passwordEditingController = TextEditingController();
  TextEditingController emailEditingController = TextEditingController();
  bool isLoading = false;

  Future<void> _doSignIn() async{
    String email = emailEditingController.text.trim().toString();
    String password = passwordEditingController.text.trim().toString();
    setState(() {
      isLoading = true;
    });
    if(email.isEmpty || password.isEmpty) {
      return ;
    }
    await AuthService.signInUser(email, password, context).then((value) => _getFireBaseUser(value));
  }

  void _getFireBaseUser(User? user) {
    setState(() {
      isLoading = false;
    });
    if(user != null) {
      Navigator.pushReplacementNamed(context, HomePage.id);
    }else {
      //print error message
    }
  }

  void authenticateUser() async{
    String email = emailEditingController.text.trim().toString();
    String password = passwordEditingController.text.trim().toString();

    AuthCredential credential = EmailAuthProvider.credential(email: email, password: password);
    await FirebaseAuth.instance.currentUser?.reauthenticateWithCredential(credential);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              height: MediaQuery.of(context).size.height,
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.bottomRight,
                      end: Alignment.topLeft,
                      colors: [
                        const Color(0xff000080).withOpacity(0.8),
                        const Color(0xff191970).withOpacity(0.9),
                        const Color(0xff00008b).withOpacity(0.8),
                        const Color(0xff1434A4).withOpacity(0.9),
                      ]
                  )
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [

                  Lottie.asset('assets/animations/signIn.json', animate: true, height: 200),

                  const SizedBox(height: 40,),

                  //#email
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    height: 46,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: CupertinoColors.systemGrey6
                    ),
                    child: TextField(
                      controller: emailEditingController,
                      textInputAction: TextInputAction.next,
                      decoration: const InputDecoration(
                          hintText: "Email",
                          border: InputBorder.none,
                          hintStyle: TextStyle(color: CupertinoColors.systemGrey)
                      ),
                    ),
                  ),

                  const SizedBox(height: 10,),

                  //#password
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    height: 46,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: CupertinoColors.systemGrey6
                    ),
                    child: TextField(
                      controller: passwordEditingController,
                      obscureText: true,
                      textInputAction: TextInputAction.next,
                      decoration: const InputDecoration(
                          hintText: "Password",
                          border: InputBorder.none,
                          hintStyle: TextStyle(color: CupertinoColors.systemGrey)
                      ),
                    ),
                  ),

                  const SizedBox(height: 20,),

                  //#signIn
                  MaterialButton(
                      onPressed: () {
                        _doSignIn();
                        authenticateUser();
                      },
                      child: const Text("Sign In"),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      height: 45,
                      minWidth: MediaQuery.of(context).size.width - 50,
                      textColor: Colors.white,
                      color: const Color(0xff0096ff)
                  ),

                  const SizedBox(height: 20,),

                  //#don`tHaveAccount
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      const Text("Don`t have an account? ", style: TextStyle(color: Colors.white),),
                      InkWell(
                        onTap: () {
                          Navigator.pushNamed(context, SignUpPage.id);
                        },
                        child: const Text("Sign Up", style: TextStyle(color: Color(0xff0096ff), fontWeight: FontWeight.bold),),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          isLoading ? const Center(child: CircularProgressIndicator()) : const SizedBox.shrink(),
        ],
      )
    );
  }
}
