import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import '../home.dart';
import '../pages/third.dart';

class Sidebar extends StatefulWidget {
  const Sidebar({Key? key}) : super(key: key);

  @override
  _SidebarState createState() => _SidebarState();
}

class _SidebarState extends State<Sidebar> {
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

  @override
  Widget build(BuildContext context) {
    final User? currentUser = FirebaseAuth.instance.currentUser;
    // ignore: unused_local_variable
    final String? email = currentUser?.email;

    lst(var icon, tit, var fun) {
      return ListTile(
          contentPadding: EdgeInsets.only(left: 20, top: 5, bottom: 5),
          hoverColor: Colors.black12,
          leading: Icon(
            icon,
            color: Colors.yellow,
          ),
          title: Text(tit),
          onTap: () {
            Get.to(fun);
          });
    }

    return Drawer(
      child: ListView(
        children: [
          Container(
            height: 200,
            color: Colors.black,
            child: DrawerHeader(
                child: Expanded(
                    child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (userData != null) ...[
                  CircleAvatar(
                    radius: 30,
                    backgroundImage: NetworkImage('${userData!['image_url']}'),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    '${userData!['name']}',
                    style: TextStyle(color: Colors.white),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    '${userData!['email']}',
                    style: TextStyle(color: Colors.white),
                  )
                ],
              ],
            ))),
          ),
          lst(Icons.home, 'Home', Home()),
          lst(Icons.production_quantity_limits, 'Orders', Home()),
          lst(Icons.settings, 'Settings', Home()),
          lst(Icons.person, 'Profile', Third()),
          SizedBox(height: 10),
          Divider(
            color: Color.fromARGB(71, 0, 0, 0),
            thickness: 1,
            indent: 10,
            endIndent: 10,
          )
        ],
      ),
    );
  }
}
