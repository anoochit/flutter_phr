import 'dart:developer';
import 'dart:io';
import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:phr/const.dart';
import 'package:phr/controllers/appcontroller.dart';
import 'package:phr/models/bloodpressure.dart';
import 'package:phr/models/bmi.dart';
import 'package:phr/models/glucose.dart';
import 'package:phr/themes/theme.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:share/share.dart';

class ProfilePage extends StatelessWidget {
  ProfilePage({Key? key}) : super(key: key);

  final AppController appController = Get.find<AppController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
      ),
      body: LayoutBuilder(builder: (context, constraints) {
        return Padding(
          padding: const EdgeInsets.all(4.0),
          child: SizedBox(
            width: constraints.maxWidth,
            child: Card(
              child: Column(
                children: [
                  const SizedBox(height: 16.0),
                  CircleAvatar(
                    radius: 48,
                    backgroundImage: FileImage(
                      File('${appController.yourImage}'),
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    '${appController.yourName}',
                    style: textTitleStyleBig,
                  ),
                  const SizedBox(height: 8.0),
                  Expanded(
                    child: ListView(
                      children: [
                        ListTile(
                          leading: const Icon(Icons.file_download),
                          title: const Text("Export CSV"),
                          onTap: () {
                            exportAsCSV(context: context);
                          },
                        ),
                        ListTile(
                          leading: const Icon(Icons.file_download),
                          title: const Text("Export PDF"),
                          onTap: () {},
                        ),
                        ListTile(
                          leading: const Icon(Icons.info),
                          title: const Text("About"),
                          onTap: () {
                            showAbout(context: context);
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }

  showAbout({required BuildContext context}) {
    PackageInfo.fromPlatform().then((PackageInfo packageInfo) {
      String appName = packageInfo.appName;
      String version = packageInfo.version;
      String buildNumber = packageInfo.buildNumber;

      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text("About"),
          content: Text(appName + " v" + version + "+" + buildNumber),
          actions: <Widget>[
            TextButton(
              child: const Text("Close"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
        ),
      );
    });
  }

  exportAsCSV({required BuildContext context}) async {
    // load BloodPressure data
    Box<BloodPressure> boxBp = await appController.loadBloodPressure();
    // load data to list
    List<List<String>> bpDocument = [
      <String>['Date', 'Systolic', 'Diastolic', 'Pulse', 'Type'],
    ];
    for (var element in boxBp.values) {
      //log(element.dateTime.toString());
      bpDocument.add(<String>[element.dateTime.toString(), element.systolic.toString(), element.diastolic.toString(), element.pulse.toString(), bloodPressureTypeLabel[element.type]]);
    }
    // export file BloodPressure
    await exportToCSV(csvDocument: bpDocument, name: 'bloodpressure');

    // load BMI data
    Box<Bmi> boxBmi = await appController.loadBMI();
    // load data to list
    List<List<String>> bmiDocument = [
      <String>['Date', 'Weight', 'Height', 'BMI', 'Type'],
    ];
    for (var element in boxBmi.values) {
      //log(element.dateTime.toString());
      bpDocument.add(<String>[element.dateTime.toString(), element.weight.toString(), element.height.toString(), element.bmi.toString(), bmiTypeLabel[appController.bmiDecode(bmi: element.bmi)]]);
    }
    // export file BloodPressure
    await exportToCSV(csvDocument: bmiDocument, name: 'bmi');

    // load Glucose data
    Box<Glucose> boxGlucode = await appController.loadGlucose();
    // load data to list
    List<List<String>> gluDocument = [
      <String>['Date', 'Glucose', 'Measure', 'Type'],
    ];
    for (var element in boxGlucode.values) {
      //log(element.dateTime.toString());
      bpDocument.add(
          <String>[element.dateTime.toString(), element.unit.toString(), glucoseWhenLabel[element.when], glucoseTypeLabel[appController.glucoseCalculation(unit: element.unit, when: element.when)]]);
    }
    // export file BloodPressure
    await exportToCSV(csvDocument: gluDocument, name: 'gluecose');

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: const Text("Export to CSV complete"),
      //duration: const Duration(milliseconds: 600),
      action: SnackBarAction(
          label: 'Open',
          onPressed: () {
            showBackupFiles(context: context, filter: '.csv');
          }),
    ));

    //final message = await OpenFile.open(filePath);
    //log(message.message.toString());

    //open share dialog
    //Share.shareFiles([filePath]);
  }

  Future<String> exportToCSV({required List<List<String>> csvDocument, required String name}) async {
    String csv = const ListToCsvConverter(fieldDelimiter: ',', eol: '\n', textDelimiter: '"', textEndDelimiter: '"').convert(csvDocument);

    // get application directory
    Directory appDocDir = await getApplicationDocumentsDirectory();
    //Directory? appDocDir = await getExternalStorageDirectory();
    String appDocPath = appDocDir.path;

    String filePath = appDocPath + "/" + DateFormat('yMMdd').format(DateTime.now()).toString() + "_" + name + "_export" + ".csv";

    // write file
    final File file = File(filePath);
    await file.writeAsString(csv);

    //log(csv);
    log(filePath);
    return filePath;
  }

  Future<dynamic> showBackupFiles({required BuildContext context, required String filter}) async {
    final directory = (await getApplicationDocumentsDirectory()).path;
    final file = Directory(directory).listSync();
    return showDialog(
      useSafeArea: false,
      context: context,
      builder: (context) => Scaffold(
        appBar: AppBar(
          title: const Text("Backup files"),
        ),
        body: ListView.builder(
            itemCount: file.length,
            itemBuilder: (BuildContext context, int index) {
              if (file[index].toString().contains(filter)) {
                return ListTile(
                  title: Text(file[index].path.split('/').last),
                  onTap: () {
                    //open share dialog
                    Share.shareFiles([file[index].path.toString()]);
                  },
                );
              }
              return Container();
            }),
      ),
    );
  }
}
