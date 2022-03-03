import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:phr/controllers/app_controller.dart';
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
        TextEditingController().clear();
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
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                                hintText: 'Date',
                                prefixIcon: const Icon(
                                  Icons.calendar_today,
                                ),
                              ),
                              readOnly: true,
                              onTap: () async {
                                log("tab");
                                var dateValue = await showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime.now().subtract(Duration(days: 365)),
                                    lastDate: DateTime.now());
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
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                                hintText: 'Time',
                                prefixIcon: const Icon(
                                  Icons.schedule,
                                ),
                              ),
                              readOnly: true,
                              onTap: () async {
                                var timeValue = await showTimePicker(
                                  context: context,
                                  initialTime: TimeOfDay.now(),
                                  builder: (context, child) {
                                    return MediaQuery(
                                      data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
                                      child: child!,
                                    );
                                  },
                                );
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
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
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
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
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
                                child: Text("Save"),
                              ),
                              onPressed: () {
                                if (formKey.currentState!.validate() &&
                                    dateTextController.text.isNotEmpty &&
                                    timeTextController.text.isNotEmpty) {
                                  final dateTime = DateTime.parse(
                                    dateTextController.text + " " + timeTextController.text,
                                  );
                                  final weight = double.parse(
                                    weightTextController.text.trim(),
                                  );
                                  final height = double.parse(
                                    heightTextController.text.trim(),
                                  );

                                  bmi = appController.bmiCalculation(weight: weight, height: height);
                                  level = appController.bmiDecode(bmi: bmi);

                                  appController.addBmi(
                                    dateTime: dateTime,
                                    height: height,
                                    weight: weight,
                                  );
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      duration: Duration(milliseconds: 500),
                                      content: Text("Saved!"),
                                    ),
                                  );
                                  Get.back();
                                }
                              },
                            ),
                          ),
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
