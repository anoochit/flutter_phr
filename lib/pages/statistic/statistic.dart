import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'package:phr/controllers/app_controller.dart';
import 'package:phr/pages/home/blood_pressure_info_widget.dart';
import 'package:phr/pages/home/bmi_info_widget.dart';
import 'package:phr/pages/home/glucose_info_widget.dart';
import 'package:phr/themes/theme.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share/share.dart';

class StatisticPage extends StatefulWidget {
  StatisticPage({Key? key}) : super(key: key);

  @override
  _StatisticPageState createState() => _StatisticPageState();
}

class _StatisticPageState extends State<StatisticPage> {
  AppController appController = Get.find<AppController>();

  late Uint8List imageFile;
  ScreenshotController screenshotController = ScreenshotController();

  // TODO : use imersive ui to full screen
  @override
  void initState() {
    super.initState();
    // TODO : set to full screen
  }

  @override
  void dispose() {
    super.dispose();
    // TODO : set normal screen
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
                        SizedBox(height: 24),

                        // profile image
                        CircleAvatar(
                          radius: 40,
                          backgroundImage: FileImage(File('${appController.yourImage}')),
                        ),
                        SizedBox(height: 8),

                        // profile name
                        Text('${appController.yourName}', style: textTitleStyleBig),
                        SizedBox(height: 16),

                        // BMI statistic
                        BmiInfoWidget(showGraph: false),

                        // Blood pressure statistic
                        BloodPressureWidget(showGraph: false),

                        // Blood glucose statistic
                        GlucoseInfoWidget(showGraph: false),

                        // spacer
                        Spacer()
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
                          child: Text("Save"),
                          onPressed: () {
                            screenshotController.capture(delay: Duration(milliseconds: 100)).then((imageBytes) async {
                              // save to gallery
                              var result = await ImageGallerySaver.saveImage(imageBytes!);
                              log(result.toString());
                              // show sanck bar
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Save image to gallery")));
                            });
                          },
                        ),
                        SizedBox(width: 8.0),
                        ElevatedButton(
                          style: buttonStyleBlue,
                          child: Text("Share"),
                          onPressed: () {
                            screenshotController.capture(delay: Duration(milliseconds: 100)).then((imageBytes) async {
                              // share
                              var directory = await getTemporaryDirectory();
                              String filePath = directory.path + "/snapshot.png";
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
