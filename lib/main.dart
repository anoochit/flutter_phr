import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:phr/models/settings.dart';
import 'package:phr/pages/settings/settings.dart';
import 'package:phr/themes/theme.dart';
import 'const.dart';
import 'controllers/app_controller.dart';
import 'pages/home/home.dart';

Future<void> main() async {
  // initial boxes
  await Hive.initFlutter();
  // register adaptor
  Hive.registerAdapter(SettingsAdapter());
  // open setting box
  boxSettings = await Hive.openBox<Settings>('Settings');
  // run app
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({
    Key? key,
  }) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final AppController appController = Get.put(AppController());

  @override
  void initState() {
    super.initState();
    // Add sample data
    //appController.addSampleData();

    // clear sample data
    //appController.clearSampleData();

    // Load settingd
    appController.loadSettings();
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      builder: (context, child) =>
          MediaQuery(data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true), child: child!),
      debugShowCheckedModeBanner: false,
      title: 'Personal Health Record',
      theme: themeData(context),
      darkTheme: themeDataDark(context),
      // Check setting has data if not goto setting page
      home: (boxSettings.values.isEmpty) ? const SettingPage() : const HomePage(),
    );
  }
}
