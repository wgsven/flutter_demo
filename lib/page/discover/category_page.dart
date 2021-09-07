import 'package:animations/animations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_open/page/discover/category_detail_page.dart';
import 'package:flutter_open/utils/cached_network_image_provider.dart';
import 'package:flutter_open/viewmodel/base_widget.dart';
import 'package:flutter_open/viewmodel/discovery/category_viewmodel.dart';

class CategoryPage extends StatefulWidget {
  @override
  _CategoryPageState createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  @override
  Widget build(BuildContext context) {
    return ProviderWidget<CategoryViewModel>(
        model: CategoryViewModel(),
        onModelInit: (model) => model.requestData(),
        builder: (context, model, child) {
          return Container(
            padding: EdgeInsets.all(5),
            child: GridView.builder(
                itemCount: model.itemList.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, //交叉轴两个
                    mainAxisSpacing: 5, //主轴间距5
                    crossAxisSpacing: 5 //交叉轴间距5
                    ),
                itemBuilder: (BuildContext context, int index) {
                  return OpenContainer(
                    closedBuilder: (context, action) {
                      return _closedBuilder(model, index);
                    },
                    openBuilder: (context, action) {
                      return CategoryDetailPage(
                        categoryModel: model.itemList[index],
                      );
                    },
                    // openBuilder: ,
                  );
                }),
          );
        });
  }

  Widget _closedBuilder(CategoryViewModel model, int index) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: cacheImage(model.itemList[index].bgPicture ?? ""),
        ),
        Center(
          child: Text(
            "#${model.itemList[index].name ?? ""}",
            style: TextStyle(
                color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
          ),
        )
      ],
    );
  }
}
