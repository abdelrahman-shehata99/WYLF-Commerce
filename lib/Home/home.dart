import 'package:custom_floating_action_button/custom_floating_action_button.dart';
import 'package:ecommerceapp/Home/pages/first.dart';
import 'package:ecommerceapp/Home/pages/fourth.dart';
import 'package:ecommerceapp/Home/pages/secound.dart';
import 'package:ecommerceapp/Home/pages/third.dart';
import 'package:ecommerceapp/Home/widgets/appbar.dart';
import 'package:ecommerceapp/Home/widgets/sidebar.dart';
import 'package:ecommerceapp/Log/login.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedIndex = 0;
  static const List<Widget> _widgetOptions = [
    First(),
    Secound(),
    Third(),
    Fourth(),
  ];
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget build(BuildContext context) {
    return CustomFloatingActionButton(
      spaceFromRight: 20,
      options: [
        CircleAvatar(
          backgroundColor: Colors.amberAccent,
          child: IconButton(
            icon: Icon(Icons.settings),
            color: Colors.black,
            onPressed: () {
              Get.to(_widgetOptions.elementAt(3));
            },
          ),
        ),
        CircleAvatar(
          backgroundColor: Colors.amberAccent,
          child: Icon(
            Icons.person_outlined,
            color: Colors.black,
          ),
        ),
        CircleAvatar(
          backgroundColor: Colors.amberAccent,
          child: Icon(
            Icons.shopping_basket,
            color: Colors.black,
          ),
        ),
        CircleAvatar(
          child: IconButton(
            onPressed: () {
              Get.to(Login());
            },
            icon: Icon(Icons.logout),
            color: Colors.white,
          ),
          backgroundColor: Colors.red,
        ),
      ],
      type: CustomFloatingActionButtonType.circular,
      openFloatingActionButton: const Icon(
        Icons.add,
        color: Colors.white,
      ),
      closeFloatingActionButton: const Icon(
        Icons.close,
        color: Colors.white,
      ),
      floatinButtonColor: Colors.black,
      body: DefaultTabController(
          length: 4,
          child: Scaffold(
            backgroundColor: Color.fromARGB(255, 247, 247, 247),
            appBar: appBar('Home', context),
            drawer: Sidebar(),
            body: TabBarView(
              children: [_widgetOptions.elementAt(_selectedIndex)],
            ),
            bottomNavigationBar: btmNav(),
          )),
    );
  }

  btmNav() {
    return BottomNavigationBar(
      currentIndex: _selectedIndex,
      selectedItemColor: Colors.amberAccent,
      unselectedItemColor: Colors.black,
      backgroundColor: Colors.white,
      onTap: _onItemTapped,
      selectedFontSize: 15,
      selectedLabelStyle: TextStyle(fontFamily: 'Indie'),
      selectedIconTheme: IconThemeData(size: 30, grade: 20),
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
          backgroundColor: Colors.white,
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.production_quantity_limits_outlined),
          label: 'Add',
          backgroundColor: Colors.white,
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.assignment_return),
          label: 'Return',
          backgroundColor: Colors.white,
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person_2_outlined),
          label: 'Profile',
          backgroundColor: Colors.white,
        ),
      ],
    );
  }
}
