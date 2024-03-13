import 'dart:developer';
import 'dart:io';

import 'package:csv/csv.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:phr/const.dart';
import 'package:phr/controllers/app_controller.dart';
import 'package:phr/themes/theme.dart';

class ImportDataPage extends StatefulWidget {
  const ImportDataPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ImportDataPageState createState() => _ImportDataPageState();
}

class _ImportDataPageState extends State<ImportDataPage> {
  String appDropDown = 'bp';
  String? dataDropDown;
  String? backupFile;

  AppController appController = Get.find<AppController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Import Data"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Card(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      // title
                      const Text(
                        "Application : ",
                        style: textTitleStyle,
                      ),

                      // dropdown field
                      DropdownButton<String>(
                        value: appDropDown,
                        hint: const Text('Choose application'),
                        onChanged: (value) {
                          setState(() {
                            appDropDown = value.toString();
                          });
                        },
                        items: const [
                          DropdownMenuItem(
                            value: "bp",
                            child: Text("Blood Pressure Log"),
                          ),
                          DropdownMenuItem(
                            value: "phr",
                            child: Text("Personal Health Record"),
                          ),
                        ],
                      ),
                    ],
                  ),
                  (appDropDown != 'bp')
                      ? Row(
                          children: [
                            // title
                            const Text(
                              "Data : ",
                              style: textTitleStyle,
                            ),

                            // dropdown field
                            DropdownButton(
                              value: dataDropDown,
                              hint: const Text('Choose data'),
                              onChanged: (value) {
                                setState(() {
                                  dataDropDown = value.toString();
                                });
                              },
                              items: const [
                                DropdownMenuItem(
                                  value: "bmi",
                                  child: Text("Body Mass Index"),
                                ),
                                DropdownMenuItem(
                                  value: "bp",
                                  child: Text("Blood Pressure"),
                                ),
                                DropdownMenuItem(
                                  value: "bg",
                                  child: Text("Blood Glucose"),
                                ),
                              ],
                            )
                          ],
                        )
                      : Container(),

                  // choose backup file
                  ((appDropDown == 'bp') ||
                          ((appDropDown == 'phr') && (dataDropDown != null)))
                      ? ElevatedButton(
                          style: buttonStyleBlue,
                          onPressed: () async {
                            // choose backup file only .csv
                            FilePickerResult? filePickerResult =
                                await FilePicker.platform.pickFiles(
                              type: FileType.custom,
                              allowedExtensions: ['csv'],
                            );
                            if (filePickerResult != null) {
                              log('backup file ->${filePickerResult.paths.single}');
                              setState(() {
                                backupFile =
                                    filePickerResult.paths.single.toString();
                              });
                            }
                          },
                          child: const Text("Choose backup file"),
                        )
                      : Container(),

                  // show file path
                  (backupFile != null) ? Text(backupFile!) : Container(),
                  //  count & import
                  (backupFile != null)
                      ? FutureBuilder(
                          future: File(backupFile!).readAsString(),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              var csvData = snapshot.data;
                              //log(csvData.toString());
                              List<List<dynamic>> rowsAsListOfValues =
                                  const CsvToListConverter(
                                          fieldDelimiter: ',',
                                          eol: '\n',
                                          textDelimiter: '"',
                                          textEndDelimiter: '"')
                                      .convert(csvData.toString());
                              log('total rows -> ${rowsAsListOfValues.length}');
                              return ElevatedButton(
                                style: buttonStyleGreen,
                                onPressed: () {
                                  // import from blood pressure log
                                  if (appDropDown == "bp") {
                                    // import blood pressure data
                                    try {
                                      for (var element in rowsAsListOfValues) {
                                        log('$element');
                                        DateTime? timeStamp =
                                            DateTime.tryParse(element[0]);
                                        // check first row
                                        if (timeStamp != null) {
                                          // start import
                                          DateTime timeStamp =
                                              DateTime.parse(element[0]);
                                          int sys = element[1];
                                          int dia = element[2];
                                          int pul = element[3];
                                          appController.addBloodPressure(
                                            dateTime: timeStamp,
                                            systolic: sys,
                                            diastolic: dia,
                                            pulse: pul,
                                          );
                                        }
                                      }
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(const SnackBar(
                                              content: Text(
                                                  "Import data complete!")));
                                    } catch (e) {
                                      log('Error cannot import data');
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(const SnackBar(
                                              content:
                                                  Text("Cannot import data!")));
                                    }
                                  } else {
                                    // import PHR
                                    log("import data from PHR");
                                    if (dataDropDown == "bmi") {
                                      log("import data from PHR -> BMI");
                                      try {
                                        for (var element
                                            in rowsAsListOfValues) {
                                          log('$element');
                                          // check first row
                                          DateTime? timeStamp =
                                              DateTime.tryParse(element[0]);
                                          if (timeStamp != null) {
                                            DateTime timeStamp =
                                                DateTime.parse(element[0]);
                                            double weight = element[1];
                                            double height = element[2];
                                            appController.addBmi(
                                                dateTime: timeStamp,
                                                height: height,
                                                weight: weight);
                                          }
                                        }
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(const SnackBar(
                                                content: Text(
                                                    "Import data complete!")));
                                      } catch (e) {
                                        log('Error cannot import data');
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(const SnackBar(
                                                content: Text(
                                                    "Cannot import data!")));
                                      }
                                    }

                                    if (dataDropDown == "bp") {
                                      log("import data from PHR -> BP");
                                      try {
                                        for (var element
                                            in rowsAsListOfValues) {
                                          log('$element');
                                          DateTime? timeStamp =
                                              DateTime.tryParse(element[0]);
                                          // check first row
                                          if (timeStamp != null) {
                                            // start import
                                            DateTime timeStamp =
                                                DateTime.parse(element[0]);
                                            int sys = element[1];
                                            int dia = element[2];
                                            int pul = element[3];
                                            appController.addBloodPressure(
                                              dateTime: timeStamp,
                                              systolic: sys,
                                              diastolic: dia,
                                              pulse: pul,
                                            );
                                          }
                                        }
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(const SnackBar(
                                                content: Text(
                                                    "Import data complete!")));
                                      } catch (e) {
                                        log('Error cannot import data');
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(const SnackBar(
                                                content: Text(
                                                    "Cannot import data!")));
                                      }
                                    }

                                    if (dataDropDown == "bg") {
                                      log("import data from PHR -> BG");
                                      try {
                                        for (var element
                                            in rowsAsListOfValues) {
                                          log('$element');
                                          DateTime? timeStamp =
                                              DateTime.tryParse(element[0]);
                                          // check first row
                                          if (timeStamp != null) {
                                            // start import
                                            DateTime timeStamp =
                                                DateTime.parse(element[0]);
                                            int unit = element[1];
                                            glucoseWhenLabel
                                                .asMap()
                                                .forEach((key, value) {
                                              if (value == element[2]) {
                                                appController.addGluecose(
                                                    dateTime: timeStamp,
                                                    glucose: unit,
                                                    when: key);
                                              }
                                            });
                                          }
                                        }
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(const SnackBar(
                                                content: Text(
                                                    "Import data complete!")));
                                      } catch (e) {
                                        log('Error cannot import data');
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(const SnackBar(
                                                content: Text(
                                                    "Cannot import data!")));
                                      }
                                    }
                                  }
                                },
                                child: Text(
                                    "Import all ${rowsAsListOfValues.length} rows"),
                              );
                            }
                            return Container();
                          },
                        )
                      : Container(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
