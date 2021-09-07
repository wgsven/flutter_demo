import 'package:flutter/material.dart';
import 'package:flutter_open/config/color.dart';
import 'package:flutter_open/config/string.dart';
import 'package:flutter_open/page/discover/discover_page.dart';
import 'package:flutter_open/page/home/home_page.dart';
import 'package:flutter_open/viewmodel/base_widget.dart';
import 'package:flutter_open/viewmodel/tab_navigation_viewmodel.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // body: _currentBody,
      body: ProviderWidget<TabNavigationVm>(
          model: TabNavigationVm(),
          builder: (BuildContext context, TabNavigationVm model, Widget? child) {
            return PageView(
              controller: _pageController,
              physics: NeverScrollableScrollPhysics(),
              // onPageChanged: (index) => model.changeBottomTabIndex(index),//todo 未同步BottomNavigationBar
              children: [
                DiscoveryPage(),
                HomePage(),
                Container(
                  color: Colors.yellow,
                ),
                Container(
                  color: Colors.teal,
                ),
              ],
            );
          }),
      bottomNavigationBar: ProviderWidget<TabNavigationVm>(
        model: TabNavigationVm(),
        builder: (BuildContext context, TabNavigationVm model, Widget? child) {
          return BottomNavigationBar(
            // currentIndex: model.currentIndex,
            currentIndex: getModelIndex(model),
            items: _items(),
            onTap: (index) {
              if (model.currentIndex != index) {
                model.changeBottomTabIndex(index);
                _pageController.jumpToPage(index);
              }
            },
            type: BottomNavigationBarType.fixed,
            selectedItemColor: WgsvenColor.desTextColor,
            unselectedItemColor: WgsvenColor.hitTextColor,
          );
        },
      ),
    );
  }

  int getModelIndex(TabNavigationVm model){
    debugPrint("model.index=${model.currentIndex}");
    return model.currentIndex;
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
