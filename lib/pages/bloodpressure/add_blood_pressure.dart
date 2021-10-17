import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:phr/controllers/app_controller.dart';
import 'package:phr/themes/theme.dart';

class AddBloodPressurePage extends StatefulWidget {
  const AddBloodPressurePage({Key? key}) : super(key: key);

  @override
  State<AddBloodPressurePage> createState() => _AddBloodPressurePageState();
}

class _AddBloodPressurePageState extends State<AddBloodPressurePage> {
  final AppController appController = Get.find<AppController>();
  final formKey = GlobalKey<FormState>();

  final TextEditingController dateTextController = TextEditingController();
  final TextEditingController timeTextController = TextEditingController();
  final TextEditingController systolicTextController = TextEditingController();
  final TextEditingController diastolicTextController = TextEditingController();
  final TextEditingController pulseTextController = TextEditingController();

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
          title: const Text("Add Blood Pressure"),
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
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 16.0),
                            child: Text(
                              "Enter systolic, diastolic and pulse",
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
                                    firstDate: DateTime.now()
                                        .subtract(Duration(days: 365)),
                                    lastDate: DateTime.now());
                                try {
                                  dateTextController.text =
                                      (DateFormat('yyyy-MM-dd')
                                          .format(dateValue!)
                                          .toString());
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
                                      data: MediaQuery.of(context).copyWith(
                                          alwaysUse24HourFormat: true),
                                      child: child!,
                                    );
                                  },
                                );
                                try {
                                  timeTextController.text =
                                      timeValue!.format(context);
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
                              controller: systolicTextController,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                                hintText: 'Systolic (mm Hg)',
                                prefixIcon: const Icon(
                                  Icons.favorite_outline,
                                ),
                              ),
                              keyboardType: TextInputType.number,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter systolic';
                                }
                                return null;
                              },
                            ),
                          ),

                          // dia
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4.0),
                            child: TextFormField(
                              controller: diastolicTextController,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                                hintText: 'Diastolic (mm Hg)',
                                prefixIcon: const Icon(
                                  Icons.favorite_outline,
                                ),
                              ),
                              keyboardType: TextInputType.number,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter diastolic';
                                }
                                return null;
                              },
                            ),
                          ),

                          // pulse
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4.0),
                            child: TextFormField(
                              controller: pulseTextController,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                                hintText: 'Pulse (bpm)',
                                prefixIcon: const Icon(
                                  Icons.favorite_outline,
                                ),
                              ),
                              keyboardType: TextInputType.number,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter pulse';
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
                                      dateTextController.text +
                                          " " +
                                          timeTextController.text);
                                  final systolic = int.parse(
                                    systolicTextController.text.trim(),
                                  );
                                  final diastolic = int.parse(
                                    diastolicTextController.text.trim(),
                                  );
                                  final pulse = int.parse(
                                    pulseTextController.text.trim(),
                                  );

                                  appController.addBloodPressure(
                                      dateTime: dateTime,
                                      systolic: systolic,
                                      diastolic: diastolic,
                                      pulse: pulse);

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
