import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:async';
import './common/date.dart';
import './types/index.dart';

typedef DateChangedCallback(DateTime time);
typedef CancelCallback();
typedef String StringAtIndexCallBack(int index);

final padding = EdgeInsets.all(6.0);
final headerHeight = 48;
final startTime = null; // DateTime.parse('2018-05-16 08:21');
final endTime = null; // DateTime.parse('2022-05-06 09:21');

/// current, start, end 传入时间字符串或者DateTime均可
///
class MyDatePicker extends StatefulWidget {
  final DateTime now = new DateTime.now();

  final double itemHeight;
  final DateTime current;
  final DateTime start;
  final DateTime end;
  final DateChangedCallback onChange;
  final DateChangedCallback onConfirm;
  final CancelCallback onCancel;
  final MyPickerMode mode;
  final bool isShowHeader;
  final double magnification;
  final double offAxisFraction;
  final double squeeze;
  final Color color;
  final Color background;

  MyDatePicker(
      {current,
      start,
      end,
      this.itemHeight = 36,
      this.magnification = 1.2,
      this.offAxisFraction = 0.2,
      this.squeeze = 1.45,
      this.onChange,
      this.onConfirm,
      this.onCancel,
      this.color,
      this.background,
      isShowHeader = true,
      this.mode = MyPickerMode.date})
      : this.current =
            current != null ? MyDate.parse(current) : MyDate.getNow(),
        this.start = start != null ? MyDate.parse(start) : startTime,
        this.end = end != null ? MyDate.parse(end) : endTime,
        this.isShowHeader = isShowHeader ?? true;

  get pickerHeight => itemHeight * 5 + padding.top + padding.bottom;
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
  final DateTime now = new DateTime.now();
  int yearIndex = 0;
  int monthIndex = 0;
  int dayIndex = 0;
  int hourIndex = 0;
  int minuteIndex = 0;

  /// 上一次回调的时间
  DateTime _last;
  // 如果是手动滚动，不要触发onChange
  bool _isScroll = false;

