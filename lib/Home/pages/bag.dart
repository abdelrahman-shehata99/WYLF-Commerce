import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerceapp/Home/widgets/appbar.dart';
import 'package:ecommerceapp/Home/widgets/button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Bag extends StatefulWidget {
  const Bag({Key? key}) : super(key: key);

  @override
  _BagState createState() => _BagState();
}

class _BagState extends State<Bag> {
  String? selectedName;
  String? selectedColor;
  String? selectedSize;
  String? selectedImage;
  String? selectedPrice;
  void deleteDocument(String documentId) async {
    try {
      await FirebaseFirestore.instance
          .collection('bag')
          .doc(documentId)
          .delete();
      notifyE(context);
    } catch (e) {
      print('Error deleting document: $e');
    }
  }

  Future<void> addOrder(
      String name, String color, var price, String size, var image) async {
    try {
      FirebaseAuth auth = FirebaseAuth.instance;
      User? user = auth.currentUser;
      String userId = user!.uid;
      CollectionReference collectionReference =
          FirebaseFirestore.instance.collection('orders');
      Map<String, dynamic> data = {
        'userId': userId,
        'name': name,
        'image_url': image,
        'color': color,
        'price': price,
        'size': size,
        'status': 'Delivered',
      };
      await collectionReference.add(data);
      notify(context, 'Congratulations', 'Items Bought Successfully');
    } catch (e) {
      print('Error adding data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;
    String userId = user!.uid;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: appBarS("Bag"),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('bag')
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
            num totalPrice = snapshot.data!.docs.fold(
              0,
              (total, doc) => total + (doc['price'] ?? 0),
            );

            num totalPrice2 = snapshot.data!.docs.fold(
              0,
              (total, doc) => total + (doc['fees'] ?? 0),
            );
            num totalPrice3 = totalPrice2 + totalPrice;
            return ListView(
              children: [
                Text(
                  "My Order",
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
                    DocumentSnapshot posts = snapshot.data!.docs[index];
                    selectedColor = posts['color'];
                    selectedSize = posts['size'];
                    selectedImage = posts['image_url'];
                    selectedName = posts['name'];
                    selectedPrice = posts['price'].toString();
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
                              image: NetworkImage(posts['image_url']),
                              width: 90,
                              height: 120,
                            ),
                            Column(
                              children: [
                                Text(
                                  posts['name'],
                                  style: TextStyle(
                                    fontFamily: 'OpenSans',
                                  ),
                                ),
                                Text(
                                  posts['price'].toString() + " €",
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
                                  posts['color'],
                                  style: TextStyle(
                                    fontFamily: 'OpenSans',
                                  ),
                                ),
                                Text(
                                  posts['size'],
                                  style: TextStyle(
                                    fontFamily: 'OpenSans',
                                  ),
                                ),
                              ],
                            ),
                            IconButton(
                              onPressed: () {
                                deleteDocument(posts.id);
                              },
                              color: Colors.redAccent,
                              icon: Icon(Icons.delete_sweep),
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
                Divider(
                  indent: 20,
                  endIndent: 20,
                  height: 50,
                  thickness: 2,
                  color: Colors.black,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        Text(
                          "Item's total    $totalPrice EGP",
                          style: TextStyle(
                            fontSize: 20,
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          "Delivery fees   $totalPrice2 EGP",
                          style: TextStyle(
                            fontSize: 20,
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          "$totalPrice3 EGP",
                          style: TextStyle(fontSize: 30, color: Colors.green),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
      bottomSheet: BottomSheet(
        onClosing: () {},
        builder: (context) {
          return animBtn(() {
            addOrder(selectedName!, selectedColor!, selectedPrice.toString(),
                    selectedSize!, selectedImage)
                .then((_) {})
                .catchError((error) {});
          }, 'Check Out', Colors.green);
        },
      ),
    );
  }
}
