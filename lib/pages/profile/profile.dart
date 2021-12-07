import 'dart:developer';
import 'dart:io';
import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:phr/const.dart';
import 'package:phr/controllers/app_controller.dart';
import 'package:phr/models/bloodpressure.dart';
import 'package:phr/models/bmi.dart';
import 'package:phr/models/glucose.dart';
import 'package:phr/pages/profile/csv_viewer.dart';
import 'package:phr/pages/profile/import_data.dart';
import 'package:phr/pages/profile/pdf_viewer.dart';
import 'package:phr/themes/theme.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

class ProfilePage extends StatelessWidget {
  final AppController appController = Get.find<AppController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
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
                            onTap: () => exportAsCSV().then((value) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: value ? Text("Export to CSVs complete") : Text("Export to CSVs incomplete"),
                                  action: SnackBarAction(
                                    label: value ? 'Open' : 'Dismiss',
                                    onPressed: value
                                        ? () => showBackupFiles(
                                              context: context,
                                              filter: '.csv',
                                            )
                                        : () => Navigator.pop(context),
                                  ),
                                ),
                              );
                            }),
                          ),
                          ListTile(
                            leading: const Icon(Icons.file_download),
                            title: const Text("Export PDF"),
                            onTap: () => exportAsPDF().then((value) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: value ? Text("Export to PDFs complete") : Text("Export to PDFs incomplete"),
                                  action: SnackBarAction(
                                    label: value ? 'Open' : 'Dismiss',
                                    onPressed: value
                                        ? () => showBackupFiles(
                                              context: context,
                                              filter: '.pdf',
                                            )
                                        : () => Navigator.pop(context),
                                  ),
                                ),
                              );
                            }),
                          ),
                          ListTile(
                            leading: const Icon(Icons.file_upload),
                            title: const Text("Import Data"),
                            onTap: () {
                              Get.to(() => ImportDataPage());
                            },
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
        },
      ),
    );
  }

  showAbout({required BuildContext context}) {
    PackageInfo.fromPlatform().then(
      (PackageInfo packageInfo) {
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
                onPressed: () => Navigator.pop(context),
              )
            ],
          ),
        );
      },
    );
  }

  Future<bool> exportAsCSV() async {
    try {
      // load BloodPressure data
      Box<BloodPressure> boxBp = await appController.loadBloodPressure();
      final boxBpList = boxBp.values.toList();
      boxBpList.sort((a, b) => a.dateTime.compareTo(b.dateTime));
      // load data to list
      List<List<String>> bpDocument = [
        <String>[
          'Date',
          'Systolic',
          'Diastolic',
          'Pulse',
          'Type',
        ],
      ];
      for (var element in boxBpList) {
        log(element.dateTime.toString());
        bpDocument.add(
          <String>[
            element.dateTime.toString(),
            element.systolic.toString(),
            element.diastolic.toString(),
            element.pulse.toString(),
            bloodPressureTypeLabel[element.type],
          ],
        );
      }
      // export file BloodPressure
      await _exportToCSV(csvDocument: bpDocument, name: 'bloodpressure');

      // load BMI data
      Box<Bmi> boxBmi = await appController.loadBMI();
      final boxBmiList = boxBmi.values.toList();
      boxBmiList.sort((a, b) => a.dateTime.compareTo(b.dateTime));
      // load data to list
      List<List<String>> bmiDocument = [
        <String>[
          'Date',
          'Weight',
          'Height',
          'BMI',
          'Type',
        ],
      ];
      for (var element in boxBmiList) {
        log(element.dateTime.toString());
        bmiDocument.add(
          <String>[
            element.dateTime.toString(),
            element.weight.toStringAsFixed(2),
            element.height.toStringAsFixed(2),
            element.bmi.toStringAsFixed(2),
            bmiTypeLabel[appController.bmiDecode(bmi: element.bmi)],
          ],
        );
      }
      // export file BloodPressure
      await _exportToCSV(csvDocument: bmiDocument, name: 'bmi');

      // load Glucose data
      Box<Glucose> boxGlucode = await appController.loadGlucose();
      final boxGlucoseList = boxGlucode.values.toList();
      boxGlucoseList.sort((a, b) => a.dateTime.compareTo(b.dateTime));
      // load data to list
      List<List<String>> gluDocument = [
        <String>[
          'Date',
          'Glucose',
          'Measure',
          'Type',
        ],
      ];
      for (var element in boxGlucoseList) {
        log(element.dateTime.toString());
        gluDocument.add(
          <String>[
            element.dateTime.toString(),
            element.unit.toString(),
            glucoseWhenLabel[element.when],
            glucoseTypeLabel[appController.glucoseCalculation(
              unit: element.unit,
              when: element.when,
            )],
          ],
        );
      }
      // export file BloodPressure
      await _exportToCSV(csvDocument: gluDocument, name: 'glucose');
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<String> _exportToCSV({
    required List<List<String>> csvDocument,
    required String name,
  }) async {
    String csv = const ListToCsvConverter(
      fieldDelimiter: ',',
      eol: '\n',
      textDelimiter: '"',
      textEndDelimiter: '"',
    ).convert(csvDocument);

    // get application directory
    Directory appDocDir = await getApplicationDocumentsDirectory();
    String appDocPath = appDocDir.path;
    String filePath = appDocPath + "/" + DateFormat('yMMdd').format(DateTime.now()).toString() + "_" + name + "_export" + ".csv";

    // write file
    final File file = File(filePath);
    await file.writeAsString(csv);

    //log(csv);
    log(filePath);
    return filePath;
  }

  Future<String> _exportToPDF({
    required List<List<String>> pdfDocument,
    required String name,
  }) async {
    final directory = (await getApplicationDocumentsDirectory()).path;
    String filePath = directory + "/" + DateFormat('yMMdd').format(DateTime.now()).toString() + "_" + name + "_pdf_export" + ".pdf";

    final PdfDocument document = PdfDocument();

    final PdfPage page = document.pages.add();

    final PdfGrid grid = PdfGrid();

    grid.columns.add(count: pdfDocument[0].length);

    final PdfGridRow headerRow = grid.headers.add(1)[0];

    headerRow.style.font = PdfStandardFont(
      PdfFontFamily.helvetica,
      10,
      style: PdfFontStyle.bold,
    );

    pdfDocument.asMap().forEach((index, element) {
      if (index == 0) {
        element.asMap().forEach((index, inE) {
          headerRow.cells[index].value = inE;
        });
      } else {
        PdfGridRow row = grid.rows.add();
        element.asMap().forEach((index, inE) {
          row.cells[index].value = inE;
        });
      }
    });

    grid.style.cellPadding = PdfPaddings(left: 5, top: 5);

    grid.draw(
      page: page,
      bounds: Rect.fromLTWH(
        0,
        0,
        page.getClientSize().width,
        page.getClientSize().height,
      ),
    );

    File(filePath).writeAsBytes(document.save());

    document.dispose();

    return filePath;
  }

  Future<dynamic> showBackupFiles({
    required BuildContext context,
    required String filter,
  }) async {
    final directory = (await getApplicationDocumentsDirectory()).path;
    final file = Directory(directory).listSync();
    return showDialog(
      useSafeArea: false,
      context: context,
      builder: (context) => Scaffold(
        appBar: AppBar(
          title: const Text("Files"),
        ),
        body: ListView.builder(
          itemCount: file.length,
          itemBuilder: (BuildContext context, int index) {
            if (file[index].toString().contains(filter)) {
              return ListTile(
                leading: const Icon(Icons.note),
                title: Text(file[index].path.split('/').last),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => filter == '.pdf'
                          ? PDFViewerPage(
                              path: file[index].path.toString(),
                            )
                          : CSVViewerPage(
                              path: file[index].path.toString(),
                            ),
                    ),
                  );
                },
              );
            }
            return Container();
          },
        ),
      ),
    );
  }

  Future<bool> exportAsPDF() async {
    try {
      // load BloodPressure data
      Box<BloodPressure> boxBp = await appController.loadBloodPressure();
      final boxBpList = boxBp.values.toList();
      boxBpList.sort((a, b) => a.dateTime.compareTo(b.dateTime));
      // load data to list
      List<List<String>> bpDocument = [
        <String>['Date', 'Systolic', 'Diastolic', 'Pulse', 'Type'],
      ];
      for (var element in boxBpList) {
        log(element.dateTime.toString());
        bpDocument.add(
          <String>[
            element.dateTime.toString(),
            element.systolic.toString(),
            element.diastolic.toString(),
            element.pulse.toString(),
            bloodPressureTypeLabel[element.type],
          ],
        );
      }
      // export file BloodPressure
      await _exportToPDF(pdfDocument: bpDocument, name: 'bloodpressure');

      // load BMI data
      Box<Bmi> boxBmi = await appController.loadBMI();
      final boxBmiList = boxBmi.values.toList();
      boxBmiList.sort((a, b) => a.dateTime.compareTo(b.dateTime));
      // load data to list
      List<List<String>> bmiDocument = [
        <String>['Date', 'Weight', 'Height', 'BMI', 'Type'],
      ];
      for (var element in boxBmiList) {
        log(element.dateTime.toString());
        bmiDocument.add(
          <String>[
            element.dateTime.toString(),
            element.weight.toStringAsFixed(2),
            element.height.toStringAsFixed(2),
            element.bmi.toStringAsFixed(2),
            bmiTypeLabel[appController.bmiDecode(bmi: element.bmi)],
          ],
        );
      }
      // export file BloodPressure
      await _exportToPDF(pdfDocument: bmiDocument, name: 'bmi');

      // load Glucose data
      Box<Glucose> boxGlucode = await appController.loadGlucose();
      final boxGlucoseList = boxGlucode.values.toList();
      boxGlucoseList.sort((a, b) => a.dateTime.compareTo(b.dateTime));
      // load data to list
      List<List<String>> gluDocument = [
        <String>['Date', 'Glucose', 'Measure', 'Type'],
      ];
      for (var element in boxGlucoseList) {
        log(element.dateTime.toString());
        gluDocument.add(
          <String>[
            element.dateTime.toString(),
            element.unit.toString(),
            glucoseWhenLabel[element.when],
            glucoseTypeLabel[appController.glucoseCalculation(
              unit: element.unit,
              when: element.when,
            )],
          ],
        );
      }
      // export file BloodPressure
      await _exportToPDF(pdfDocument: gluDocument, name: 'glucose');
      return true;
    } catch (e) {
      return false;
    }
  }
}
