# flutter_my_picker

![GitHub](https://img.shields.io/github/license/ma125120/flutter_my_picker.svg)
[![GitHub stars](https://img.shields.io/github/stars/ma125120/flutter_my_picker.svg?style=social&label=Stars)](https://github.com/ma125120/flutter_my_picker)

适用于flutter的有关日期和时间的选择器，支持年份(showYearPicker)、月份(showMonthPicker)、日期(showDatePicker)、时间(showTimePicker)、日期时间(showDateTimePicker)等。

> 支持的平台
> * Android
> * IOS

![image](./gif/1.gif)

## 使用方法

### 依赖安装

- 已发布到pub，可直接使用版本号进行下载
```
dependencies:
  ...
  flutter_my_picker: ^1.0.3
```

如果你想自己发布包，但是发布的时候报错，可以看这里[发布教程](https://github.com/ma125120/study_note/blob/master/flutter/pub.md)

### [使用案例](./example/lib/demo.dart)

导入 ```flutter_my_picker.dart```;
```dart
import 'package:flutter_my_picker/flutter_my_picker.dart';

// 日期操作，需要时引入
import 'package:flutter_my_picker/common/date.dart';
```

#### 年份选择器
```dart
_change(formatString) {
  return (_date) {
    setState(() {
      date = _date;
      dateStr = MyDate.format(formatString, _date);
    });
  };
}

MyPicker.showPicker(
  context: context,
  current: date,
  mode: MyPickerMode.year,
  onChange: _change('yyyy'),
);

// MyPicker.showYearPicker 效果一样，参数同上，不需要mode参数
```

#### 月份选择器
```dart
MyPicker.showPicker(
  context: context,
  current: date,
  mode: MyPickerMode.month,
  onChange: _change('yyyy-MM'),
);

// MyPicker.showMonthPicker 效果一样，参数同上，不需要mode参数
```

#### 日期选择器
```dart
MyPicker.showPicker(
  context: context,
  current: date,
  mode: MyPickerMode.date,
  onChange: _change('yyyy-MM-dd'),
);

// MyPicker.showDatePicker 效果一样，参数同上，不需要mode参数
```

#### 时间选择器
```dart
MyPicker.showPicker(
  context: context,
  current: date,
  mode: MyPickerMode.time,
  onChange: _change('HH:mm'),
);

// MyPicker.showTimePicker 效果一样，参数同上，不需要mode参数
```

#### 日期时间选择器
```dart
MyPicker.showPicker(
  context: context,
  current: date,
  mode: MyPickerMode.dateTime,
  onChange: _change('yyyy-MM-dd HH:mm'),
);

// MyPicker.showDateTimePicker 效果一样，参数同上，不需要mode参数
```

调用 ```MyPicker.showPicker``` 方法调起相关选择器，目前的参数有

### API
MyPicker.showPicker所需要的的参数：

```dart
// 调用 showModalBottomSheet 所需
BuildContext context;

// 当前选中的时间，字符串和DateTime类型皆可，内部做了解析，mode 为 time 时， 可直接传入 '20:12' 的字符串
final dynamic current;
/// 开始时间，不传时表示不限制，mode 为 time 时， 可直接传入 '20:12' 的字符串
final dynamic start;
/// 结束时间，不传时表示不限制，mode 为 time 时， 可直接传入 '20:12' 的字符串
final dynamic end;

// 选中时间结束之后的回调，当滚动未结束时关闭弹窗就不会触发
//typedef DateChangedCallback(DateTime time)
final DateChangedCallback onChange;

// 点击确认按钮之后的回调
//typedef DateChangedCallback(DateTime time)
final DateChangedCallback onConfirm;

// 点击取消按钮之后的回调
//typedef CancelCallback()
final CancelCallback onCancel;

// 选择器模式
/**
enum MyPickerMode {
  year,
  month,
  date,
  time,
  dateTime,
}
*/
final MyPickerMode mode;

// 选择器单行的高度，默认36
final double itemHeight;

/// 挤压系数，默认 1, 建议设置 1.45
final double squeeze;

/// 被选中的内容放大系数，默认 1, 建议设置 1.2
final double magnification;

/// 被选中的内容偏移，默认 0, 建议设置 0.2
final double offAxisFraction; 
```
