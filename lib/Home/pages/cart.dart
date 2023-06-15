import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerceapp/Home/widgets/appbar.dart';
import 'package:ecommerceapp/Home/widgets/button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Cart extends StatefulWidget {
  final DocumentSnapshot posts;

  Cart({required this.posts});

  @override
  _CartState createState() => _CartState();
}

class _CartState extends State<Cart> {
  String index = '';
  String clr = '';

  void addDataToFirestore() async {
    try {
      FirebaseAuth auth = FirebaseAuth.instance;
      User? user = auth.currentUser;
      String userId = user!.uid;
      CollectionReference collectionReference =
          FirebaseFirestore.instance.collection('bag');
      Map<String, dynamic> data = {
        'userId': userId,
        'name': widget.posts['name'],
        'color': clr,
        'fees': widget.posts['fees'] as int,
        'price': widget.posts['price'] as int,
        'size': index,
        'image_url': widget.posts['image_url'],
      };
      await collectionReference.add(data);
      notify(context, 'Added', '${widget.posts['name']} to The Bag');
    } catch (e) {
      print('Error adding data: $e');
    }
  }

  void onColorChanged(dynamic value) {
    setState(() {
      clr = value.toString();
      print(clr);
    });
  }

  Transform buildColorRadio(Color color, String value) {
    return Transform.scale(
      scale: 1.5,
      child: Radio(
        fillColor: MaterialStateColor.resolveWith((states) => color),
        value: value,
        groupValue: clr,
        onChanged: onColorChanged,
      ),
    );
  }

  btnS(txt) {
    return TextButton(
        child: Text(
          txt,
          style: TextStyle(fontSize: 35, color: Colors.amberAccent),
        ),
        onPressed: () {
          setState(() {
            index = txt;
          });
        },
        style: TextButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(50),
            ),
            foregroundColor: Colors.amberAccent,
            padding: EdgeInsets.all(10),
            elevation: 1,
            backgroundColor: Colors.white));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color.fromARGB(245, 255, 255, 255),
        appBar: appBar('', context),
        body: Form(
          child: ListView(
            children: [
              Container(
                decoration: BoxDecoration(
                    color: Color.fromARGB(13, 0, 0, 0),
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(20),
                        bottomRight: Radius.circular(20))),
                child: Center(
                  child: Image.network(widget.posts['image_url']),
                ),
              ),
              Center(
                child: txtT('brand', 'Hind', 30, FontWeight.w900, Colors.black),
              ),
              Padding(
                padding: EdgeInsets.only(right: 20, left: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    txtT('name', 'Thasadith', 27, FontWeight.normal,
                        Colors.black87),
                    SizedBox(
                      height: 5,
                    ),
                    txtS('Price', 'Hind', 20, FontWeight.normal, Colors.black),
                    txtT('price', 'Thasadith', 40, FontWeight.w900,
                        Colors.black),
                    dvid(40),
                    Row(
                      children: [
                        Text(
                          'Size  ',
                          style: TextStyle(
                              fontSize: 20,
                              fontFamily: 'Hind',
                              fontWeight: FontWeight.w200,
                              color: Colors.black45),
                        ),
                        Text(
                          index,
                          style: TextStyle(
                              fontSize: 20,
                              fontFamily: 'Hind',
                              fontWeight: FontWeight.w200,
                              color: Colors.black),
                        ),
                      ],
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        btnS('S'),
                        SizedBox(
                          width: 40,
                        ),
                        btnS('L'),
                        SizedBox(
                          width: 40,
                        ),
                        btnS('X'),
                        SizedBox(
                          width: 40,
                        ),
                        btnS('XL')
                      ],
                    ),
                    dvid(40),
                    Row(
                      children: [
                        Text(
                          'Color  ',
                          style: TextStyle(
                            fontSize: 20,
                            fontFamily: 'Hind',
                            fontWeight: FontWeight.w200,
                            color: Colors.black45,
                          ),
                        ),
                        Text(
                          clr,
                          style: TextStyle(
                            fontSize: 20,
                            fontFamily: 'Hind',
                            fontWeight: FontWeight.w200,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        buildColorRadio(Colors.red, 'Red'),
                        SizedBox(width: 20),
                        buildColorRadio(Colors.blue, 'Blue'),
                        SizedBox(width: 20),
                        buildColorRadio(Colors.amberAccent, 'Yellow'),
                        SizedBox(width: 20),
                        buildColorRadio(Colors.white, 'White'),
                        SizedBox(width: 20),
                        buildColorRadio(Colors.black, 'Black'),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    dvid(30),
                    txtS('About This Item', 'Hind', 20, FontWeight.w200,
                        Colors.black45),
                    txtT('detail', 'Hind', 15, FontWeight.normal, Colors.black),
                    dvid(60),
                    txtS('SHIPPING', 'Hind', 20, FontWeight.w900, Colors.black),
                    Row(
                      children: [
                        txtS(
                          'To :  ',
                          'Hind',
                          20,
                          FontWeight.normal,
                          Colors.black,
                        ),
                        txtT('address', 'Hind', 17, FontWeight.normal,
                            Colors.black)
                      ],
                    ),
                    txtS('Expected to deliver on :  ', 'Hind', 17,
                        FontWeight.normal, Colors.black),
                    txtT('time', 'Hind', 17, FontWeight.normal, Colors.black),
                    SizedBox(
                      height: 100,
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
        bottomSheet: animBtn(addDataToFirestore, 'Add To Cart', Colors.black));
  }

  txtT(dynamic txt, String style, double size, FontWeight w, Color color) {
    return Container(
      constraints: BoxConstraints(maxWidth: double.infinity),
      child: Text(
        widget.posts[txt].toString(),
        style: TextStyle(
            fontSize: size, fontFamily: style, fontWeight: w, color: color),
      ),
    );
  }

  txtS(String txt, String style, double size, FontWeight w, Color color) {
    return Text(
      txt,
      style: TextStyle(
          fontSize: size, fontFamily: style, fontWeight: w, color: color),
    );
  }

  dvid(double num) {
    return SizedBox(
        height: num,
        child: Divider(
          indent: 40,
          endIndent: 40,
          color: Color.fromARGB(50, 0, 0, 0),
        ));
  }
}
