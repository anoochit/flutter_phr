import 'package:flutter/material.dart';

class ChartData {
  String name;
  DateTime dateTime;
  double value;

  ChartData({
    required this.name,
    required this.dateTime,
    required this.value,
  });
}

class ChartDataType {
  String name;
  int type;
  double value;
  Color color;

  ChartDataType(
      {required this.name,
      required this.type,
      required this.value,
      required this.color});
}
