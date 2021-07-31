import 'package:flutter/material.dart';
import 'package:flutter_open/config/color.dart';
import 'package:flutter_open/config/string.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Container _currentBody = Container(
    color: Colors.red,
  );
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: Scaffold(
        body: _currentBody,
        bottomNavigationBar: BottomNavigationBar(
          items: _items(),
          currentIndex: _currentIndex,
          onTap: _onTap,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: WgsvenColor.desTextColor,
          unselectedItemColor: WgsvenColor.hitTextColor,
        ),
      ),
    );
  }

  _onTap(int index) {
    _currentIndex = index;
    switch (index) {
      case 0:
        _currentBody = Container(
          color: Colors.red,
        );
        break;
      case 1:
        _currentBody = Container(
          color: Colors.blue,
        );
        break;
      case 2:
        _currentBody = Container(
          color: Colors.yellow,
        );
        break;
      case 3:
        _currentBody = Container(
          color: Colors.teal,
        );
        break;
    }
    setState(() {});
  }

  List<BottomNavigationBarItem> _items() {
    return [
      _item(WgsvenString.home, "images/ic_home_normal.png",
          "images/ic_home_selected.png"),
      _item(WgsvenString.discovery, "images/ic_discovery_normal.png",
          "images/ic_discovery_selected.png"),
      _item(WgsvenString.hot, "images/ic_hot_normal.png",
          "images/ic_hot_selected.png"),
      _item(WgsvenString.mine, "images/ic_mine_normal.png",
          "images/ic_mine_selected.png"),
    ];
  }

  BottomNavigationBarItem _item(
      String title, String normalIcon, String selectedIcon) {
    return BottomNavigationBarItem(
      label: title,
      icon: Image.asset(
        normalIcon,
        width: 24,
        height: 24,
      ),
      activeIcon: Image.asset(
        selectedIcon,
        width: 24,
        height: 24,
      ),
    );
  }
}
