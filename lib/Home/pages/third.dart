import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Third extends StatefulWidget {
  const Third({Key? key}) : super(key: key);

  @override
  _ThirdState createState() => _ThirdState();
}

class _ThirdState extends State<Third> {
  Future<QuerySnapshot<Map<String, dynamic>>> getUserDataByEmail(
      String userId) async {
    final userRef = FirebaseFirestore.instance.collection('orders');
    return await userRef.where('userId', isEqualTo: userId).get();
  }

  Map<String, dynamic>? userData;
  void data() async {
    final User? currentUser = FirebaseAuth.instance.currentUser;
    final String? userId = currentUser?.uid;

    if (userId != null) {
      final snapshot = await getUserDataByEmail(userId);
      if (snapshot.docs.isNotEmpty) {
        setState(() {
          userData = snapshot.docs.first.data();
          print(userData);
        });
      }
    }
  }

  none() {}
  @override
  void initState() {
    super.initState();
    data();
  }

  @override
  Widget build(BuildContext context) {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;
    String userId = user!.uid;
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('orders')
            .where('userId', isEqualTo: userId)
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData)
            return Center(child: CircularProgressIndicator());
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return Center(child: CircularProgressIndicator());
            case ConnectionState.none:
              break;
            case ConnectionState.active:
              break;
            case ConnectionState.done:
              break;
          }
          if (snapshot.data!.docs.length > 0) {
            return ListView(
              children: [
                Text(
                  "Orders",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 50,
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                    fontFamily: 'Thasadith',
                  ),
                ),
                ListView.builder(
                  primary: false,
                  padding: EdgeInsets.only(left: 6, right: 6),
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    DocumentSnapshot document = snapshot.data!.docs[index];
                    Map<String, dynamic> orderData =
                        document.data() as Map<String, dynamic>;
                    return Container(
                      decoration: BoxDecoration(
                        border: Border.all(width: 0.3),
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                      ),
                      margin: EdgeInsets.only(top: 10, bottom: 10),
                      child: ElevatedButton(
                        onPressed: () {},
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Image(
                              image: NetworkImage(orderData['image_url']),
                              width: 90,
                              height: 120,
                            ),
                            Column(
                              children: [
                                Text(
                                  orderData['name'],
                                  style: TextStyle(
                                    fontFamily: 'OpenSans',
                                  ),
                                ),
                                Text(
                                  orderData['price'].toString(),
                                  style: TextStyle(
                                    fontFamily: 'OpenSans',
                                    color: Colors.amberAccent,
                                    fontWeight: FontWeight.w800,
                                    fontSize: 20,
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                Text(
                                  orderData['color'],
                                  style: TextStyle(
                                    fontFamily: 'OpenSans',
                                  ),
                                ),
                                Text(
                                  orderData['size'],
                                  style: TextStyle(
                                    fontFamily: 'OpenSans',
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              'Delivered',
                              style: TextStyle(
                                color: Colors.white,
                                backgroundColor: Colors.green,
                              ),
                            )
                          ],
                        ),
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                          elevation: 1,
                          backgroundColor: Colors.white,
                        ),
                      ),
                    );
                  },
                ),
              ],
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
