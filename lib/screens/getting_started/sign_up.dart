import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:the_counsellor/controller/constants.dart';
import 'package:the_counsellor/screens/screens.dart';

class SignUp extends StatefulWidget {
  static const String id = 'sign_up';

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  CollectionReference users = FirebaseFirestore.instance.collection('users');

  final TextEditingController emailController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  //Swith between SignIn and SignUp Screen Helper
  bool _isLogin = true;
  bool _isLoading = false;

  @override
  void initState() {
    users = FirebaseFirestore.instance.collection('users');
    if (FirebaseAuth.instance.currentUser != null)
      FirebaseAuth.instance.authStateChanges().listen((User user) {
        if (user != null) {
          users.where('email', isEqualTo: user.email).get().then((value) {
            Navigator.pushReplacementNamed(context, HomePage.id,
                arguments: {'user': value.docs.first});
          });
        }
      });

    super.initState();
  }

  Future<void> addUser(String uid, String token) async {
    return users.add({
      'email': emailController.text,
      'name': nameController.text,
      'uid': uid,
      'phone': phoneController.text,
      'token': "$token",
    }).then((value) {
      users = FirebaseFirestore.instance.collection('users');
      print("User Added well well");
    }).catchError((error) => print("Failed to add user: $error"));
  }

  @override
  Widget build(BuildContext context) {
    double deviceWidth = MediaQuery.of(context).size.width;
    double deviceHeight = MediaQuery.of(context).size.height;
    TextTheme textTheme = Theme.of(context).textTheme;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.fromLTRB(20, 30, 20, 20),
            child: Column(
              children: [
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        _isLogin ? 'Login' : 'Sign Up',
                        style: textTheme.headline3.copyWith(
                          color: Color(0xFF303030),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      CupertinoButton(
                        padding: EdgeInsets.zero,
                        child: Text(
                          _isLogin ? 'Sign Up' : 'Login',
                          style:
                              textTheme.headline6.copyWith(color: Colors.grey),
                        ),
                        onPressed: () {
                          _isLogin = !_isLogin;
                          setState(() {});
                        },
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: deviceHeight * 0.08,
                ),
                Material(
                  borderRadius: BorderRadius.circular(10),
                  shadowColor: Colors.grey.shade100,
                  elevation: 50,
                  child: Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        image: DecorationImage(
                            image: AssetImage(
                          'assets/images/gadri_logo.jpg',
                        ))),
                    alignment: Alignment.topCenter,
                  ),
                ),
                SizedBox(
                  height: deviceHeight * 0.08,
                ),
                Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _isLogin
                          ? SizedBox.shrink()
                          : TextFormField(
                              controller: nameController,
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Please enter your name';
                                } else
                                  return null;
                              },
                              decoration: InputDecoration(labelText: 'Name'),
                            ),
                      SizedBox(height: deviceHeight * 0.015),
                      TextFormField(
                        controller: emailController,
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please enter your email';
                          }
// This is just a regular expression for email addresses
                          String p = "[a-zA-Z0-9\+\.\_\%\-\+]{1,256}" +
                              "\\@" +
                              "[a-zA-Z0-9][a-zA-Z0-9\\-]{0,64}" +
                              "(" +
                              "\\." +
                              "[a-zA-Z0-9][a-zA-Z0-9\\-]{0,25}" +
                              ")+";
                          RegExp regExp = new RegExp(p);

