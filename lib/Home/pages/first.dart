import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerceapp/Home/pages/cart.dart';
import 'package:ecommerceapp/Home/pages/firebase_data.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class First extends StatefulWidget {
  const First({Key? key}) : super(key: key);

  @override
  _FirstState createState() => _FirstState();
}

class _FirstState extends State<First> {
  List<DocumentSnapshot> searchResults = [];
  bool isSearching = false;

  Future<void> searchProducts(String keyword) async {
    if (keyword.isEmpty) {
      clearSearch();
      return;
    }

    final QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('data')
        .where('name', isGreaterThanOrEqualTo: keyword)
        .where('name', isLessThan: keyword + 'z')
        .get();
    setState(() {
      searchResults = snapshot.docs;
      isSearching = true;
    });
  }

  void clearSearch() {
    setState(() {
      searchResults.clear();
      isSearching = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          ListView(
            padding: EdgeInsets.all(10),
            children: <Widget>[
              TextField(
                onChanged: (value) {
                  searchProducts(value);
                },
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.search),
                  filled: true,
                  fillColor: Colors.black12,
                  hintText: 'Search for  Shirts , Jackets , Pants ...',
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black12),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black12),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black12),
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              ),
              SizedBox(height: 15),

              txt('Shirts'),
              // Replace with your desired content
              FireBaseData(
                typeFilter: 'Shirts',
              ),
              txt('Jackets'),
              // Replace with your desired content
              FireBaseData(
                typeFilter: 'Jackets',
              ),
              txt('Pants'),
              // Replace with your desired content
              FireBaseData(
                typeFilter: 'Pants',
              ),
              txt('Shoes'),
              FireBaseData(
                typeFilter: 'Shoes',
              ),
              // Replace with your desired content
            ],
          ),
          if (isSearching && searchResults.isNotEmpty)
            Positioned(
              top: 60,
              left: 0,
              right: 0,
              bottom: 0,
              child: GestureDetector(
                onTap: clearSearch,
                child: Container(
                  child: ListView(
                    padding: EdgeInsets.all(10),
                    children: searchResults.map((document) {
                      final product = document.data() as Map<String, dynamic>;
                      return Container(
                        color: Colors.white,
                        child: ListTile(
                          title: Text(product['name']),
                          subtitle: Text(product['brand']),
                          trailing: Image.network(product['image_url']),
                          onTap: () {
                            Get.to(Cart(
                              posts: document,
                            ));
                          },
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

txt(txt) {
  return Column(
    children: [
      Text(
        txt,
        style: TextStyle(
          fontSize: 30,
          fontFamily: 'Indie',
        ),
      ),
      SizedBox(
        height: 15,
      ),
    ],
  );
}
