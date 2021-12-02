library flutter_my_picker;

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import './types/index.dart';
export './types/index.dart';
import './picker_view.dart';

class MyPicker {
  /// 调起各种模式的时间类型选择器
  ///
  /// context 调用 showModalBottomSheet 所需
  ///
  /// itemHeight 选择器单行的高度，默认36
  ///
  /// mode MyPickerMode
  /// // 选择器模式
  /// ```
  /// enum MyPickerMode {
  ///  year,
  ///  month,
  ///  date,
  ///  time,
  ///  dateTime,
  /// }
  /// ```
  /// 值发生变化时的回调
  /// onChange  typedef DateChangedCallback(DateTime time)
  ///
  /// 点击确认按钮的回调
  /// onConfirm
  /// ```
  /// typedef DateChangedCallback(DateTime time)
  /// ```
  /// 点击取消按钮的回调
  /// onConfirm
  /// ```
  /// typedef onCancel()
  /// ```
  /// isShowHeader
  /// 是否显示头部的确认和取消按钮
  ///
  /// current 当前选中的时间，字符串和DateTime类型皆可，内部做了解析，mode 为 time 时， 可直接传入 '20:12' 的字符串
  ///
  /// start 开始时间，不传时表示不限制，mode 为 time 时， 可直接传入 '20:12' 的字符串
  ///
  /// end 结束时间，不传时表示不限制，mode 为 time 时， 可直接传入 '20:12' 的字符串
  ///
  /// squeeze 挤压系数，默认 1, 建议设置 1.45
  ///
  /// magnification 被选中的内容放大系数，默认 1, 建议设置 1.2
  ///
  /// offAxisFraction 被选中的内容偏移，默认 0, 建议设置 0.2
  ///
  /// color 字体颜色
  ///
  /// background 背景颜色
  ///
  /// title 标题
  ///
  /// header 自定义头部
  static showPicker({
    required BuildContext context,
    double itemHeight = 36,
    MyPickerMode mode = MyPickerMode.date,
    DateChangedCallback? onChange,
    DateChangedCallback? onConfirm,
    CancelCallback? onCancel,
    bool? isShowHeader = true,
    double magnification = 1,
    double offAxisFraction = 0,
    double squeeze = 1,
    Color? background,
    Color? color,
    Widget? title,
    Widget? header,
    current,
    start,
    end,
  }) async {
    _showBottom(
      background: background,
      context: context,
      child: MyDatePicker(
          header: header,
          title: title,
          itemHeight: itemHeight,
          current: current,
          start: start,
          end: end,
          mode: mode,
          color: color,
          background: background,
          magnification: magnification,
          squeeze: squeeze,
          offAxisFraction: offAxisFraction,
          isShowHeader: isShowHeader,
          onCancel: onCancel ?? () {},
          onConfirm: onConfirm ?? (date) {},
          onChange: onChange ?? (date) {}),
    );
  }

  /// 年份选择器
  static showYearPicker({
    required BuildContext context,
    double itemHeight = 36,
    DateChangedCallback? onChange,
    bool? isShowHeader,
    DateChangedCallback? onConfirm,
    CancelCallback? onCancel,
    current,
    start,
    end,
    Color? background,
    Color? color,
    double magnification = 1,
    double offAxisFraction = 0,
    double squeeze = 1,
    Widget? title,
    Widget? header,
  }) {
    return MyPicker.showPicker(
      header: header,
      title: title,
      context: context,
      itemHeight: itemHeight,
      mode: MyPickerMode.year,
      onChange: onChange,
      current: current,
      start: start,
      end: end,
      squeeze: squeeze,
      color: color,
      background: background,
      offAxisFraction: offAxisFraction,
      isShowHeader: isShowHeader,
      magnification: magnification,
      onCancel: onCancel ?? () {},
      onConfirm: onConfirm ?? (date) {},
    );
  }

