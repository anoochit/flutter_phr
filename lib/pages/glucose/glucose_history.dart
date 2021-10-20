import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:phr/const.dart';
import 'package:phr/controllers/app_controller.dart';
import 'package:phr/models/glucose.dart';
import 'package:phr/themes/theme.dart';
import 'package:phr/widgets/boxcolumndata_widget.dart';

class GlucoseHistoryPage extends StatefulWidget {
  const GlucoseHistoryPage({Key? key}) : super(key: key);

  @override
  State<GlucoseHistoryPage> createState() => _GlucoseHistoryPageState();
}

class _GlucoseHistoryPageState extends State<GlucoseHistoryPage> {
  AppController appController = Get.find<AppController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("History"),
      ),
      body: FutureBuilder(
        future: appController.loadGlucose(),
        builder: (BuildContext context, AsyncSnapshot<Box<Glucose>> snapshot) {
          if (snapshot.hasData) {
            final box = snapshot.data;
            // final myBox = box!.values;

            //box.put('1633652700000000', Glucose());

            final boxSorted = box!.values.toList();
            boxSorted.sort((a, b) => a.dateTime.compareTo(b.dateTime));

            List<Glucose> myBox = List.from(boxSorted.reversed);

            myBox.forEach((element) {
              log(element.key);
            });

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
                            color: listGlucoseColor[myBox[index].level],
                            //borderRadius: BorderRadius.circular(60),
                          ),
                          child: BoxColumnDataWidget(
                            title: 'Glucose',
                            value: myBox[index].unit.toStringAsFixed(0),
                            valueColor: Colors.white,
                            textColor: Colors.white,
                            subTitle: 'mg/dL',
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                glucoseTypeLabel[myBox[index].level],
                                style: textTitleStyle,
                              ),
                              const SizedBox(height: 4.0),
                              Text(
                                DateFormat('dd MMM yyy, HH:mm').format(myBox[index].dateTime),
                                style: textSubTitleStyle,
                              ),
                              const SizedBox(height: 4.0),
                              Text(
                                glucoseWhenLabel[myBox[index].when],
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
                                          final key = myBox[index].dateTime.microsecondsSinceEpoch.toString();
                                          log('delete key -> ' + key);
                                          //box.delete(key).onError((error, stackTrace) => log(error.toString()));
                                          appController.deleteGluecose(key: key);
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
                              )),
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
