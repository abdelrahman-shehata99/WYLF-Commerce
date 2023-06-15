import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerceapp/Home/pages/bag.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:badges/badges.dart' as badges;
import 'package:get/get.dart';

appBar(String txt, BuildContext context) {
  FirebaseAuth auth = FirebaseAuth.instance;
  User? user = auth.currentUser;
  String userId = user!.uid;
  return AppBar(
    title: Column(
      children: [
        Text(
          'WYLF. COM',
          style: TextStyle(fontSize: 20, color: Colors.yellow),
        ),
        Text(
          txt,
          style: TextStyle(
            fontSize: 10,
            color: Colors.white,
            fontFamily: 'Indie',
          ),
        ),
      ],
    ),
    centerTitle: true,
    backgroundColor: Colors.black,
    actions: [
      StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('bag')
            .where('userId', isEqualTo: userId)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return IconButton(
              onPressed: () {},
              icon: Icon(Icons.shopping_cart_outlined),
            );
          }
          int index = snapshot.data!.docs.length;
          return badges.Badge(
            badgeContent: Text('$index'),
            badgeAnimation: badges.BadgeAnimation.slide(),
            child: IconButton(
              onPressed: () {
                Get.to(Bag());
              },
              icon: Icon(Icons.shopping_cart_outlined),
            ),
            position: badges.BadgePosition.topEnd(top: 0, end: 0),
          );
        },
      )
    ],
  );
}

appBarS(String txt) {
  return AppBar(
    title: Column(children: [
      Text(
        'WYLF. COM',
        style: TextStyle(fontSize: 20, color: Colors.yellow),
      ),
      Text(
        txt,
        style:
            TextStyle(fontSize: 10, color: Colors.white, fontFamily: 'Indie'),
      )
    ]),
    centerTitle: true,
    backgroundColor: Colors.black,
  );
}
