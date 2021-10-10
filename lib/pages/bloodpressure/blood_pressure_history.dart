import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:phr/const.dart';
import 'package:phr/controllers/app_controller.dart';
import 'package:phr/models/bloodpressure.dart';
import 'package:phr/themes/theme.dart';
import 'package:phr/widgets/boxdevider_widget.dart';

class BloodPressureHistoryPage extends StatefulWidget {
  @override
  State<BloodPressureHistoryPage> createState() =>
      _BloodPressureHistoryPageState();
}

class _BloodPressureHistoryPageState extends State<BloodPressureHistoryPage> {
  AppController appController = Get.find<AppController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("History"),
      ),
      body: FutureBuilder(
        future: appController.loadBloodPressure(),
        builder:
            (BuildContext context, AsyncSnapshot<Box<BloodPressure>> snapshot) {
          if (snapshot.hasData) {
            final box = snapshot.data;
            // final myBox = box!.values;
            final boxSorted = box!.values.toList();
            boxSorted.sort((a, b) => a.dateTime.compareTo(b.dateTime));

            List<BloodPressure> myBox = List.from(boxSorted.reversed);

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
                            color: listBloodPressureColor[
                                appController.bloodPressureCalculation(
                              systolic: myBox[index].systolic,
                              diastolic: myBox[index].diastolic,
                            )],
                            //borderRadius: BorderRadius.circular(60),
                          ),
                          child: BoxDeviderWiget(
                            value1: myBox[index].systolic.toStringAsFixed(0),
                            value2: myBox[index].diastolic.toStringAsFixed(0),
                            valueColor: Colors.white,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                bloodPressureTypeLabel[myBox[index].type],
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
                                        //box.delete(key).onError((error, stackTrace) => log(error.toString()));
                                        appController.deleteBloodPressure(
                                          key: key,
                                        );
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
