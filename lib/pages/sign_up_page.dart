import 'package:contactappwithfarebase/pages/sign_in_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../services/auth_service.dart';
import '../services/hive_service.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);
  static const String id = "sign_up_page";

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  TextEditingController textEditingController = TextEditingController();
  TextEditingController emailEditingController = TextEditingController();
  TextEditingController firstNameEditingController = TextEditingController();
  TextEditingController lastNameEditingController = TextEditingController();
  bool isLoading = false;

  Future<void> _doSignUp() async{
    String firstName = firstNameEditingController.text.trim().toString();
    String lastName = lastNameEditingController.text.trim().toString();
    String email = emailEditingController.text.trim().toString();
    String password = textEditingController.text.trim().toString();

    setState(() {
      isLoading = true;
    });

    if(email.isEmpty || password.isEmpty || firstName.isEmpty || lastName.isEmpty) {
      return ;
    }
    await AuthService.signUpUser(firstName + " " + lastName, email, password, context).then((value) => _getFireBaseUser(value));
  }

  void _getFireBaseUser(User? user) {
    setState(() {
      isLoading = false;
    });
    if(user != null) {
      HiveDB.storeUserId(user.uid);
      Navigator.pushReplacementNamed(context, SignInPage.id);
    } else {
      // print error message
    }
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

                    //#firstName
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      height: 46,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: CupertinoColors.systemGrey6
                      ),
                      child: TextField(
                        controller: firstNameEditingController,
                        textInputAction: TextInputAction.next,
                        decoration: const InputDecoration(
                            hintText: "FirstName",
                            border: InputBorder.none,
                            hintStyle: TextStyle(color: CupertinoColors.systemGrey)
                        ),
                      ),
                    ),

                    const SizedBox(height: 10,),

                    //#lastName
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      height: 46,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: CupertinoColors.systemGrey6
                      ),
                      child: TextField(
                        controller: lastNameEditingController,
                        textInputAction: TextInputAction.next,
                        decoration: const InputDecoration(
                            hintText: "LastName",
                            border: InputBorder.none,
                            hintStyle: TextStyle(color: CupertinoColors.systemGrey)
                        ),
                      ),
                    ),

                    const SizedBox(height: 10,),

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
                        controller: textEditingController,
                        textInputAction: TextInputAction.next,
                        obscureText: true,
                        decoration: const InputDecoration(
                            hintText: "Password",
                            border: InputBorder.none,
                            hintStyle: TextStyle(color: CupertinoColors.systemGrey)
                        ),
                      ),
                    ),

                    const SizedBox(height: 10,),

                    //#signIn
                    MaterialButton(
                        onPressed: _doSignUp,
                        child: const Text("Sign Up"),
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
                        const Text("Already have an account? ", style: TextStyle(color: Colors.white),),
                        InkWell(
                          onTap: () {
                            Navigator.pushReplacementNamed(context, SignInPage.id);
                          },
                          child: const Text("Sign In", style: TextStyle(color: Color(0xff0096ff), fontWeight: FontWeight.bold),),
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
