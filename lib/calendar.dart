import 'package:flutter/material.dart';

class CalendarWidget extends StatefulWidget {
  final ValueChanged<DateTime> onDateClick;
  final CalendarController controller;
  final DecorationImage topBackgroundImage;
  final Color topColor;
  DateTime selectDate;

  CalendarWidget({this.onDateClick, this.controller, this.calendarMap, this.selectDate, this.topBackgroundImage, this.topColor});
  Map<DateTime, int> calendarMap;

  @override
  State<StatefulWidget> createState() => CalendarState();
}

class CalendarController extends ChangeNotifier {
  void scrollToToday() {
    notifyListeners();
  }
}

class CalendarState extends State<CalendarWidget> {
  final pageController = new PageController(initialPage: monthIndexFromTime(new DateTime.now()));
  DateTime selectDate;
  DateTime currentMonth;
  @override
  void initState() {
    if (widget.controller != null) {
      widget.controller.addListener(() {
        pageController.jumpToPage(monthIndexFromTime(new DateTime.now()));
        setState(() {
          selectDate = new DateTime.now();
        });
      });
    }
    selectDate = widget.selectDate;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (currentMonth == null) {
      currentMonth = new DateTime.now();
    }
    List<String> weekdays = ['Su', 'Mo', 'TU', 'We', 'Th', 'Fr', 'Sa'];
    List<Widget> dayHeaders = [];
    for (int i = 0; i < 7; i++) {
      dayHeaders.add(
        new SizedBox(
          width: 40.0,
          height: 30.0,
          child: new Center(
            child: new Text(
              weekdays[i],
              style: new TextStyle(
                  color: widget.topBackgroundImage == null && widget.topColor == null ? Colors.black : Colors.white,
                  fontSize: 12.0,
                  fontWeight: FontWeight.w600),
            ),
          ),
        ),
      );
    }
    return Container(
      color: Colors.white,
      child: Column(
        children: <Widget>[
          new Container(
            padding: new EdgeInsets.only(top: 5.0),
            alignment: Alignment.center,
            decoration: widget.topBackgroundImage == null
                ? widget.topColor == null ? BoxDecoration() : BoxDecoration(color: widget.topColor)
                : BoxDecoration(
                    image: widget.topBackgroundImage,
                  ),
            child: Column(
              children: <Widget>[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    new SizedBox(
                      height: 19.0,
                      child: new Center(
                        child: new Text(
                          '${currentMonth.year} / ${currentMonth.month}',
                          style: new TextStyle(
                              color: widget.topBackgroundImage == null && widget.topColor == null ? Colors.black : Colors.white,
                              fontSize: 12.0,
                              fontWeight: FontWeight.w800),
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: dayHeaders,
                ),
              ],
            ),
          ),
          new Container(
            constraints: new BoxConstraints(minHeight: 240.0, maxHeight: 240.0),
            child: PageView.builder(
              controller: pageController,
              onPageChanged: _onPageChange,
              physics: const PageScrollPhysics(parent: const ClampingScrollPhysics()),
              itemBuilder: (BuildContext context, int index) {
                return new CalendarPage(
                  currentPage: index,
                  onDateClick: widget.onDateClick,
                  calendarMap: widget.calendarMap,
                );
              },
              itemCount: monthIndexFromTime(new DateTime.now()) * 2,
            ),
          ),
        ],
      ),
    );
  }

  void _onPageChange(int index) {
    widget.onDateClick(monthToShow(index));
    setState(() {
      currentMonth = monthToShow(index);
    });
  }
}

const Duration oneDay = const Duration(days: 1);
const Duration week = const Duration(days: 7);

class CalendarPage extends StatefulWidget {
  final String calendarKey;
  final int currentPage;
  final ValueChanged<DateTime> onDateClick;
  final DateTime selectDate;
  Map<DateTime, int> calendarMap;
  CalendarPage({this.calendarKey, this.currentPage, this.onDateClick, this.selectDate, this.calendarMap});

  @override
  State createState() {
    return new CalendarPageState();
  }
}

int monthIndexFromTime(DateTime time) {
  return (time.year - 1970) * 12 + (time.month - 1);
}

DateTime monthToShow(int index) {
  return new DateTime(index ~/ 12 + 1970, index % 12 + 1, 1);
}

class CalendarPageState extends State<CalendarPage> with SingleTickerProviderStateMixin {
  int _monthIndex;

  void initState() {
    super.initState();
    _monthIndex = widget.currentPage;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new ClipRect(
      child: new Container(
        child: new _CalendarMonthDisplay(widget.onDateClick, widget.selectDate == null ? monthToShow(_monthIndex) : widget.selectDate, widget.calendarMap),
      ),
    );
  }
}

class _CalendarEventIndicator extends CustomPainter {
  final double _radius;

  _CalendarEventIndicator(
    this._radius,
  );

  @override
  void paint(Canvas canvas, Size size) {
    if (_radius == null) return;
    canvas.drawCircle(new Offset(_radius, _radius), _radius, new Paint()..color = Colors.red);
  }

  @override
  bool shouldRepaint(_CalendarEventIndicator other) => other._radius == _radius;
}

class _CalendarMonthDisplay extends StatefulWidget {
  final ValueChanged<DateTime> onDateClick;
  DateTime displayDate;
  Map<DateTime, int> calendarMap;
  _CalendarMonthDisplay(this.onDateClick, this.displayDate, this.calendarMap);
  @override
  State<StatefulWidget> createState() => _CalendarMonthDisplayState();
}

class _CalendarMonthDisplayState extends State<_CalendarMonthDisplay> {
  DateTime selectDate;

  Widget _eventIndicator(Widget button, DateTime day) {
    if (day.month == widget.displayDate.month && widget.calendarMap != null) {
      var dayTemp = new DateTime(day.year, day.month, day.day);
      List<Widget> eventIndicators = [];
      if (widget.calendarMap.containsKey(dayTemp)) {
        int size = widget.calendarMap[dayTemp];
        for (int i = 0; i < size; i++) {
          eventIndicators.add(
            Padding(
              padding: EdgeInsets.all(2.0),
              child: SizedBox(
                height: 2.0,
                width: 2.0,
                child: CustomPaint(
                  painter: _CalendarEventIndicator(2.0),
                ),
              ),
            ),
          );
        }
      }
      return new SizedBox(
        width: 40.0,
        height: 40.0,
        child: new Stack(
          children: <Widget>[
            button,
            Container(
              padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 5.0),
              alignment: Alignment(1.0, 1.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisSize: MainAxisSize.max,
                children: eventIndicators,
              ),
            ),
          ],
        ),
      );
    } else {
      return SizedBox(
        width: 40.0,
        height: 40.0,
        child: button,
      );
    }
  }

  Widget _buildButton(ThemeData theme, DateTime day, DateTime nowTime) {
    Widget button;

    if (day.month != widget.displayDate.month) {
      button = SizedBox(width: 1.0);
    } else {
      button = Center(
        child: FlatButton(
          color: day.isAtSameMomentAs(nowTime) ? theme.accentColor : day.isAtSameMomentAs(selectDate) ? Colors.grey : Colors.white,
          shape: CircleBorder(),
          child: Text(
            day.day.toString(),
            style:
                new TextStyle(color: day.isAtSameMomentAs(selectDate) || day.isAtSameMomentAs(nowTime) ? Colors.white : new Color.fromRGBO(140, 151, 178, 1.0)),
          ),
          onPressed: () {
            widget.onDateClick(day);
            setState(() {
              selectDate = day;
            });
          },
          padding: EdgeInsets.zero,
        ),
      );
    }
    return _eventIndicator(button, day);
  }

  @override
  void initState() {
    super.initState();
    selectDate = widget.displayDate;
    if(widget.calendarMap==null){
      widget.calendarMap = new Map();
    }
  }

  @override
  Widget build(BuildContext context) {
    DateTime nowTmp = new DateTime.now();
    DateTime nowTime = new DateTime(nowTmp.year, nowTmp.month, nowTmp.day);

    DateTime topFirst = widget.displayDate;
    topFirst = topFirst.subtract(new Duration(days: topFirst.weekday));
    DateTime topSecond = topFirst.add(week);
    if (topSecond.day == 1) {
      // Opps, out by a week.
      topFirst = topSecond;
      topSecond = topFirst.add(week);
    }
    DateTime topThird = topSecond.add(week);
    DateTime topFourth = topThird.add(week);
    DateTime topFifth = topFourth.add(week);
    DateTime topSixth = topFifth.add(week);

    List<Widget> firstDays = [];
    List<Widget> secondDays = [];
    List<Widget> thirdDays = [];
    List<Widget> fourthDays = [];
    List<Widget> fifthDays = [];
    List<Widget> sixDays = [];
    ThemeData theme = Theme.of(context);

    for (int i = 0; i < 7; i++) {
      // First row.
      firstDays.add(_buildButton(theme, topFirst, nowTime));

      // Second row.
      secondDays.add(_buildButton(theme, topSecond, nowTime));

      // Third row.
      thirdDays.add(_buildButton(theme, topThird, nowTime));

      // Fourth row.
      fourthDays.add(_buildButton(theme, topFourth, nowTime));

      // Fifth row.
      fifthDays.add(_buildButton(theme, topFifth, nowTime));

      // Sixth row.
      sixDays.add(_buildButton(theme, topSixth, nowTime));
      topFirst = topFirst.add(oneDay);
      topSecond = topSecond.add(oneDay);
      topThird = topThird.add(oneDay);
      topFourth = topFourth.add(oneDay);
      topFifth = topFifth.add(oneDay);
      topSixth = topSixth.add(oneDay);
    }

    return new Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        new Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: firstDays,
        ),
        new Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: secondDays,
        ),
        new Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: thirdDays,
        ),
        new Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: fourthDays,
        ),
        new Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: fifthDays,
        ),
        new Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: sixDays,
        ),
      ],
    );
  }
}
