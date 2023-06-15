import 'dart:io';
import 'package:ecommerceapp/Home/widgets/button.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get_storage/get_storage.dart';
import '../Home/widgets/appbar.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'login.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

final TextEditingController emailController = TextEditingController();
final TextEditingController passwordController = TextEditingController();
final TextEditingController phoneController = TextEditingController();
final TextEditingController NameController = TextEditingController();
final TextEditingController countryController = TextEditingController();
final TextEditingController addressController = TextEditingController();
final TextEditingController LevelController = TextEditingController();

class _RegisterState extends State<Register> {
  var file;
  var imgsave;
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

  void createUserWithEmailAndPassword(BuildContext context) async {
    await Firebase.initializeApp();
    FirebaseAuth _auth = FirebaseAuth.instance;
    FirebaseFirestore _firestore = FirebaseFirestore.instance;
    final box = GetStorage();
    final storage = firebase_storage.FirebaseStorage.instance;
    final imageName = DateTime.now().millisecondsSinceEpoch.toString();
    final imagePath = 'images/$imageName.jpg';

    await storage.ref().child(imagePath).putFile(_image!);

    // Get the image URL
    final imageUrl = await storage.ref().child(imagePath).getDownloadURL();
    // save user email
    box.write('email', emailController.text);
    box.write('password', passwordController.text);

    //  String name1=box.read('name')??"";

    try {
      await _auth
          .createUserWithEmailAndPassword(
              email: emailController.text, password: passwordController.text)
          .then((value) async {
        // Navigator.pushNamed(context, '/container');
        // Get.offAll(BottomBar());
      });
    } catch (e) {
      print(e.toString());
      print("ERRORR");
    }
    try {
      await _firestore.collection('users').add({
        'name': NameController.text,
        'country': countryController.text,
        'password': passwordController.text,
        'email': emailController.text,
        'phone': phoneController.text,
        'gender': LevelController.text,
        'address': addressController.text,
        'image_url': imageUrl,
      }).then((value) async {
        notify(context, 'Congrats!', 'Signup Done');
        Get.to(Login());
      });
    } catch (e) {
      print(e.toString());
      print("ERRORR");
    }
  }

  late String email, password, name;
  List<String> courses = ['Gender', 'Male', 'Female'];
  String selectedCourses = 'Gender';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: appBarS('Registration'),
        body: Center(
            child: Form(
          child: ListView(
            padding: EdgeInsets.all(10),
            children: [
              SizedBox(
                height: 30,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (_image != null)
                    CircleAvatar(
                      radius: 80,
                      backgroundImage: FileImage(_image!),
                    ),
                  TextButton(
                      onPressed: _selectImage,
                      child: Text(
                        'Add Photo',
                        style: TextStyle(fontFamily: 'Indie', fontSize: 20),
                      ))
                ],
              ),
              SizedBox(
                height: 10,
              ),
              txtField(
                  'Name Cant Be Larger Than 100 Letter',
                  'Name Cant Be Smaller Than 4 Letter',
                  'Name',
                  Icons.account_box_sharp,
                  TextInputType.name,
                  NameController),
              txtField(
                  'Email Cant Be Larger Than 100 Letter',
                  'Email Cant Be Smaller Than 4 Letter',
                  'Email',
                  Icons.attach_email_outlined,
                  TextInputType.name,
                  emailController),
              txtField(
                  'PassWord Cant Be Larger Than 100 Letter',
                  'Password Cant Be Smaller Than 4 Letter',
                  'Password',
                  Icons.password_outlined,
                  TextInputType.name,
                  passwordController),
              txtField(
                  'Country Cant Be Larger Than 100 Letter',
                  'Country Cant Be Smaller Than 4 Letter',
                  'Country',
                  Icons.location_on,
                  TextInputType.name,
                  countryController),
              txtField(
                  'Address Cant Be Larger Than 100 Letter',
                  'Address Cant Be Smaller Than 4 Letter',
                  'Address',
                  Icons.location_city,
                  TextInputType.name,
                  addressController),
              txtField(
                  'Number Cant Be Larger Than 20 Number',
                  'Number Cant Be Smaller Than 11 Number',
                  'Number',
                  Icons.numbers_outlined,
                  TextInputType.number,
                  phoneController),
              Center(
                  child: Text('Select Gender',
                      style: TextStyle(fontSize: 30, color: Colors.yellow))),
              SizedBox(
                height: 20,
              ),
              Center(
                child: Container(
                  width: 150,
                  child: DropdownButton(
                      dropdownColor: Colors.white,
                      isExpanded: true,
                      icon: Icon(Icons.arrow_drop_down_circle_outlined),
                      onChanged: (value) {
                        setState(() {
                          selectedCourses = '$value';
                        });
                      },
                      onTap: () {
                        LevelController.text = selectedCourses;
                      },
                      value: selectedCourses,
                      items: courses.map((e) {
                        return DropdownMenuItem(
                          child: Text(
                            e,
                            style: TextStyle(color: Colors.black),
                          ),
                          value: e,
                        );
                      }).toList()),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    createUserWithEmailAndPassword(context);
                  },
                  child: Text(
                    'Submit',
                    style: TextStyle(color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5)),
                      backgroundColor: Colors.black),
                ),
              )
            ],
          ),
        )));
  }
}

txtField(String txtF, txtS, txtT, IconData icon, TextInputType type,
    TextEditingController control) {
  return Column(
    children: [
      TextFormField(
          controller: control,
          onSaved: (value) {
            control.text = value!;
          },
          validator: (value) {
            if (value!.length > 100) {
              return txtF;
            }
            if (value.length < 4) {
              return txtS;
            }
            return null;
          },
          cursorRadius: Radius.circular(20),
          keyboardType: type,
          decoration: InputDecoration(
            prefixIcon: Icon(icon),
            hintText: txtT,
            labelText: txtT,
            border: OutlineInputBorder(
                borderSide: BorderSide(width: 1, color: Colors.black),
                borderRadius: BorderRadius.circular(30)),
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(width: 1, color: Colors.black),
                borderRadius: BorderRadius.circular(30)),
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(width: 1, color: Colors.black),
                borderRadius: BorderRadius.circular(30)),
          )),
      SizedBox(
        height: 20,
      ),
    ],
  );
}
