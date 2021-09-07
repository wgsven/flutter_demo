import 'package:flutter/material.dart';
import 'package:flutter_open/config/color.dart';
import 'package:flutter_open/config/string.dart';
import 'package:flutter_open/page/discover/follow_page.dart';
import 'package:flutter_open/widget/appbar.dart';

///发现主页
const TAB_LABEL = ['关注', '分类', '专题', '资讯', '推荐'];

class DiscoveryPage extends StatefulWidget {
  @override
  _DiscoveryPageState createState() => _DiscoveryPageState();
}

class _DiscoveryPageState extends State<
        DiscoveryPage> //SingleTickerProviderStateMixin配合TabController使用，
// AutomaticKeepAliveClientMixin是page页面切换保存状态，类似实现adr中的viewpager懒加载模式，不会重复调用initState方法
    with
        SingleTickerProviderStateMixin,
        AutomaticKeepAliveClientMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: TAB_LABEL.length);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: appbar(WgsvenString.discovery,
          showBack: false,
          bottoms: TabBar(
              labelColor: WgsvenColor.desTextColor,
              labelStyle: TextStyle(fontWeight: FontWeight.bold),
              unselectedLabelStyle: TextStyle(fontWeight: FontWeight.normal),
              unselectedLabelColor: WgsvenColor.hitTextColor,
              indicatorSize: TabBarIndicatorSize.label,
              indicatorColor: Colors.black,
              controller: _tabController,
              tabs: TAB_LABEL
                  .map((table) => Tab(
                        text: table,
                      ))
                  .toList())),
      body: TabBarView(controller: _tabController, children: <Widget>[
        FollowPage(),
        Container(
          color: Colors.blue,
        ),
        Container(
          color: Colors.deepOrange,
        ),
        Container(
          color: Colors.yellow,
        ),
        Container(
          color: Colors.greenAccent,
        ),
        // CategoryPage(),
        // TopicPage(),
        // NewsPage(),
        // RecommendPage(),
      ]),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
