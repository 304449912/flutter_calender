import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_prada_calendar/calendar.dart';
import 'package:flutter_calendar_example/list_view_container.dart';
import 'package:flutter_calendar_example/styles.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Calender',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new MyHomePage(title: 'Calender'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  CalendarController controller;
  Map<DateTime, int> map;
  bool hasData;

  @override
  void initState() {
    controller = new CalendarController();
    map = new Map();
    map.putIfAbsent(new DateTime.now(), () {
      return 2;
    });
    map.putIfAbsent(new DateTime(2018, 06, 1), () {
      return 1;
    });
    map.putIfAbsent(new DateTime(2018, 07, 1), () {
      return 2;
    });
    map.putIfAbsent(new DateTime(2018, 01, 3), () {
      return 1;
    });
    map.putIfAbsent(new DateTime(2018, 05, 3), () {
      return 2;
    });
    map.putIfAbsent(new DateTime(2018, 06, 3), () {
      return 3;
    });
    map.putIfAbsent(new DateTime(2018, 06, 12), () {
      return 2;
    });
    map.putIfAbsent(new DateTime(2018, 06, 13), () {
      return 1;
    });
    map.putIfAbsent(new DateTime(2018, 06, 19), () {
      return 2;
    });
    map.putIfAbsent(new DateTime(2018, 06, 9), () {
      return 5;
    });
    map.putIfAbsent(new DateTime(2018, 11, 1), () {
      return 2;
    });
    map.putIfAbsent(new DateTime(2018, 05, 12), () {
      return 2;
    });
    map.putIfAbsent(new DateTime(2018, 05, 11), () {
      return 3;
    });
    hasData = map.containsKey(new DateTime.now());

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return (new Scaffold(
      appBar: new AppBar(
        elevation: 0.0,
        title: new Text(widget.title),
        centerTitle: true,
        actions: <Widget>[
          new GestureDetector(
            onTap: _goToday,
            child: Padding(
              padding: EdgeInsets.fromLTRB(0.0, 0.0, 10.0, 0.0),
              child: Center(
                child: Text("今天"),
              ),
            ),
          ),
        ],
      ),
      body: new Container(
        width: screenSize.width,
        height: screenSize.height,
        child: new Stack(
          children: <Widget>[
            new ListView(
              shrinkWrap: true,
              padding: const EdgeInsets.all(0.0),
              children: <Widget>[
                new Container(
                  constraints: new BoxConstraints(minHeight: 300.0, maxHeight: 300.0),
                  decoration: new BoxDecoration(image: bgTop),
                  child: new CalendarWidget(
                    controller: controller,
                    topColor: Colors.blue,
                    onDateClick: (time) {
                      setState(() {
                        hasData = map.containsKey(time);
                      });
                    },
                    calendarMap: map,
                  ),
                ),
                hasData
                    ? new ListViewContent()
                    : new Container(
                  constraints: new BoxConstraints(maxHeight: 250.0,minHeight: 250.0),
                  child: new Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      new Container(
                          margin: new EdgeInsets.only(left: 20.0, top: 10.0, bottom: 10.0, right: 20.0),
                          width: 60.0,
                          height: 60.0,
                          decoration: new BoxDecoration(
                              shape: BoxShape.circle,
                              image: noDataImage)),
                      Text("没有数据")
                    ],
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    ));
  }

  void _goToday() {
    controller.scrollToToday();
  }
}
