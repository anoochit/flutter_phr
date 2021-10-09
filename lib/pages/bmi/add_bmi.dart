import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:phr/const.dart';
import 'package:phr/controllers/appcontroller.dart';
import 'package:phr/themes/theme.dart';

class AddBMIPage extends StatefulWidget {
  const AddBMIPage({Key? key}) : super(key: key);

  @override
  State<AddBMIPage> createState() => _AddBMIPageState();
}

class _AddBMIPageState extends State<AddBMIPage> {
  final AppController appController = Get.find<AppController>();
  final formKey = GlobalKey<FormState>();

  final TextEditingController dateTextController = TextEditingController();
  final TextEditingController timeTextController = TextEditingController();
  final TextEditingController weightTextController = TextEditingController();
  final TextEditingController heightTextController = TextEditingController();

  double bmi = 0.0;
  String bmiLabel = "--";
  int level = 0;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // unfocus textfield
        FocusScope.of(context).unfocus();
        new TextEditingController().clear();
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Add Body Mass Index"),
        ),
        body: LayoutBuilder(builder: (context, constraints) {
          return SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: Card(
                  child: SizedBox(
                    width: constraints.maxWidth,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // title
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 16.0),
                            child: Text(
                              "Enter weight and height",
                              style: textTitleStyle,
                            ),
                          ),

                          // date
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4.0),
                            child: TextFormField(
                              controller: dateTextController,
                              decoration: InputDecoration(
                                // filled: true,
                                // fillColor: Colors.grey.shade200,
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0)),
                                hintText: 'Date',
                                prefixIcon: const Icon(
                                  Icons.calendar_today,
                                ),
                              ),
                              readOnly: true,
                              onTap: () async {
                                log("tab");
                                var dateValue = await showDatePicker(context: context, initialDate: DateTime.now(), firstDate: DateTime.now().subtract(Duration(days: 365)), lastDate: DateTime.now());
                                try {
                                  dateTextController.text = (DateFormat('yyyy-MM-dd').format(dateValue!).toString());
                                } catch (e) {
                                  log("no select date");
                                }
                              },
                            ),
                          ),

                          // time
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4.0),
                            child: TextFormField(
                              controller: timeTextController,
                              decoration: InputDecoration(
                                // filled: true,
                                // fillColor: Colors.grey.shade200,
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0)),
                                hintText: 'Time',
                                prefixIcon: const Icon(
                                  Icons.schedule,
                                ),
                              ),
                              readOnly: true,
                              onTap: () async {
                                var timeValue = await showTimePicker(context: context, initialTime: TimeOfDay.now());
                                try {
                                  timeTextController.text = timeValue!.format(context);
                                } catch (e) {
                                  log("no select time");
                                }
                              },
                            ),
                          ),

                          // weight
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4.0),
                            child: TextFormField(
                              controller: weightTextController,
                              decoration: InputDecoration(
                                // filled: true,
                                // fillColor: Colors.grey.shade200,
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0)),
                                hintText: 'Weight (kg.)',
                                prefixIcon: const Icon(
                                  Icons.monitor_weight_outlined,
                                ),
                              ),
                              keyboardType: TextInputType.number,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter weight';
                                }
                                return null;
                              },
                            ),
                          ),

                          // height
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4.0),
                            child: TextFormField(
                              controller: heightTextController,
                              decoration: InputDecoration(
                                // filled: true,
                                // fillColor: Colors.grey.shade200,
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0)),
                                hintText: 'Height (cm)',
                                prefixIcon: const Icon(
                                  Icons.emoji_people,
                                ),
                              ),
                              keyboardType: TextInputType.number,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter height';
                                }
                                return null;
                              },
                            ),
                          ),

                          // save button
                          const SizedBox(height: 4.0),
                          SizedBox(
                            width: constraints.maxWidth,
                            child: ElevatedButton(
                              style: buttonStyleGreen,
                              child: const Padding(
                                padding: EdgeInsets.all(16.0),
                                child: Text("Calculate & save data"),
                              ),
                              onPressed: () {
                                if (formKey.currentState!.validate() && dateTextController.text.isNotEmpty && timeTextController.text.isNotEmpty) {
                                  final dateTime = DateTime.parse(dateTextController.text + " " + timeTextController.text);
                                  final weight = double.parse(weightTextController.text.trim());
                                  final height = double.parse(heightTextController.text.trim());

                                  bmi = appController.bmiCalculation(weight: weight, height: height);
                                  level = appController.bmiDecode(bmi: bmi);

                                  appController.addBmi(dateTime: dateTime, height: height, weight: weight);
                                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(duration: Duration(milliseconds: 500), content: Text("Saved!")));
                                  Get.back();
                                }
                              },
                            ),
                          ),

                          // result
                          // const SizedBox(height: 24.0),
                          // Text(bmiLabel, style: textTitleStyle),
                          // Padding(
                          //   padding: const EdgeInsets.all(16.0),
                          //   child: Container(
                          //     decoration: BoxDecoration(
                          //       color: listBmiColor[level],
                          //       borderRadius: BorderRadius.circular(60),
                          //     ),
                          //     width: 120,
                          //     height: 120,
                          //     child: Center(
                          //       child: Text(
                          //         bmi.toStringAsFixed(2),
                          //         style: const TextStyle(color: Colors.white, fontSize: 24.0),
                          //       ),
                          //     ),
                          //   ),
                          // ),
                          // const Text("kg./m^2"),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
