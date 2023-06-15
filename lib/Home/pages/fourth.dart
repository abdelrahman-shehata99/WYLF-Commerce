import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../widgets/button.dart';

class Fourth extends StatefulWidget {
  const Fourth({Key? key}) : super(key: key);

  @override
  _FourthState createState() => _FourthState();
}

class _FourthState extends State<Fourth> {
  Future<QuerySnapshot<Map<String, dynamic>>> getUserDataByEmail(
      String email) async {
    final userRef = FirebaseFirestore.instance.collection('users');
    return await userRef.where('email', isEqualTo: email).get();
  }

  Map<String, dynamic>? userData;
  void data() async {
    final User? currentUser = FirebaseAuth.instance.currentUser;
    final String? email = currentUser?.email;

    if (email != null) {
      final snapshot = await getUserDataByEmail(email);
      if (snapshot.docs.isNotEmpty) {
        setState(() {
          userData = snapshot.docs.first.data();
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    data();
  }

  none() {}
  @override
  Widget build(BuildContext context) {
    final User? currentUser = FirebaseAuth.instance.currentUser;
    final String? email = currentUser?.email;

    return Scaffold(
      body: Center(
        child: ListView(padding: EdgeInsets.all(10), children: [
          if (userData != null) ...[
            CircleAvatar(
              backgroundColor: Colors.black,
              radius: 70,
              backgroundImage:
                  NetworkImage('${userData!['image_url']}', scale: 5),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(20))),
              child: Column(
                children: [
                  txtForm('User Name ', '${userData!['name']}'),
                  txtForm('Email ', '${userData!['email']}'),
                  txtForm('Phone ', '${userData!['phone']}'),
                  txtForm('Country ', '${userData!['country']}'),
                  txtForm('Address ', '${userData!['address']}'),
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
          ] else
            Container(
                height: 100, width: 100, child: CircularProgressIndicator()),
          Container(
            height: 50,
            width: 100,
            child: btnTo(context, none, 'Edit', 2, Colors.amberAccent),
          )
        ]),
      ),
    );
  }
}

txtForm(String txt1, String txt2) {
  return Column(
    children: [
      SizedBox(
        height: 5,
      ),
      Column(children: [
        Text(
          txt1,
          style: TextStyle(color: Colors.black38, fontSize: 20),
        ),
        Text(
          txt2,
          style: TextStyle(color: Colors.black, fontSize: 15),
        ),
      ]),
      SizedBox(
        height: 5,
      ),
      Divider(
        color: Colors.amberAccent,
      ),
    ],
  );
}
