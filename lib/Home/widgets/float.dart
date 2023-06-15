import 'package:flutter/material.dart';

class Float extends StatefulWidget {
  const Float({Key? key}) : super(key: key);

  @override
  _FloatState createState() => _FloatState();
}

class _FloatState extends State<Float> {
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {},
      backgroundColor: Colors.black,
      child: IconButton(
        onPressed: () {},
        icon: Icon(Icons.add),
      ),
    );
  }
}
