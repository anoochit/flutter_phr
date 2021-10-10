import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:phr/const.dart';
import 'package:phr/controllers/app_controller.dart';
import 'package:phr/models/bmi.dart';
import 'package:phr/themes/theme.dart';
import 'package:phr/widgets/boxcolumndata_widget.dart';

class BMIHistoryPage extends StatefulWidget {
  const BMIHistoryPage({Key? key}) : super(key: key);

  @override
  State<BMIHistoryPage> createState() => _BMIHistoryPageState();
}

class _BMIHistoryPageState extends State<BMIHistoryPage> {
  AppController appController = Get.find<AppController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("History"),
      ),
      body: FutureBuilder(
        future: appController.loadBMI(),
        builder: (BuildContext context, AsyncSnapshot<Box<Bmi>> snapshot) {
          if (snapshot.hasData) {
            final box = snapshot.data;

            final boxSorted = box!.values.toList();
            boxSorted.sort((a, b) => a.dateTime.compareTo(b.dateTime));

            List<Bmi> myBox = List.from(boxSorted.reversed);

            return MediaQuery.removePadding(
              context: context,
              removeTop: true,
              child: ListView.builder(
                itemCount: myBox.length,
                itemBuilder: (BuildContext context, int index) {
                  return Card(
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    child: Row(
                      children: [
                        Container(
                          width: 90,
                          height: 90,
                          decoration: BoxDecoration(
                            color: listBmiColor[appController.bmiDecode(
                              bmi: myBox[index].bmi,
                            )],
                          ),
                          child: BoxColumnDataWidget(
                            title: 'BMI',
                            value: myBox[index].bmi.toStringAsFixed(2),
                            valueColor: Colors.white,
                            textColor: Colors.white,
                            subTitle: 'kg./m^2',
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                bmiTypeLabel[myBox[index].type],
                                style: textTitleStyle,
                              ),
                              const SizedBox(height: 4.0),
                              Text(
                                DateFormat('dd MMM yyy')
                                    .format(myBox[index].dateTime),
                                style: textSubTitleStyle,
                              ),
                              const SizedBox(height: 4.0),
                              Text(
                                DateFormat('HH:mm')
                                    .format(myBox[index].dateTime),
                                style: textSubTitleStyle,
                              ),
                            ],
                          ),
                        ),
                        const Spacer(),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: IconButton(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: const Text("Delete?"),
                                  content: const Text("Do you want to delete?"),
                                  actions: [
                                    TextButton(
                                      child: const Text("Yes"),
                                      onPressed: () {
                                        final key = myBox[index]
                                            .dateTime
                                            .microsecondsSinceEpoch
                                            .toString();
                                        log('delete key -> ' + key);
                                        appController.deleteBMI(key: key);
                                        Get.back();
                                      },
                                    ),
                                    TextButton(
                                      child: const Text("No"),
                                      onPressed: () {
                                        Get.back();
                                      },
                                    )
                                  ],
                                ),
                              ).whenComplete(() {
                                setState(() {});
                              });
                            },
                            icon: const Icon(
                              Icons.remove_circle,
                              color: Colors.red,
                            ),
                          ),
                        )
                      ],
                    ),
                  );
                },
              ),
            );
          }
          return Container();
        },
      ),
    );
  }
}
