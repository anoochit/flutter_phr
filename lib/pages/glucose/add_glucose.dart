import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:phr/const.dart';
import 'package:phr/controllers/app_controller.dart';
import 'package:phr/themes/theme.dart';

class AddGlucosePage extends StatefulWidget {
  const AddGlucosePage({Key? key}) : super(key: key);

  @override
  State<AddGlucosePage> createState() => _AddGlucosePageState();
}

class _AddGlucosePageState extends State<AddGlucosePage> {
  final AppController appController = Get.find<AppController>();
  final formKey = GlobalKey<FormState>();

  final TextEditingController dateTextController = TextEditingController();
  final TextEditingController timeTextController = TextEditingController();
  final TextEditingController glucoseTextController = TextEditingController();

  int? whenData = 0;

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
          title: const Text("Add Blood Glucose"),
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
                              "Enter glucose",
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

                          // sys
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4.0),
                            child: TextFormField(
                              controller: glucoseTextController,
                              decoration: InputDecoration(
                                // filled: true,
                                // fillColor: Colors.grey.shade200,
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0)),
                                hintText: 'Gluecose (mg/dL)',
                                prefixIcon: const Icon(
                                  Icons.icecream_outlined,
                                ),
                              ),
                              keyboardType: TextInputType.number,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter gluecose';
                                }
                                return null;
                              },
                            ),
                          ),

                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4.0),
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Radio<int>(
                                        value: 0,
                                        groupValue: whenData,
                                        onChanged: (value) {
                                          setState(() {
                                            whenData = value;
                                          });
                                        },
                                      ),
                                      Text(glucoseWhenLabel[0]),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Radio<int>(
                                        value: 1,
                                        groupValue: whenData,
                                        onChanged: (value) {
                                          setState(() {
                                            whenData = value;
                                          });
                                        },
                                      ),
                                      Text(glucoseWhenLabel[1])
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Radio<int>(
                                        value: 2,
                                        groupValue: whenData,
                                        onChanged: (value) {
                                          setState(() {
                                            whenData = value;
                                          });
                                        },
                                      ),
                                      Text(glucoseWhenLabel[2]),
                                    ],
                                  ),
                                ],
                              ),
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
                                if (formKey.currentState!.validate() && dateTextController.text.isNotEmpty && timeTextController.text.isNotEmpty) {
                                  final dateTime = DateTime.parse(dateTextController.text + " " + timeTextController.text);
                                  final glucose = int.parse(glucoseTextController.text.trim());

                                  appController.addGluecose(dateTime: dateTime, glucose: glucose, when: whenData!.floor());

                                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(duration: Duration(milliseconds: 500), content: Text("Saved!")));
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
