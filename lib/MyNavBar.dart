import 'package:flutter/material.dart';
import 'MyScreenBuilder.dart';

class MyNavBar extends StatefulWidget {
  final Function(int) onTabSelected;
  int currentIndex;
  MyNavBar({
    required this.onTabSelected,
    required this.currentIndex
  });

  @override
  _MyNavBarState createState() => _MyNavBarState();
}

class _MyNavBarState extends State<MyNavBar> {

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: widget.currentIndex,
      onTap: (index) {
        setState(() {
          widget.currentIndex = index;
        });
        widget.onTabSelected(index);
      },
      selectedItemColor:Colors.black87,
      unselectedItemColor: Colors.grey,
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Profile',
          backgroundColor: Colors.black87,

        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.camera_alt),
          label: 'Camera',
          backgroundColor: Colors.black87,
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.photo),
          label: 'Gallery',
          backgroundColor: Colors.black87,
        ),
      ],
    );
  }
}
