import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:phr/controllers/appcontroller.dart';
import 'package:phr/widgets/bloodpressureinfo_widget.dart';
import 'package:phr/widgets/bmiinfo_widget.dart';
import 'package:phr/widgets/footer_widget.dart';
import 'package:phr/widgets/glucoseinfo_widget.dart';
import 'package:phr/widgets/menu_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final AppController appController = Get.find<AppController>();

  @override
  void initState() {
    super.initState();
    // load profile settings
    appController.loadSettings();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: GetBuilder<AppController>(
          init: AppController(),
          builder: (controller) {
            return Text('${controller.yourName}');
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // your info
              //YourInfoWidget(),

              SizedBox(height: 8.0),

              // menu pane
              MenuWidget(),

              // bmi info
              BmiInfoWidget(),

              // blood pressure info
              BloodPressureWidget(),

              // blood glucose info
              GlucoseInfoWidget(),

              // footer widget
              FooterWidget()
            ],
          ),
        ),
      ),
    );
  }
}
