import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'cart.dart';

class FireBaseData extends StatefulWidget {
  final String typeFilter;
  FireBaseData({required this.typeFilter});

  @override
  State<FireBaseData> createState() => _FireBaseDataState();
}

class _FireBaseDataState extends State<FireBaseData> {
  String typeFilter = '';
  @override
  void initState() {
    super.initState();
    typeFilter = widget.typeFilter;
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('data').snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }

        final allPosts = snapshot.data!.docs;
        final filteredPosts = typeFilter.isNotEmpty
            ? allPosts
                .where((post) =>
                    post['type'].toLowerCase() == typeFilter.toLowerCase())
                .toList()
            : allPosts;

        return Padding(
          padding: const EdgeInsets.only(top: 15, left: 0),
          child: Container(
            height: 200,
            child: GridView.builder(
              primary: false,
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 1,
                crossAxisSpacing: 18,
                mainAxisSpacing: 20,
              ),
              itemCount: filteredPosts.length,
              itemBuilder: (context, index) {
                final post = filteredPosts[index];
                return Container(
                  margin: EdgeInsets.all(0),
                  child: ElevatedButton(
                    onPressed: () {
                      Get.to(Cart(
                        posts: post,
                      ));
                    },
                    child: Column(
                      children: [
                        Image(
                          image: NetworkImage(post['image_url']),
                          width: 114,
                          height: 144,
                        ),
                        Text(
                          post['brand'],
                          style: TextStyle(
                            fontFamily: 'OpenSans',
                          ),
                        ),
                        Text(
                          post['name'],
                          style: TextStyle(
                            fontFamily: 'OpenSans',
                          ),
                        ),
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
          ),
        );
      },
    );
  }
}
