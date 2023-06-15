import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '/Home/widgets/button.dart';
import '../Home/home.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);
  @override
  _LoginState createState() => _LoginState();
}

TextEditingController email = TextEditingController();
TextEditingController pass = TextEditingController();

class _LoginState extends State<Login> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  void signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleSignInAccount =
          await _googleSignIn.signIn();
      if (googleSignInAccount != null) {
        final GoogleSignInAuthentication googleSignInAuthentication =
            await googleSignInAccount.authentication;

        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken,
        );

        final UserCredential userCredential =
            await _auth.signInWithCredential(credential);
        final User? user = userCredential.user;
        if (user != null) {
          Get.to(Home());

          notify(context, 'Welcome!', 'Successfully signed in with Google');
        } else {
          // Failed sign-in
          print('Failed to sign in with Google');
        }
      } else {
        // Google sign-in canceled
        print('Google sign-in canceled');
      }
    } catch (e) {
      print('Error signing in with Google: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    // var email, pass;
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: null,
      body: Form(
        child: Center(
          child: ListView(
            children: [
              SizedBox(
                height: 100,
              ),
              Column(children: [
                Text('WYLF. COM',
                    style: TextStyle(
                        fontSize: 70,
                        color: Colors.yellow,
                        fontFamily: 'AmaticSC')),
                Text('What You Looking For. Com',
                    style: TextStyle(
                        fontSize: 15, color: Colors.white, fontFamily: 'Hind'))
              ]),
              SizedBox(
                height: 50,
              ),
              Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(25))),
                child: Column(
                  children: [
                    TextFormField(
                      controller: email,
                      onSaved: (value) {
                        email.text = value!;
                      },
                      validator: (value) {
                        if (value!.length > 100) {
                          return 'Email Cant Be Larger Than 100 Letter';
                        }
                        if (value.length < 4) {
                          return 'Email Cant Be Smaller Than 4 Letter';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderSide:
                                  BorderSide(width: 1, color: Colors.black),
                              borderRadius: BorderRadius.circular(20)),
                          focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(width: 1, color: Colors.black),
                              borderRadius: BorderRadius.circular(20)),
                          enabledBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(width: 1, color: Colors.black),
                              borderRadius: BorderRadius.circular(20)),
                          prefixIcon: Icon(
                            Icons.account_circle_outlined,
                            color: Colors.black,
                          ),
                          hintText: 'Email',
                          labelText: 'Email'),
                      cursorColor: Colors.black,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      keyboardType: TextInputType.visiblePassword,
                      controller: pass,
                      onSaved: (value) {
                        pass.text = value!;
                      },
                      validator: (value) {
                        if (value!.length > 100) {
                          return 'PassWord Cant Be Larger Than 100 Letter';
                        }
                        if (value.length < 4) {
                          return 'Password Cant Be Smaller Than 4 Letter';
                        }
                        return null;
                      },
                      obscureText: true,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderSide:
                                  BorderSide(width: 1, color: Colors.black),
                              borderRadius: BorderRadius.circular(20)),
                          focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(width: 1, color: Colors.black),
                              borderRadius: BorderRadius.circular(20)),
                          enabledBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(width: 1, color: Colors.black),
                              borderRadius: BorderRadius.circular(20)),
                          prefixIcon: Icon(
                            Icons.admin_panel_settings_sharp,
                            color: Colors.black,
                          ),
                          hintText: 'Password',
                          labelText: 'Password',
                          focusColor: Colors.white),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          elevation: 0,
                          fixedSize: Size(300, 60),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          backgroundColor: Colors.black),
                      child: Text(
                        "Login",
                        style: TextStyle(
                          color: Colors.amberAccent,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      onPressed: () {
                        signInWithEmailAndPassword(context);
                      },
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        SizedBox(
                          width: 220,
                        ),
                        TextButton(
                            onPressed: () {
                              print("heeee");

                              //   Navigator.pushNamed(context, 'container');
                            },
                            child: Text(
                              'Forgot\n Password ?',
                              style: TextStyle(color: Colors.black),
                            )),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Center(
                        child: Text(
                      'or',
                      style: TextStyle(color: Colors.black, fontSize: 20),
                    )),
                    Container(
                        width: 500,
                        child: btnTo(context, () => signInWithGoogle(),
                            'Log In With Google', 10, Colors.white)),
                    SizedBox(
                      height: 50,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Don't have an account ?",
                          style: TextStyle(fontSize: 15, color: Colors.black),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pushNamed(context, 'register');
                          },
                          child: Text(
                            'Register',
                            style:
                                TextStyle(fontSize: 40, color: Colors.yellow),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void signInWithEmailAndPassword(BuildContext context) async {
  FirebaseAuth _auth = FirebaseAuth.instance;
  final box = GetStorage();
  box.write('email', email.text);
  //  String name1=box.read('name')??"";
  try {
    await _auth
        .signInWithEmailAndPassword(email: email.text, password: pass.text)
        .then((value) async {
      print("LOGIN DONE ");
      notify(context, 'Welcome!', 'Successfully Signed in');
      Get.to(Home());
      // Navigator.pushNamed(context, '/container');
      // Get.offAll(BottomBar());
    });
  } catch (e) {
    print(e.toString());
    print("ERRORR");
  }
}