                          if (regExp.hasMatch(value)) {
// So, the email is valid
                            return null;
                          }

// The pattern of the email didn't match the regex above.
                          return 'Email is not valid';
                        },
                        decoration: InputDecoration(
                          labelText: 'Email',
                        ),
                      ),
                      SizedBox(height: deviceHeight * 0.015),
                      !_isLogin
                          ? TextFormField(
                              controller: phoneController,
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Please enter your phone number';
                                }

                                return null;
                              },
                              decoration: InputDecoration(
                                labelText: 'Phone number',
                              ),
                              keyboardType: TextInputType.number,
                            )
                          : SizedBox.shrink(),
                      SizedBox(height: deviceHeight * 0.015),
                      TextFormField(
                        controller: passwordController,
                        decoration: InputDecoration(
                          labelText: 'Password',
                        ),
                        validator: (input) {
                          if (input.isNotEmpty) {
                            if (input.length < 5)
                              return 'Password is too short';
                            else
                              return null;
                          } else
                            return 'Enter your password';
                        },
                      ),
                      SizedBox(height: deviceHeight * 0.03),
                    ],
                  ),
                ),
                SizedBox(
                  height: deviceHeight * 0.03,
                ),
                SizedBox(
                  width: deviceWidth,
                  child: !_isLoading
                      ? CupertinoButton(
                          child: Text(_isLogin ? 'LOG IN' : 'REGISTER'),
                          onPressed: () async {
                            String token =
                                await FirebaseMessaging.instance.getToken();
                            if (_formKey.currentState.validate()) {
                              setState(() {
                                _isLoading = true;
                              });
                              if (!_isLogin) {
                                try {
                                  UserCredential userCredential =
                                      await FirebaseAuth
                                          .instance
                                          .createUserWithEmailAndPassword(
                                              email: emailController.text,
                                              password:
                                                  passwordController.text);

                                  if (userCredential.user != null) {
                                    addUser(userCredential.user.uid, token)
                                        .then((value) {
                                      users
                                          .where('email',
                                              isEqualTo:
                                                  userCredential.user.email)
                                          .get()
                                          .then((value) {
                                        Navigator.pushReplacementNamed(
                                            context, HomePage.id, arguments: {
                                          'user': value.docs.first
                                        });
                                      });
                                    });
                                  }
                                } on FirebaseAuthException catch (e) {
                                  setState(() {
                                    _isLoading = false;
                                  });
                                  if (e.code == 'weak-password') {
                                    print('The password provided is too weak.');
                                  } else if (e.code == 'email-already-in-use') {
                                    print(
                                        'The account already exists for that email.');
                                  }
                                } catch (e) {
                                  print(e);
                                }
                              } else {
                                try {
                                  UserCredential userCredential =
                                      await FirebaseAuth
                                          .instance
                                          .signInWithEmailAndPassword(
                                              email: emailController.text,
                                              password:
                                                  passwordController.text);

                                  if (userCredential.user != null) {
                                    users
                                        .where('email',
                                            isEqualTo:
                                                userCredential.user.email)
                                        .get()
                                        .then((value) {
                                      Navigator.pushReplacementNamed(
                                          context, HomePage.id, arguments: {
                                        'user': value.docs.first
                                      });
                                    });
                                  }
                                } on FirebaseAuthException catch (e) {
                                  setState(() {
                                    _isLoading = false;
                                  });
                                  if (e.code == 'user-not-found') {
                                    print('No user found for that email.');
                                  } else if (e.code == 'wrong-password') {
                                    print(
                                        'Wrong password provided for that user.');
                                  }
                                }
                              }
                            }
                          },
                          color: kPrimaryColor,
                        )
                      : Text(
                          'Loading... Please Wait!',
                          style: textTheme.headline6,
                          textAlign: TextAlign.center,
                        ),
                ),
                SizedBox(
                  height: deviceHeight * 0.08,
                ),
//                    Text('- Login with -'),
//                    SizedBox(
//                      width: deviceWidth * 0.6,
//                      child: Row(
//                        mainAxisAlignment: MainAxisAlignment.spaceAround,
//                        children: [
//                          IconButton(
//                              icon: Image.asset('assets/images/google.png'),
//                              onPressed: () {}),
//                          IconButton(
//                              icon: Image.asset('assets/images/twitter.png'),
//                              onPressed: () {}),
//                          IconButton(
//                              icon: Image.asset('assets/images/facebook.png'),
//                              onPressed: () {}),
//                        ],
//                      ),
//                    ),
//                    Spacer(),
              ],
            ),
          ),
        ),
      ),
    );

//    return Scaffold(
//      body: FutureBuilder(
////        future: _initialization,
//        builder: (context, snapshot) {
//          // Check for errors
//          if (snapshot.hasError) {
//            return Container();
//          }
//          // Once complete, show your application
//          if (snapshot.connectionState == ConnectionState.done) {
//            return Container();
//          }
//
//          // Otherwise, show something whilst waiting for initialization to complete
//          return Container();
//        },
//      ),
//    );
  }
}
