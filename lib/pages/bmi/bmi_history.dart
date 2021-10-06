import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:phr/const.dart';
import 'package:phr/controllers/appcontroller.dart';
import 'package:phr/models/bmi.dart';
import 'package:phr/themes/theme.dart';
import 'package:phr/widgets/boxcolumndata_widget.dart';

class BMIHistoryPage extends StatefulWidget {
  BMIHistoryPage({Key? key}) : super(key: key);

  @override
  State<BMIHistoryPage> createState() => _BMIHistoryPageState();
}

class _BMIHistoryPageState extends State<BMIHistoryPage> {
  AppController appController = Get.find<AppController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("History"),
      ),
      body: FutureBuilder(
        future: appController.loadBMI(),
        builder: (BuildContext context, AsyncSnapshot<Box<Bmi>> snapshot) {
          if (snapshot.hasData) {
            final box = snapshot.data;
            // final myBox = box!.values;
            final boxSorted = box!.values.toList();
            boxSorted.sort((a, b) => a.dateTime.compareTo(b.dateTime));

            List<Bmi> myBox = new List.from(boxSorted.reversed);

            box.values.forEach((element) {
              log(element.key.toString());
            });

            return MediaQuery.removePadding(
              context: context,
              removeTop: true,
              child: ListView.builder(
                itemCount: myBox.length,
                itemBuilder: (BuildContext context, int index) {
                  return Slidable(
                      child: Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: Container(
                          color: Colors.white,
                          child: Row(
                            children: [
                              Container(
                                width: 90,
                                height: 90,
                                decoration: BoxDecoration(
                                  color: listBmiColor[appController.bmiDecode(bmi: myBox[index].bmi)],
                                  //borderRadius: BorderRadius.circular(60),
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
                                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                child: Column(
                                  children: [
                                    Text(
                                      bmiTypeLable[appController.bmiDecode(bmi: myBox[index].bmi)],
                                      style: textTitleStyle,
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      actionPane: const SlidableDrawerActionPane(),
                      secondaryActions: [
                        IconSlideAction(
                          icon: Icons.delete,
                          color: Colors.red,
                          onTap: () {
                            // delete item
                            setState(() {
                              final key = myBox[index].dateTime.microsecondsSinceEpoch.toString();
                              box.delete(key).onError((error, stackTrace) => log(error.toString()));
                            });
                          },
                        ),
                      ]);
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