  /// 月份选择器
  static showMonthPicker({
    required BuildContext context,
    double itemHeight = 36,
    DateChangedCallback? onChange,
    bool? isShowHeader,
    DateChangedCallback? onConfirm,
    CancelCallback? onCancel,
    current,
    start,
    end,
    Color? background,
    Color? color,
    double magnification = 1,
    double offAxisFraction = 0,
    double squeeze = 1,
    Widget? title,
    Widget? header,
  }) {
    return MyPicker.showPicker(
      header: header,
      title: title,
      context: context,
      itemHeight: itemHeight,
      mode: MyPickerMode.month,
      onChange: onChange,
      current: current,
      start: start,
      end: end,
      color: color,
      background: background,
      squeeze: squeeze,
      offAxisFraction: offAxisFraction,
      isShowHeader: isShowHeader,
      magnification: magnification,
      onCancel: onCancel ?? () {},
      onConfirm: onConfirm ?? (date) {},
    );
  }

  /// 日期选择器
  static showDatePicker({
    required BuildContext context,
    double itemHeight = 36,
    DateChangedCallback? onChange,
    bool? isShowHeader,
    DateChangedCallback? onConfirm,
    CancelCallback? onCancel,
    current,
    start,
    end,
    Color? background,
    Color? color,
    double magnification = 1,
    double offAxisFraction = 0,
    double squeeze = 1,
    Widget? title,
    Widget? header,
  }) {
    return MyPicker.showPicker(
      header: header,
      title: title,
      context: context,
      itemHeight: itemHeight,
      mode: MyPickerMode.date,
      onChange: onChange,
      current: current,
      color: color,
      start: start,
      end: end,
      background: background,
      isShowHeader: isShowHeader,
      squeeze: squeeze,
      offAxisFraction: offAxisFraction,
      magnification: magnification,
      onCancel: onCancel ?? () {},
      onConfirm: onConfirm ?? (date) {},
    );
  }

  /// 时间选择器
  static showTimePicker({
    required BuildContext context,
    double itemHeight = 36,
    DateChangedCallback? onChange,
    bool? isShowHeader,
    DateChangedCallback? onConfirm,
    CancelCallback? onCancel,
    current,
    start,
    end,
    Color? background,
    Color? color,
    double magnification = 1,
    double offAxisFraction = 0,
    double squeeze = 1,
    Widget? title,
    Widget? header,
  }) {
    return MyPicker.showPicker(
      header: header,
      title: title,
      context: context,
      itemHeight: itemHeight,
      mode: MyPickerMode.time,
      onChange: onChange,
      current: current,
      start: start,
      end: end,
      squeeze: squeeze,
      color: color,
      background: background,
      offAxisFraction: offAxisFraction,
      isShowHeader: isShowHeader,
      magnification: magnification,
      onCancel: onCancel ?? () {},
      onConfirm: onConfirm ?? (date) {},
    );
  }

  /// 日期时间选择器
  static showDateTimePicker({
    required BuildContext context,
    double itemHeight = 36,
    DateChangedCallback? onChange,
    bool? isShowHeader,
    DateChangedCallback? onConfirm,
    CancelCallback? onCancel,
    current,
    start,
    end,
    Color? background,
    Color? color,
    double magnification = 1,
    double offAxisFraction = 0,
    double squeeze = 1,
    Widget? title,
    Widget? header,
  }) {
    return MyPicker.showPicker(
      header: header,
      title: title,
      context: context,
      itemHeight: itemHeight,
      mode: MyPickerMode.dateTime,
      onChange: onChange,
      current: current,
      start: start,
      end: end,
      isShowHeader: isShowHeader,
      squeeze: squeeze,
      color: color,
      background: background,
      offAxisFraction: offAxisFraction,
      magnification: magnification,
      onCancel: onCancel ?? () {},
      onConfirm: onConfirm ?? (date) {},
    );
  }
}

Future _showBottom({
  required BuildContext context,
  Widget? child,
  Color? background,
}) async {
  return await showModalBottomSheet(
      context: context,
      isScrollControlled: false,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
        topLeft: const Radius.circular(12),
        topRight: const Radius.circular(12),
      )),
      clipBehavior: Clip.antiAlias,
      backgroundColor: background ?? Colors.white,
      builder: (_) => child!);
}
