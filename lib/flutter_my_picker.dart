library flutter_my_picker;

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import './types/index.dart';
export './types/index.dart';
import './common/date.dart';

typedef DateChangedCallback(DateTime time);
typedef CancelCallback();
typedef String StringAtIndexCallBack(int index);

class MyPicker {
  /// 调起各种模式的时间类型选择器
  ///
  /// context 调用 showModalBottomSheet 所需
  ///
  /// height 选择器面板的高度，默认216
  ///
  /// mode MyPickerMode
  /// // 选择器模式
  /// enum MyPickerMode {
  ///  year,
  ///  month,
  ///  date,
  ///  time,
  ///  dateTime,
  /// }
  ///
  /// onChange  typedef DateChangedCallback(DateTime time)
  ///
  /// current 当前选中的时间，字符串和DateTime类型皆可，内部做了解析
  static showPicker({
    BuildContext context,
    double height = 216,
    MyPickerMode mode = MyPickerMode.date,
    DateChangedCallback onChange,
    DateChangedCallback onConfirm,
    CancelCallback onCancel,
    current,
  }) async {
    _showBottom(
      context: context,
      child: MyDatePicker(
          height: height,
          current: current,
          mode: mode,
          onCancel: onCancel ?? () {},
          onConfirm: onConfirm ?? (date) {},
          onChange: onChange ??
              (date) {
                print('选中日期: ${MyDate.format('yyyy-MM-dd', date)}');
              }),
      height: height,
    );
  }

  static showYearPicker({
    BuildContext context,
    double height = 216,
    DateChangedCallback onChange,
    current,
  }) {
    return MyPicker.showPicker(
      context: context,
      height: height,
      mode: MyPickerMode.year,
      onChange: onChange,
      current: current,
    );
  }

  static showMonthPicker({
    BuildContext context,
    double height = 216,
    DateChangedCallback onChange,
    current,
  }) {
    return MyPicker.showPicker(
      context: context,
      height: height,
      mode: MyPickerMode.month,
      onChange: onChange,
      current: current,
    );
  }

  static showDatePicker({
    BuildContext context,
    double height = 216,
    DateChangedCallback onChange,
    current,
  }) {
    return MyPicker.showPicker(
      context: context,
      height: height,
      mode: MyPickerMode.date,
      onChange: onChange,
      current: current,
    );
  }

  static showTimePicker({
    BuildContext context,
    double height = 216,
    DateChangedCallback onChange,
    current,
  }) {
    return MyPicker.showPicker(
      context: context,
      height: height,
      mode: MyPickerMode.time,
      onChange: onChange,
      current: current,
    );
  }

  static showDateTimePicker({
    BuildContext context,
    double height = 216,
    DateChangedCallback onChange,
    current,
  }) {
    return MyPicker.showPicker(
      context: context,
      height: height,
      mode: MyPickerMode.dateTime,
      onChange: onChange,
      current: current,
    );
  }
}

class MyDatePicker extends StatefulWidget {
  final DateTime now = new DateTime.now();

  final double height;
  final DateTime current;
  final DateChangedCallback onChange;
  final DateChangedCallback onConfirm;
  final CancelCallback onCancel;
  final MyPickerMode mode;

  MyDatePicker(
      {current,
      this.height = 216,
      this.onChange,
      this.onConfirm,
      this.onCancel,
      this.mode = MyPickerMode.date})
      : this.current =
            current != null ? MyDate.parse(current) : MyDate.getNow();

  get hideYear => mode == MyPickerMode.time;
  get hideMonth => mode == MyPickerMode.year || mode == MyPickerMode.time;
  get hideDay =>
      mode == MyPickerMode.year ||
      mode == MyPickerMode.month ||
      mode == MyPickerMode.time;
  get hideTime =>
      mode == MyPickerMode.year ||
      mode == MyPickerMode.month ||
      mode == MyPickerMode.date;

  @override
  _MyDatePickerState createState() => _MyDatePickerState();
}

class _MyDatePickerState extends State<MyDatePicker> {
  final padding = EdgeInsets.all(6.0);
  final DateTime now = new DateTime.now();
  int yearIndex = 0;
  int monthIndex = 0;
  int dayIndex = 0;
  int hourIndex = 0;
  int minuteIndex = 0;

  // 如果是手动滚动，不要触发onChange
  bool isScroll = false;
  FixedExtentScrollController yearScrollCtrl,
      monthScrollCtrl,
      dayScrollCtrl,
      hourScrollCtrl,
      minuteScrollCtrl;

