// blood pressure type
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hive/hive.dart';

import 'package:phr/models/bloodpressure_typeitem.dart';
import 'package:phr/models/menu.dart';
import 'package:phr/models/settings.dart';
import 'package:phr/pages/bloodpressure/bloodpressure.dart';
import 'package:phr/pages/bmi/bmi.dart';
import 'package:phr/pages/glucose/gluecose.dart';

final List<TypeItem> bloodPressureTypeList = [
  TypeItem(Colors.lightBlue, "Hypotension", "< 90", "< 60"),
  TypeItem(Colors.green, "Normal", "91-120", "61-80"),
  TypeItem(Colors.yellow, "Prehypertension", "121-140", "81-90"),
  TypeItem(Colors.orange, "Stage 1 Hypertension", "141-160", "91-100"),
  TypeItem(Colors.red, "Stage 2 Hypertension", "> 160", "> 100"),
];

final bloodPressureTypeLable = [
  "Hypotension",
  "Normal",
  "Pre-Hypertension",
  "Stage 1 Hypertension",
  "Stage 2 Hypertension",
];

final mainMenu = [
  Menu("BMI", FontAwesomeIcons.weight, const BmiPage()),
  Menu("Blood Pressure", FontAwesomeIcons.heartbeat, const BloodPressurePage()),
  Menu("Blood Glucose", FontAwesomeIcons.candyCane, const GlucosePage()),
];

late final Box<Settings> boxSettings;

const List<Color> listColor = [
  Colors.red,
  Colors.orange,
  Colors.yellow,
  Colors.green,
  Colors.lightBlue,
];

const List<Color> chartColor = [
  Colors.red,
  Colors.orange,
  Colors.green,
];
