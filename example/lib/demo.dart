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
    setState(() {
      date = MyDate.getNow();
    });
  }

  _change(formatString) {
    return (_date) {
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
          child: Text('当前时间： ${dateStr ?? MyDate.format('yyyy-MM-dd HH:mm:ss', date)}', textAlign: TextAlign.center,),
        ),

        _Button('月份选择器', () {
          MyPicker.showMonthPicker(
            context: context,
            current: date,
            onChange: _change('yyyy-MM'),
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

  _Button( this.text, this.onPressed, );

  @override
  Widget build(BuildContext context) {
    return RaisedButton(onPressed: onPressed, child: Text(text),);
  }
}