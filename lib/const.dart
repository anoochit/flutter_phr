// blood pressure type
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hive/hive.dart';

import 'package:phr/models/bloodpressure_typeitem.dart';
import 'package:phr/models/menu.dart';
import 'package:phr/models/settings.dart';
import 'package:phr/pages/bloodpressure/blood_pressure.dart';
import 'package:phr/pages/bmi/bmi.dart';
import 'package:phr/pages/glucose/gluecose.dart';

final List<TypeItem> bloodPressureTypeList = [
  TypeItem(Colors.lightBlue, "Hypotension", "< 90", "< 60"),
  TypeItem(Colors.green, "Normal", "91-120", "61-80"),
  TypeItem(Colors.amber, "Pre-Hypertension", "121-140", "81-90"),
  TypeItem(Colors.orange, "Stage 1 Hypertension", "141-160", "91-100"),
  TypeItem(Colors.red, "Stage 2 Hypertension", "> 160", "> 100"),
];

final bloodPressureTypeLabel = [
  "Hypotension",
  "Normal",
  "Pre-Hypertension",
  "Stage 1 Hypertension",
  "Stage 2 Hypertension",
];

final bloodPressureTypeGraphLabel = [
  "Hypo",
  "Normal",
  "Pre",
  "Stage 1",
  "Stage 2",
];

final bmiTypeLabel = [
  "Underweight",
  "Normal weight",
  "Overweight",
  "Obesity",
];

final glucoseTypeLabel = [
  "Normal",
  "Impaired Glucose",
  "Diabetic",
  "Unknow",
];

final glucoseWhenLabel = [
  "Fasting",
  "After Eating",
  "2-3 Hrs After Eating",
];

final mainMenu = [
  Menu(
    "Body Mass Index",
    FontAwesomeIcons.weight,
    listColor[1],
    const BmiPage(),
  ),
  Menu(
    "Blood Pressure",
    FontAwesomeIcons.heartbeat,
    listColor[2],
    const BloodPressurePage(),
  ),
  Menu(
    "Blood Glucose",
    FontAwesomeIcons.candyCane,
    listColor[4],
    const GlucosePage(),
  ),
];

late final Box<Settings> boxSettings;

const List<Color> listBmiColor = [
  Colors.lightBlue,
  Colors.green,
  Colors.orange,
  Colors.red,
];

const List<Color> listBloodPressureColor = [
  Colors.lightBlue,
  Colors.green,
  Colors.amber,
  Colors.orange,
  Colors.red,
];

const List<Color> listGlucoseColor = [
  Colors.green,
  Colors.amber,
  Colors.red,
  Colors.grey,
];

const List<Color> listColor = [
  Colors.lightBlue,
  Colors.green,
  Colors.amber,
  Colors.orange,
  Colors.red,
];

const List<Color> listChartColor = [
  Colors.red,
  Colors.orange,
  Colors.green,
];
