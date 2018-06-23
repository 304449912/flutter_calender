import 'package:flutter/material.dart';
import 'package:flutter_calendar_example/styles.dart';
import 'list.dart';

class ListViewContent extends StatelessWidget {
  final Animation<double> listTileWidth;
  final Animation<Alignment> listSlideAnimation;
  final Animation<EdgeInsets> listSlidePosition;
  ListViewContent({
    this.listSlideAnimation,
    this.listSlidePosition,
    this.listTileWidth,
  });
  @override
  Widget build(BuildContext context) {
    return (new Column(
      children: <Widget>[
        new ListData(
            title: "prada",
            subtitle: "7 - 8am Workout",
            image: avatar6),
        new ListData(
            title: "陈晨",
            subtitle: "9 - 10am ",
            image: avatar1),
        new ListData(
            title: "陈孟晓",
            subtitle: "我要的是属于自己的天空",
            image: avatar5),
        new ListData(
            title: "王御景",
            subtitle: "田真真了",
            image: avatar4),
        new ListData(
            title: "陪伴",
            subtitle: "树欲静而风不止",
            image: avatar2),
        new ListData(
            title: "Sunflower",
            subtitle: "以万变应万变",
            image: avatar3),
      ],
    ));
  }
}

