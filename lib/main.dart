import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'controllers/appcontroller.dart';
import 'pages/home.dart';

Future<void> main() async {
  // initial boxes
  await Hive.initFlutter();
  // run app
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final AppController appController = Get.put(AppController());

  @override
  void initState() {
    super.initState();
    // Todo: add sample data
    appController.addSampleData();
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Personal Health Record',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        canvasColor: Colors.grey.shade200,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.white,
          //elevation: 0.0,
          titleTextStyle: TextStyle(
            color: Theme.of(context).textTheme.headline5!.color,
            fontSize: Theme.of(context).textTheme.headline5!.fontSize,
          ),
        ),
        cardTheme: const CardTheme(
          color: Colors.white,
          clipBehavior: Clip.antiAlias,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(8.0)),
          ),
        ),
      ),
      // Todo : check setting has data if not goto setting page
      //home: (boxSettings.values.isEmpty) ? SettingPage() : HomePage(),
      home: HomePage(),
    );
  }
}
