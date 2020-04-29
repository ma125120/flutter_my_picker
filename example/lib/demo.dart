import 'package:flutter/material.dart';
import 'package:flutter_my_picker/flutter_my_picker.dart';
import 'package:flutter_my_picker/common/date.dart';

class DemoPage extends StatefulWidget {
  @override
  _DemoPageState createState() => _DemoPageState();
}

class _DemoPageState extends State<DemoPage> {
  DateTime date;
  String dateStr;

  @override
  void initState() {
    super.initState();
    DateTime _date = new DateTime.now();
    print(MyDate.format('yyyy-MM-dd HH:mm:ss', _date));
    setState(() {
      date = _date;
      dateStr = MyDate.format('yyyy-MM-dd HH:mm:ss', _date);
    });
  }

  _change(formatString) {
    return (_date) {
      print(MyDate.format(formatString, _date));
      setState(() {
        date = _date;
        dateStr = MyDate.format(formatString, _date);
      });
    };
  }

  changeDate(_date) {
    setState(() {
      date = _date;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(top: 8.0),
          width: MediaQuery.of(context).size.width,
          child: Text(
            '当前时间： ${dateStr ?? MyDate.format('yyyy-MM-dd HH:mm:ss', date)}',
            textAlign: TextAlign.center,
          ),
        ),
        _Button('年份选择器', () {
          MyPicker.showPicker(
            context: context,
            current: date,
            mode: MyPickerMode.year,
            onChange: _change('yyyy'),
          );
        }),
        _Button('月份选择器', () {
          MyPicker.showPicker(
              context: context,
              current: date,
              mode: MyPickerMode.month,
              onChange: _change('yyyy-MM'));
        }),
        _Button('日期选择器', () {
          MyPicker.showDatePicker(
            context: context,
            current: date,
            // mode: MyPickerMode.date,
            isShowHeader: false,
            start: '2012-08-12',
            end: MyDate.getNow(),
            onChange: _change('yyyy-MM-dd'),
          );
        }),
        _Button('时间选择器', () {
          MyPicker.showPicker(
            context: context,
            current: date,
            mode: MyPickerMode.time,
            // start: '00:20',
            // end: '21:40',
            onChange: _change('HH:mm'),
          );
        }),
        _Button('日期时间选择器', () {
          MyPicker.showDateTimePicker(
            context: context,
            background: Colors.black,
            color: Colors.white,
            current: date,
            magnification: 1.2,
            squeeze: 1.45,
            offAxisFraction: 0.2,
            onChange: _change('yyyy-MM-dd HH:mm'),
          );
        }),
      ],
    );
  }
}

typedef OnChangeButton();

class _Button extends StatelessWidget {
  final OnChangeButton onPressed;
  final String text;

  _Button(
    this.text,
    this.onPressed,
  );

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      onPressed: onPressed,
      child: Text(text),
    );
  }
}
