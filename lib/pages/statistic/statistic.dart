// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously

import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_gallery_saver_plus/image_gallery_saver_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share/share.dart';

import 'package:phr/controllers/app_controller.dart';
import 'package:phr/pages/home/blood_pressure_info_widget.dart';
import 'package:phr/pages/home/bmi_info_widget.dart';
import 'package:phr/pages/home/glucose_info_widget.dart';
import 'package:phr/themes/theme.dart';

class StatisticPage extends StatefulWidget {
  const StatisticPage({super.key});

  @override
  _StatisticPageState createState() => _StatisticPageState();
}

class _StatisticPageState extends State<StatisticPage> {
  AppController appController = Get.find<AppController>();

  late Uint8List imageFile;
  ScreenshotController screenshotController = ScreenshotController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Stack(
              children: [
                // data
                Screenshot(
                  controller: screenshotController,
                  child: Container(
                    color: Theme.of(context).canvasColor,
                    child: Column(
                      children: [
                        // sizedbox
                        const SizedBox(height: 24),

                        // profile image
                        CircleAvatar(
                          radius: 40,
                          backgroundImage:
                              FileImage(File('${appController.yourImage}')),
                        ),
                        const SizedBox(height: 8),

                        // profile name
                        Text('${appController.yourName}',
                            style: textTitleStyleBig),
                        const SizedBox(height: 16),

                        // BMI statistic
                        const BmiInfoWidget(showGraph: false),

                        // Blood pressure statistic
                        const BloodPressureWidget(showGraph: false),

                        // Blood glucose statistic
                        const GlucoseInfoWidget(showGraph: false),

                        // spacer
                        const Spacer()
                      ],
                    ),
                  ),
                ),
                // buttons
                Positioned(
                  bottom: 24,
                  child: SizedBox(
                    width: constraints.maxWidth,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          style: buttonStyleGreen,
                          child: const Text("Save"),
                          onPressed: () {
                            screenshotController
                                .capture(
                                    delay: const Duration(milliseconds: 100))
                                .then((imageBytes) async {
                              // save to gallery
                              var result =
                                  await ImageGallerySaverPlus.saveImage(
                                      imageBytes!);
                              log(result.toString());
                              // show sanck bar
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text("Save image to gallery")));
                            });
                          },
                        ),
                        const SizedBox(width: 8.0),
                        ElevatedButton(
                          style: buttonStyleBlue,
                          child: const Text("Share"),
                          onPressed: () {
                            screenshotController
                                .capture(
                                    delay: const Duration(milliseconds: 100))
                                .then((imageBytes) async {
                              // share
                              var directory = await getTemporaryDirectory();
                              String filePath =
                                  "${directory.path}/snapshot.png";
                              File file = File(filePath);
                              await file.writeAsBytes(imageBytes!);
                              Share.shareFiles([filePath]);
                            });
                          },
                        )
                      ],
                    ),
                  ),
                )
              ],
            );
          },
        ),
      ),
    );
  }
}