  get _realDate => new DateTime(now.year + yearIndex, monthIndex + 1,
      dayIndex + 1, hourIndex, minuteIndex);
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
    hourScrollCtrl.dispose();
    minuteScrollCtrl.dispose();
    dayScrollCtrl.dispose();
    yearScrollCtrl.dispose();
    monthScrollCtrl.dispose();
    super.dispose();
  }

  void refreshScrollOffset() {
    yearIndex = widget.current.year - now.year;
    monthIndex = widget.current.month - 1;
    dayIndex = widget.current.day - 1;
    hourIndex = widget.current.hour;
    minuteIndex = widget.current.minute;

    yearScrollCtrl = new FixedExtentScrollController(initialItem: yearIndex);
    monthScrollCtrl = new FixedExtentScrollController(initialItem: monthIndex);
    dayScrollCtrl = new FixedExtentScrollController(initialItem: dayIndex);
    hourScrollCtrl = new FixedExtentScrollController(initialItem: hourIndex);
    minuteScrollCtrl =
        new FixedExtentScrollController(initialItem: minuteIndex);
  }

  changeYear(index) {
    if (index == yearIndex) return;

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
    if (index == monthIndex) return;

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

    if (dayIndex < days) {
      /**
       * 防止从02/28到03/28不显示后面的数字，触发滚动显示数字
       * 原地滚动不显示，所以先向上滚动，此时dayIndex会从28变成27
       * 再向下滚动，此时dayIndex则会从27变成28
       */
      isScroll = true;
      dayScrollCtrl.jumpToItem(dayIndex - 1);
      dayScrollCtrl.jumpToItem(dayIndex + 1);
      isScroll = false;
    } else {
      /**
       * 从03/30到2月份的时候，由于2月份不存在30号，所以显示到2月的最后一天
       */
      isScroll = true;
      dayScrollCtrl.jumpToItem(days - 1);
      isScroll = false;
    }
  }

  changeDay(index) {
    if (index == dayIndex) return;

    setState(() {
      dayIndex = index;
    });
  }

  String stringIndexByDay(int index) {
    int days = getDays();
    if (index >= 0 && index < days) {
      return (index + 1).toString() + '日';
    }
    return null;
  }

  changeHour(index) {
    if (index == hourIndex) return;

    setState(() {
      hourIndex = index;
    });
  }

  String stringIndexByHour(int index) {
    if (index >= 0 && index < 24) {
      return index.toString().padLeft(2, '0') + '时';
    }
    return null;
  }

  changeMinute(index) {
    if (index == minuteIndex) return;

    setState(() {
      minuteIndex = index;
    });
  }

  String stringIndexByMinute(int index) {
    if (index >= 0 && index < 60) {
      return index.toString().padLeft(2, '0') + '分';
    }
    return null;
  }

  changeDate(int _) {
    int days =
        MyDate.daysInMonth(new DateTime(now.year + yearIndex, monthIndex + 1));
    // 如果天数在本月内并且不是手动滚动中
    if (dayIndex < days && !isScroll) {
      DateTime date = new DateTime(now.year + yearIndex, monthIndex + 1,
          dayIndex + 1, hourIndex, minuteIndex);
      widget.onChange(date);
    }
  }

  onConfirm() {
    DateTime date = new DateTime(now.year + yearIndex, monthIndex + 1,
        dayIndex + 1, hourIndex, minuteIndex);
    widget.onConfirm(date);
    Navigator.of(context).pop();
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
          padding: padding,
          height: widget.height, // theme.containerHeight
          decoration: BoxDecoration(color: Colors.white),
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
                  itemExtent: 36.0, // theme.itemHeight,
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
                      height: 36.0, // theme.itemHeight,
                      alignment: Alignment.center,
                      child: Text(
                        content,
                        style: const TextStyle(
                            color: Color(0xFF000046),
                            fontSize: 18), // theme.itemStyle,
                        textAlign: TextAlign.start,
                      ),
                    );
                  }))),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        renderHeader(),
        renderSheet(context),
      ],
    );
  }

  Widget renderHeader() {
    return Row(
      children: <Widget>[
        FlatButton(
          textColor: Color(0xFF999999),
          child: Text('取消'),
          onPressed: () {
            widget.onCancel();
            Navigator.of(context).pop();
          },
        ),
        FlatButton(
          textColor: Theme.of(context).primaryColor,
          child: Text('确认'),
          onPressed: () {
            onConfirm();
          },
        ),
      ],
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
    );
  }

  Widget renderSheet(BuildContext context) {
    return Row(
      children: <Widget>[
        if (!widget.hideYear)
          _renderColumnView(
            scrollController: yearScrollCtrl,
            selectedChangedWhenScrollEnd: changeDate,
            selectedChangedWhenScrolling: changeYear,
            stringAtIndexCB: stringIndexByYear,
          ),
        if (!widget.hideMonth)
          _renderColumnView(
            scrollController: monthScrollCtrl,
            selectedChangedWhenScrollEnd: changeDate,
            selectedChangedWhenScrolling: changeMonth,
            stringAtIndexCB: stringIndexByMonth,
          ),
        if (!widget.hideDay)
          _renderColumnView(
            scrollController: dayScrollCtrl,
            selectedChangedWhenScrollEnd: changeDate,
            selectedChangedWhenScrolling: changeDay,
            stringAtIndexCB: stringIndexByDay,
          ),
        if (!widget.hideTime)
          _renderColumnView(
            scrollController: hourScrollCtrl,
            selectedChangedWhenScrollEnd: changeDate,
            selectedChangedWhenScrolling: changeHour,
            stringAtIndexCB: stringIndexByHour,
          ),
        if (!widget.hideTime)
          _renderColumnView(
            scrollController: minuteScrollCtrl,
            selectedChangedWhenScrollEnd: changeDate,
            selectedChangedWhenScrolling: changeMinute,
            stringAtIndexCB: stringIndexByMinute,
          ),
      ],
    );
  }
}

Future _showBottom({
  BuildContext context,
  Widget child,
  double height = 216,
}) async {
  return await showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => Container(
            height: height + 48,
            // margin: EdgeInsets.only(top: 16.0),
            child: child,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(12),
                  topRight: const Radius.circular(12),
                ),
                // border: Border.all(width: 6.0),
                color: Colors.white),
          ));
}
