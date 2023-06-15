import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerceapp/Home/widgets/button.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class Secound extends StatefulWidget {
  const Secound({Key? key}) : super(key: key);

  @override
  _SecoundState createState() => _SecoundState();
}

final TextEditingController typeController = TextEditingController();
final TextEditingController brandController = TextEditingController();
final TextEditingController nameController = TextEditingController();
final TextEditingController priceController = TextEditingController();
final TextEditingController descriptionController = TextEditingController();
final TextEditingController sizeController = TextEditingController();
final TextEditingController colorController = TextEditingController();

class _SecoundState extends State<Secound> {
  File? _image;
  void _selectImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        _image = null;
      }
    });
  }

  void _removeImage() {
    setState(() {
      _image = null;
      notifyE(context);
    });
  }

  void addDataToFirestore() async {
    try {
      CollectionReference collectionReference =
          FirebaseFirestore.instance.collection('data');
      final storage = firebase_storage.FirebaseStorage.instance;
      final imageName = DateTime.now().millisecondsSinceEpoch.toString();
      final imagePath = 'images/$imageName.jpg';

      await storage.ref().child(imagePath).putFile(_image!);

      // Get the image URL
      final imageUrl = await storage.ref().child(imagePath).getDownloadURL();
      // Create a map with the data you want to add
      Map<String, dynamic> data = {
        'brand': brandController.text,
        'name': nameController.text,
        'type': typeController.text,
        'color': colorController.text,
        'detail': descriptionController.text,
        'price': priceController.text,
        'size': sizeController.text,
        'image_url': imageUrl,
      };

      // Add the data to Firestore
      await collectionReference.add(data);
      notify(context, 'Congratulations!', 'Item Published');
    } catch (e) {
      print('Error adding data: $e');
    }
  }

  List<String> devices = ['Type', 'Shirts', 'Jackets', 'Pants', 'Shoes'];
  String selectedDevice = 'Type';

  List<String> sizesize = ['Size', 'S', 'M', 'L', 'XL'];
  String selectedSize = 'Size';

  List<String> colordevice = [
    'Product Color "Near One"',
    'Black',
    'White',
    'Red',
    'Blue',
    'Yellow',
  ];
  String selectedColor = 'Product Color "Near One"';
  @override
  Widget build(BuildContext context) {
    return ListView(padding: EdgeInsets.all(20), children: [
      if (_image == null)
        CircleAvatar(
          radius: 100,
          backgroundColor: Colors.white,
        ),
      if (_image != null)
        CircleAvatar(
          radius: 100,
          backgroundImage: FileImage(_image!),
        ),
      Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        IconButton(
            iconSize: 45,
            onPressed: _selectImage,
            icon: Icon(Icons.add_a_photo)),
        SizedBox(width: 50),
        IconButton(
            iconSize: 45, onPressed: _removeImage, icon: Icon(Icons.delete)),
        SizedBox(
          height: 80,
        )
      ]),
      txtField(
          'Product Brand', Icons.drive_file_rename_outline, brandController),
      txtField('Product Name', Icons.monetization_on_outlined, nameController),
      txtField('Product Price', Icons.description_outlined, priceController),
      txtField(
          'Description', Icons.description_outlined, descriptionController),
      Container(
        width: 150,
        child: DropdownButton(
            dropdownColor: Colors.white,
            isExpanded: true,
            icon: Icon(Icons.arrow_drop_down_circle_outlined),
            onChanged: (value) {
              setState(() {
                selectedDevice = '$value';
                typeController.text = selectedDevice;
              });
            },
            value: selectedDevice,
            items: devices.map((e) {
              return DropdownMenuItem(
                child: Text(
                  e,
                  style: TextStyle(color: Colors.black),
                ),
                value: e,
              );
            }).toList()),
      ),
      Column(
        children: [
          DropdownButton(
              dropdownColor: Colors.white,
              isExpanded: true,
              icon: Icon(Icons.arrow_drop_down_circle_outlined),
              onChanged: (value) {
                setState(() {
                  selectedSize = '$value';
                  sizeController.text = selectedSize;
                });
              },
              value: selectedSize,
              items: sizesize.map((e) {
                return DropdownMenuItem(
                  child: Text(
                    e,
                    style: TextStyle(color: Colors.black),
                  ),
                  value: e,
                );
              }).toList()),
        ],
      ),
      Column(
        children: [
          DropdownButton(
              dropdownColor: Colors.white,
              isExpanded: true,
              icon: Icon(Icons.arrow_drop_down_circle_outlined),
              onChanged: (value) {
                setState(() {
                  selectedColor = '$value';
                  colorController.text = selectedColor;
                });
              },
              value: selectedColor,
              items: colordevice.map((e) {
                return DropdownMenuItem(
                  child: Text(
                    e,
                    style: TextStyle(color: Colors.black),
                  ),
                  value: e,
                );
              }).toList()),
          SizedBox(
            height: 20,
          )
        ],
      ),
      Expanded(
        child: ElevatedButton(
          onPressed: () {
            addDataToFirestore();
          },
          child: Text(
            'Post Product',
            style: TextStyle(color: Colors.amberAccent),
          ),
          style: ElevatedButton.styleFrom(
              elevation: 0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5)),
              backgroundColor: Colors.black),
        ),
      )
    ]);
  }
}

txtField(String txt, var icon, TextEditingController control) {
  return Column(
    children: [
      TextFormField(
        controller: control,
        onSaved: (value) {
          control.text = value!;
        },
        decoration: InputDecoration(
            border: OutlineInputBorder(
                borderSide: BorderSide(width: 1, color: Colors.black),
                borderRadius: BorderRadius.circular(20)),
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(width: 1, color: Colors.black),
                borderRadius: BorderRadius.circular(20)),
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(width: 1, color: Colors.black),
                borderRadius: BorderRadius.circular(20)),
            prefixIcon: Icon(
              icon,
              color: Colors.black,
            ),
            hintText: txt,
            labelText: txt),
        cursorColor: Colors.black,
      ),
      SizedBox(
        height: 10,
      )
    ],
  );
}
