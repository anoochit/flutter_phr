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
    log("load -> settings");
    final box = await Hive.openBox<Settings>('Settings');
    final settings = box.get(0) ?? Settings("", "");
    yourName = RxString(settings.name);
    yourImage = RxString(settings.photo);
    update();
  }

  // set profile to controller
  setProfile({required String name, required String photo}) {
    yourName = RxString(name);
    yourImage = RxString(photo);
    update();
  }

  // register hive adaptor
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

  // load bmi
  Future<Box<Bmi>> loadBMI() async {
    final box = await Hive.openBox<Bmi>('Bmi');
    return box;
  }

  // load blood pressure
  Future<Box<BloodPressure>> loadBloodPressure() async {
    final box = await Hive.openBox<BloodPressure>('BloodPressure');
    return box;
  }

  // load glucose
  Future<Box<Glucose>> loadGlucose() async {
    final box = await Hive.openBox<Glucose>('Glucose');
    return box;
  }

  // add user profile
  addProfile({required String name, required String photo}) async {
    final box = await Hive.openBox<Settings>('Settings');
    box.put(0, Settings(name, photo));
    setProfile(name: name, photo: photo);
  }

  // add bmi
  addBmi({required DateTime dateTime, required double height, required double weight}) async {
    final box = await Hive.openBox<Bmi>('Bmi');
    final bmi = bmiCalculation(weight: weight, height: height);
    final level = bmiDecode(bmi: bmi);
    box.put(dateTime.microsecondsSinceEpoch.toString(), Bmi(dateTime, height, weight, bmi, level));
    update();
  }

  // sample data
  Future<void> addSampleData() async {
    // user profile
    //var boxProfile = await Hive.openBox<Settings>('Settings');
    //boxProfile.put(0, Settings('Dave', ''));
    //log('sample profile -> ${boxProfile.values.first.name}');

    for (int i = 0; i < 10; i++) {
      final dateTime = DateTime.now().subtract(Duration(days: i));
      final key = dateTime.microsecondsSinceEpoch.toString();
      final random = math.Random().nextInt(5);

      // bmi
      final boxBmi = await Hive.openBox<Bmi>('Bmi');
      final bmiValue = bmiCalculation(weight: 77 - random.toDouble(), height: 165);
      final bmiLevel = bmiDecode(bmi: bmiValue);
      boxBmi.put(key, Bmi(dateTime, 165, 77 - random.toDouble(), bmiValue, bmiLevel));
      log('sample bmi -> ${boxBmi.values.first.bmi}');

      // blood pressure
      final boxBp = await Hive.openBox<BloodPressure>('BloodPressure');
      final bpLevel = bloodPressureCalculation(systolic: 109 - random, diastolic: 74 - random);
      boxBp.put(key, BloodPressure(dateTime, 109 - random, 74 - random, 80 - random, bpLevel, []));
      log('sample blood pressure sys -> ${boxBp.values.first.systolic}');

      // blood pressure
      final boxGl = await Hive.openBox<Glucose>('Glucose');
      boxGl.put(key, Glucose(dateTime, 154 - random, []));
      log('sample glucose -> ${boxGl.values.first.unit}');
    }
  }

  // Clear sample data
  Future<void> clearSampleData() async {
    // user profile
    final boxSetting = await Hive.openBox<Settings>('Settings');
    final boxBmi = await Hive.openBox<Bmi>('Bmi');
    final boxBloodPressure = await Hive.openBox<BloodPressure>('BloodPressure');
    final boxGlucose = await Hive.openBox<Glucose>('Glucose');
    //boxSetting.clear();
    boxBmi.clear();
    boxBloodPressure.clear();
    boxGlucose.clear();
    update();
  }
}
