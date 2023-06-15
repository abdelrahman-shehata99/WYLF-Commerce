import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserData extends StatefulWidget {
  @override
  _UserDataState createState() => _UserDataState();
}

class _UserDataState extends State<UserData> {
  Map<String, dynamic>? userData;

  Future<QuerySnapshot<Map<String, dynamic>>> getUserDataByEmail(
      String email) async {
    final userRef = FirebaseFirestore.instance.collection('users');
    return await userRef.where('email', isEqualTo: email).get();
  }

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(height: 60),
          Text('User Data'),
          if (userData != null) ...[
            Text('Name: ${userData!['name']}'),
            Text('Email: ${userData!['email']}'),
          ] else
            Text('No user data found.'),
        ],
      ),
    );
  }
}
