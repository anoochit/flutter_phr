import 'dart:developer';
import 'dart:math' as math;

import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:phr/models/bloodpressure.dart';
import 'package:phr/models/bmi.dart';
import 'package:phr/models/glucose.dart';
import 'package:phr/models/settings.dart';

class AppController extends GetxController {
  RxString yourName = "".obs;
  RxString yourImage = "".obs;

  AppController() {
    hiveRegisterAdapter();
  }

  // bmi decode
  // - Underweight = <18.5
  // - Normal weight = 18.5–24.9
  // - Overweight = 25–29.9
  // - Obesity = BMI of 30 or greater
  int bmiDecode({required double bmi}) {
    if (bmi < 18.5) {
      log("bmi status -> 0");
      return 0;
    } else if ((bmi >= 18.5) && (bmi <= 24.9)) {
      log("bmi status -> 1");
      return 1;
    } else if ((bmi >= 25) && (bmi <= 29.9)) {
      log("bmi status -> 2");
      return 2;
    } else {
      log("bmi status -> 3");
      return 3;
    }
  }

  // bmi calculation
  double bmiCalculation({required double weight, required double height}) {
    double bmi = weight / math.pow((height / 100), 2);
    log("bmi value -> " + bmi.toString());
    return bmi;
  }

  // blood pressure calculation
  // 0 - hypo
  // 1 - normal
  // 2 - pre-hyper
  // 3 - hyper state 1
  // 4 - hyper state 2
  int bloodPressureCalculation({required int systolic, required int diastolic}) {
    log(systolic.toString() + "/" + diastolic.toString());
    if ((systolic <= 90) && (diastolic <= 60)) {
      log("bp status -> 0");
      return 0;
    } else if ((systolic <= 120) && (diastolic <= 80)) {
      log("bp status -> 1");
      return 1;
    } else if ((systolic <= 140) && (diastolic <= 90)) {
      log("bp status -> 2");
      return 2;
    } else if ((systolic <= 160) && (diastolic <= 100)) {
      log("bp status -> 3");
      return 3;
    } else {
      log("bp status -> 4");
      return 4;
    }
  }

  // load profile data
  Future<void> loadSettings() async {
    var box = await Hive.openBox<Settings>('Settings');
    var settings = box.get(0) ?? Settings("");
    yourName = RxString(settings.name);
    update();
  }

  setProfile({required String name, required String photo}) {
    yourName = RxString(name);
    yourImage = RxString(photo);
  }

  hiveRegisterAdapter() {
    if (!Hive.isAdapterRegistered(3)) {
      Hive.registerAdapter(SettingsAdapter());
    }

    if (!Hive.isAdapterRegistered(2)) {
      Hive.registerAdapter(GlucoseAdapter());
    }

    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(BmiAdapter());
    }

    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(BloodPressureAdapter());
    }
  }

  Future<Box<Bmi>> loadBMI() async {
    var box = await Hive.openBox<Bmi>('Bmi');
    return box;
  }

  Future<Box<BloodPressure>> loadBloodPressure() async {
    var box = await Hive.openBox<BloodPressure>('BloodPressure');
    return box;
  }

  Future<Box<Glucose>> loadGlucose() async {
    var box = await Hive.openBox<Glucose>('Glucose');
    return box;
  }

  // sample data
  Future<void> addSampleData() async {
    var currentDateTime = DateTime.now();

    // user profile
    var boxProfile = await Hive.openBox<Settings>('Settings');
    boxProfile.put(0, Settings('Dave'));
    log('sample profile -> ${boxProfile.values.first.name}');

    // bmi
    var boxBmi = await Hive.openBox<Bmi>('Bmi');
    boxBmi.put(0, Bmi(currentDateTime, 163, 77, bmiCalculation(weight: 77, height: 163)));
    log('sample bmi -> ${boxBmi.values.first.bmi}');

    // blood pressure
    var boxBp = await Hive.openBox<BloodPressure>('BloodPressure');
    boxBp.put(0, BloodPressure(currentDateTime, 109, 74, 80, bloodPressureCalculation(systolic: 109, diastolic: 74), []));
    log('sample blood pressure sys -> ${boxBp.values.first.systolic}');

    // blood pressure
    var boxGl = await Hive.openBox<Glucose>('Glucose');
    boxGl.put(0, Glucose(currentDateTime, 154, []));
    log('sample glucose -> ${boxGl.values.first.unit}');
  }

  Future<void> clearSampleData() async {
    // user profile
    var box = await Hive.openBox<Settings>('Settings');
  }
}
