library flutter_my_picker;

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import './types/index.dart';
export './types/index.dart';
import './common/date.dart';

typedef DateChangedCallback(DateTime time);
typedef String StringAtIndexCallBack(int index);

class MyPicker {
  static showMonthPicker({
    BuildContext context, 
    double height = 216,
    DateChangedCallback onChange,
    current,
  }) async {
    _showBottom(
      context: context,
      child: MyMonthPicker(
        height: height,
        current: current,
        onChange: onChange ?? (date) {
          print('选中日期: ${MyDate.format('yyyy-MM-dd', date)}');
        }
      ),
      height: height,
    );
  }
}

class MyMonthPicker extends StatefulWidget {
  final DateTime now = new DateTime.now();

  final double height;
  final DateTime current;
  final DateChangedCallback onChange;
  final MyPickerMode mode;

  MyMonthPicker({ current, this.height = 216, this.onChange, this.mode = MyPickerMode.date }): 
    this.current = current != null ? MyDate.parse(current) : MyDate.getNow();
  
  get yearIndex => current.year - now.year;
  get monthIndex => current.month - 1;
  get dayIndex => current.day - 1;

  @override
  _MyMonthPickerState createState() => _MyMonthPickerState();
}

class _MyMonthPickerState extends State<MyMonthPicker> {
  final DateTime now = new DateTime.now();
  int yearIndex = 0;
  int monthIndex = 0;
  int dayIndex = 0;
  List dayList = [];
  FixedExtentScrollController yearScrollCtrl, monthScrollCtrl, dayScrollCtrl;

  get _realDate => new DateTime(now.year + yearIndex, monthIndex + 1, dayIndex + 1);
  get days => MyDate.daysInMonth(_realDate);

  int getDays() {
    DateTime date = new DateTime(now.year + yearIndex, monthIndex + 1);
    return MyDate.daysInMonth(date);
  }

  @override
  void initState() {
    super.initState();
    refreshScrollOffset();
  }
  @override
  void dispose() {
    dayScrollCtrl.dispose();
    yearScrollCtrl.dispose();
    monthScrollCtrl.dispose();
    super.dispose();
  }

  void refreshScrollOffset() {
    yearScrollCtrl = new FixedExtentScrollController(
        initialItem: widget.yearIndex);
    monthScrollCtrl = new FixedExtentScrollController(
        initialItem: widget.monthIndex);
    dayScrollCtrl = new FixedExtentScrollController(
        initialItem: widget.dayIndex);
    
    setState(() {
      yearIndex = yearIndex;
      monthIndex = monthIndex;
    });

    _fillDayList();
  }

  _fillDayList() {
    setState(() {
      dayList = List.generate(getDays(), (index) => (index + 1).toString() + '日');
    });
    
  }

  changeYear(index) {
    if (index == yearIndex) return ;

    setState(() {
      yearIndex = index;
    });
    setDay();
  }
  String stringIndexByYear(int index) {
    if (index >= -100 && index <= 30) {
      return (now.year + index).toString() + '年';
    }
    return null;
  }

  changeMonth(index) {
    if (index == monthIndex) return ;
    
    setState(() {
      monthIndex = index;
    });
    setDay();
  }
  String stringIndexByMonth(int index) {
    if (index >= 0 && index <= 11) {
      return (index + 1).toString() + '月';
    }
    return null;
  }

  setDay() {
    int days = getDays();
    
    if (dayIndex >= days) {
      setState(() {
        dayIndex = days - 1;
      });
      dayScrollCtrl.animateToItem(days - 1, duration: Duration(milliseconds: 20), curve: Curves.easeInOut);
    }
    _fillDayList();
  }
  changeDay(index) {
    if (index == dayIndex) return ;
    
    setState(() {
      dayIndex = index;
    });
  }
  String stringIndexByDay(int index) {
    if (index >= 0 && index < dayList.length) {
      return dayList[index];
    }
    return null;
  }

  changeDate(int _) {
    DateTime date = new DateTime(now.year + yearIndex, monthIndex + 1, dayIndex + 1);
    widget.onChange(date);
  }

  Widget _renderColumnView(
      {ValueKey key,
      StringAtIndexCallBack stringAtIndexCB,
      ScrollController scrollController,
      ValueChanged<int> selectedChangedWhenScrolling,
      ValueChanged<int> selectedChangedWhenScrollEnd}) {
    return Expanded(
      // flex: layoutProportion,
      child: Container(
          padding: EdgeInsets.all(8.0),
          height: widget.height, // theme.containerHeight
          decoration:
              BoxDecoration(color: Colors.white),
          child: NotificationListener(
              onNotification: (ScrollNotification notification) {
                if (notification.depth == 0 &&
                    selectedChangedWhenScrollEnd != null &&
                    notification is ScrollEndNotification &&
                    notification.metrics is FixedExtentMetrics) {
                  final FixedExtentMetrics metrics = notification.metrics;
                  final int currentItemIndex = metrics.itemIndex;
                  selectedChangedWhenScrollEnd(currentItemIndex);
                }
                return false;
              },
              child: CupertinoPicker.builder(
                  key: key,
                  backgroundColor: Colors.white,
                  scrollController: scrollController,
                  itemExtent: 36.0,// theme.itemHeight,
                  onSelectedItemChanged: (int index) {
                    selectedChangedWhenScrolling(index);
                  },
                  useMagnifier: true,
                  itemBuilder: (BuildContext context, int index) {
                    final content = stringAtIndexCB(index);
                    if (content == null) {
                      return null;
                    }
                    return Container(
                      height: 36.0,// theme.itemHeight,
                      alignment: Alignment.center,
                      child: Text(
                        content,
                        style: const TextStyle(color: Color(0xFF000046), fontSize: 18),// theme.itemStyle,
                        textAlign: TextAlign.start,
                      ),
                    );
                  }))),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(children: <Widget>[
      _renderColumnView(
        scrollController: yearScrollCtrl,
        selectedChangedWhenScrollEnd: changeDate,
        selectedChangedWhenScrolling: changeYear,
        stringAtIndexCB: stringIndexByYear,
      ),
      _renderColumnView(
        scrollController: monthScrollCtrl,
        selectedChangedWhenScrollEnd: changeDate,
        selectedChangedWhenScrolling: changeMonth,
        stringAtIndexCB: stringIndexByMonth,
      ),
      _renderColumnView(
        scrollController: dayScrollCtrl,
        selectedChangedWhenScrollEnd: changeDate,
        selectedChangedWhenScrolling: changeDay,
        stringAtIndexCB: stringIndexByDay,
      ),
    ],);
  }
}

Future _showBottom({
  BuildContext context, Widget child,
  double height = 216,
}) async {
  return await showModalBottomSheet(context: context,
    backgroundColor: Colors.transparent,
    builder: (_) => Container(
      height: height,
      // margin: EdgeInsets.only(top: 16.0),
      child: child,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(topLeft: const Radius.circular(12), topRight: const Radius.circular(12),),
        // border: Border.all(width: 6.0),
        color: Colors.white
      ),
    )
  );
}