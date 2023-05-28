import 'package:photo_upload/ProfilePage.dart';
import 'package:flutter/material.dart';
import 'MyNavBar.dart';
import 'HomePage.dart';

class MyScreenBuilder extends StatefulWidget {

  @override
  _MyScreenBuilderState createState() => _MyScreenBuilderState();
}

class _MyScreenBuilderState extends State<MyScreenBuilder> {
  int _currentIndex = 0;
  PageController _pageController = PageController(
    initialPage: 0,
  );

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('PhotoUpload'),
        backgroundColor: Colors.black87,
      ),
      body: PageView.builder(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        itemCount: 3, // Number of screens
        itemBuilder: (context, index) {
          return buildScreen(index);
        },
      ),
      bottomNavigationBar: MyNavBar(
        currentIndex: _currentIndex,
        onTabSelected: (index) {
          setState(() {
            _currentIndex = index;
            _pageController.animateToPage(
              index,
              duration: const Duration(milliseconds: 300),
              curve: Curves.ease,
            );
          });
        },
      ),
    );
  }

  Widget buildScreen(int index) {
    switch (index) {
      case 0:
        return ProfilePage();
      case 1:
        return HomeScreen();
      case 2:
        return Center(child: Text('Gallery'));
      default:
        return Container();
    }
  }
}