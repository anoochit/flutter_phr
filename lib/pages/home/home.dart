import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:phr/controllers/app_controller.dart';
import 'package:phr/pages/home/blood_pressure_info_widget.dart';
import 'package:phr/pages/home/bmi_info_widget.dart';
import 'package:phr/pages/profile/profile.dart';
import 'package:phr/pages/home/glucose_info_widget.dart';
import 'package:phr/pages/home/menu_widget.dart';
import 'package:phr/pages/statistic/statistic.dart';

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
    // set orientation
    // SystemChrome.setPreferredOrientations([
    //   DeviceOrientation.portraitUp,
    //   DeviceOrientation.portraitDown,
    // ]);
    // load profile settings
    appController.loadSettings();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 8,
        title: GetBuilder<AppController>(
          init: AppController(),
          builder: (controller) {
            log(controller.yourImage.toString());
            return Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                (controller.yourImage.isNotEmpty)
                    ? CircleAvatar(
                        backgroundImage: FileImage(
                          File(
                            controller.yourImage.toString(),
                          ),
                        ),
                      )
                    : Container(),
                const SizedBox(
                  width: 8.0,
                ),
                Text('${controller.yourName}'),
              ],
            );
          },
        ),
        actions: [
          // IconButton(
          //   onPressed: () => Get.to(() => ProfilePage()),
          //   icon: const Icon(Icons.settings),
          // ),

          // popup menu buttons
          PopupMenuButton(
            itemBuilder: (context) => <PopupMenuEntry>[
              PopupMenuItem(child: Text("Share"), value: 'share'),
              PopupMenuItem(child: Text("Profile"), value: 'settings'),
            ],
            onSelected: (value) {
              log('pop selected -> ' + value.toString());
              // navigate to page
              if (value == 'share') {
                Get.to(() => StatisticPage());
              } else {
                Get.to(() => ProfilePage());
              }
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: const [
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
            ],
          ),
        ),
      ),
    );
  }
}