  /// 定时器
  Timer timer;

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
    if (!(widget.mode == MyPickerMode.year ||
        widget.mode == MyPickerMode.time)) {
      setMonthCtrl();
    }
  }

  String stringIndexByYear(int index) {
    if (index >= -100 && index <= 100) {
      int _year = now.year + index;
      DateTime _nowDate = DateTime(_year);
      DateTime start =
          widget.start == null ? null : DateTime(widget.start.year);
      DateTime end = widget.end == null ? null : DateTime(widget.end.year);

      return MyDate.isInRange(_nowDate, start, end)
          ? _year.toString() + '年'
          : null;
    }
    return null;
  }

  changeMonth(index) {
    if (index == monthIndex) return;

    setState(() {
      monthIndex = index;
    });
    if (!(widget.mode == MyPickerMode.year ||
        widget.mode == MyPickerMode.month ||
        widget.mode == MyPickerMode.time)) {
      setDayCtrl();
    }
  }

  String stringIndexByMonth(int index) {
    if (index >= 0 && index <= 11) {
      int _monthIndex = index + 1;
      DateTime _nowDate = DateTime(now.year + yearIndex, _monthIndex);
      DateTime start = widget.start == null
          ? null
          : DateTime(widget.start.year, widget.start.month);
      DateTime end = widget.end == null
          ? null
          : DateTime(widget.end.year, widget.end.month);

      return MyDate.isInRange(_nowDate, start, end)
          ? (index + 1).toString() + '月'
          : null;
    }
    return null;
  }

  setMonthCtrl() {
    int max = 11;
    int min = 0;

    if (widget.end != null) {
      max =
          now.year + yearIndex == widget.end.year ? (widget.end.month - 1) : 11;
    }
    if (widget.start != null) {
      min = now.year + yearIndex == widget.start.year
          ? (widget.start.month - 1)
          : 0;
    }

    scrollItem(monthIndex, monthScrollCtrl, min, max);
  }

  setScroll(fn) {
    _isScroll = true;
    fn();
    _isScroll = false;
  }

  setDayCtrl() {
    int days = getDays();
    int max = days - 1;
    int min = 0;

    if (widget.end != null) {
      max = (now.year + yearIndex == widget.end.year &&
              monthIndex == (widget.end.month - 1))
          ? (widget.end.day - 1)
          : max;
    }
    if (widget.start != null) {
      min = (now.year + yearIndex == widget.start.year &&
              monthIndex == (widget.start.month - 1))
          ? (widget.start.day - 1)
          : min;
    }

    scrollItem(dayIndex, dayScrollCtrl, min, max);
  }

  scrollItem(int index, FixedExtentScrollController ctrl, int min, int max) {
    if (index > max) {
      setScroll(() {
        ctrl.jumpToItem(max);
      });
    } else if (index < min) {
      setScroll(() {
        ctrl.jumpToItem(min);
      });
    } else {
      setScroll(() {
        ctrl.jumpToItem(index - 1);
        ctrl.jumpToItem(index);
      });
    }
  }

  changeDay(index) {
    if (index == dayIndex) return;

    setState(() {
      dayIndex = index;
    });

    if (widget.mode == MyPickerMode.dateTime) {
      setHourCtrl();
    }
  }

  setHourCtrl() {
    int max = 23;
    int min = 0;

    if (widget.end != null) {
      max = (now.year + yearIndex == widget.end.year &&
              monthIndex == (widget.end.month - 1) &&
              dayIndex == (widget.end.day - 1))
          ? widget.end.hour
          : max;
    }
    if (widget.start != null) {
      min = (now.year + yearIndex == widget.start.year &&
              monthIndex == (widget.start.month - 1) &&
              dayIndex == (widget.start.day - 1))
          ? widget.start.hour
          : min;
    }

    scrollItem(hourIndex, hourScrollCtrl, min, max);
  }

  String stringIndexByDay(int index) {
    int days = getDays();

    if (index >= 0 && index < days) {
      int _index = index + 1;
      DateTime _nowDate =
          DateTime(now.year + yearIndex, monthIndex + 1, _index);
      DateTime start = widget.start == null
          ? null
          : DateTime(widget.start.year, widget.start.month, widget.start.day);
      DateTime end = widget.end == null
          ? null
          : DateTime(widget.end.year, widget.end.month, widget.end.day);

      return MyDate.isInRange(_nowDate, start, end)
          ? _index.toString() + '日'
          : null;
    }
    return null;
  }

  changeHour(index) {
    if (index == hourIndex) return;

    setState(() {
      hourIndex = index;
    });
    if (widget.mode == MyPickerMode.dateTime ||
        widget.mode == MyPickerMode.time) {
      setMinuteCtrl();
    }
  }

  setMinuteCtrl() {
    int max = 59;
    int min = 0;

    if (widget.end != null) {
      max = (now.year + yearIndex == widget.end.year &&
              monthIndex == (widget.end.month - 1) &&
              dayIndex == (widget.end.day - 1) &&
              hourIndex == (widget.end.hour))
          ? widget.end.minute
          : max;
    }
    if (widget.start != null) {
      min = (now.year + yearIndex == widget.start.year &&
              monthIndex == (widget.start.month - 1) &&
              dayIndex == (widget.start.day - 1) &&
              hourIndex == (widget.start.hour))
          ? widget.start.minute
          : min;
    }

    scrollItem(minuteIndex, minuteScrollCtrl, min, max);
  }

  String stringIndexByHour(int index) {
    if (index >= 0 && index < 24) {
      DateTime _nowDate =
          DateTime(now.year + yearIndex, monthIndex + 1, dayIndex + 1, index);
      DateTime start = widget.start == null
          ? null
          : DateTime(widget.start.year, widget.start.month, widget.start.day,
              widget.start.hour);
      DateTime end = widget.end == null
          ? null
          : DateTime(widget.end.year, widget.end.month, widget.end.day,
              widget.end.hour);

      return MyDate.isInRange(_nowDate, start, end)
          ? index.toString().padLeft(2, '0') + '时'
          : null;
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
      DateTime _nowDate = DateTime(
          now.year + yearIndex, monthIndex + 1, dayIndex + 1, hourIndex, index);
      DateTime start = widget.start == null
          ? null
          : DateTime(widget.start.year, widget.start.month, widget.start.day,
              widget.start.hour, widget.start.minute);
      DateTime end = widget.end == null
          ? null
          : DateTime(widget.end.year, widget.end.month, widget.end.day,
              widget.end.hour, widget.end.minute);

      return MyDate.isInRange(_nowDate, start, end)
          ? index.toString().padLeft(2, '0') + '分'
          : null;
    }
    return null;
  }

  changeDate(int _) {
    int days =
        MyDate.daysInMonth(new DateTime(now.year + yearIndex, monthIndex + 1));
    DateTime date = new DateTime(now.year + yearIndex, monthIndex + 1,
        dayIndex + 1, hourIndex, minuteIndex);

    /// 加入定时器，方便取消
    /// 防止触发多次
    timer?.cancel();
    timer = Timer(Duration(milliseconds: 5), () {
      if (_last != date && dayIndex < days && !_isScroll) {
        _last = date;
        widget.onChange(date);
      }
    });
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
          height: widget.pickerHeight, // theme.containerHeight
          // decoration: BoxDecoration(color: Colors.white),
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
                  backgroundColor: widget.background ?? Colors.white,
                  scrollController: scrollController,
                  itemExtent: widget.itemHeight, // theme.itemHeight,
                  onSelectedItemChanged: (int index) {
                    selectedChangedWhenScrolling(index);
                  },
                  useMagnifier: true,
                  magnification: widget.magnification,
                  squeeze: widget.squeeze,
                  offAxisFraction: widget.offAxisFraction,
                  itemBuilder: (BuildContext context, int index) {
                    final content = stringAtIndexCB(index);
                    if (content == null) {
                      return null;
                    }
                    return Container(
                      height: widget.itemHeight, // theme.itemHeight,
                      alignment: Alignment.center,
                      child: Text(
                        content,
                        style: const TextStyle(fontSize: 18).copyWith(
                            color: widget.color ??
                                Color(0xFF000046)), // theme.itemStyle,
                        textAlign: TextAlign.start,
                      ),
                    );
                  }))),
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

  @override
  Widget build(BuildContext context) {
    return Container(
      // color: widget.color ?? Colors.white,
      height: widget.pickerHeight + (widget.isShowHeader ? headerHeight : 0),
      child: Column(
        children: <Widget>[
          if (widget.isShowHeader) renderHeader(),
          renderSheet(context),
        ],
      ),
    );
  }
}
