# flutter_calendar

 一个使用Flutter 编写的日历组件

## 使用


```dart

    import 'package:flutter_prada_calendar/calendar.dart';


     Map<DateTime, int> map;
     map = new Map();
     map.putIfAbsent(new DateTime.now(), () {
       return 2;
     });
     new CalendarWidget(
        //controller: controller,
        topColor: Colors.blue,
        onDateClick: (time) {
           print(time);
        },
        calendarMap: map,
      )
```



### 1. 效果



![standard view](https://github.com/304449912/flutter_calender/blob/master/screenGif/screen.gif)

***
