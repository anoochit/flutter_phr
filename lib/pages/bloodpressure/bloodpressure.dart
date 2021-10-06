import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:phr/const.dart';
import 'package:phr/controllers/appcontroller.dart';
import 'package:phr/models/bloodpressure.dart';
import 'package:phr/models/chartdata.dart';
import 'package:phr/themes/theme.dart';
import 'package:phr/widgets/spline_chart.dart';
import 'package:phr/widgets/statsbox_widget.dart';

import 'bloodpressure_history.dart';

class BloodPressurePage extends StatefulWidget {
  const BloodPressurePage({Key? key}) : super(key: key);

  @override
  _BloodPressurePageState createState() => _BloodPressurePageState();
}

class _BloodPressurePageState extends State<BloodPressurePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Blood Pressure"),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              // navigate tp add bmi page
              //Get.to(() => const AddBloodPressurePage());
            },
          )
        ],
      ),
      body: LayoutBuilder(builder: (context, constraints) {
        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: GetBuilder<AppController>(
              init: AppController(),
              builder: (controller) {
                return FutureBuilder(
                  future: controller.loadBloodPressure(),
                  builder: (BuildContext context, AsyncSnapshot<Box<BloodPressure>> snapshot) {
                    if (snapshot.hasError) {
                      return const Center(
                        child: Text("Error"),
                      );
                    }

                    if (snapshot.hasData) {
                      var box = snapshot.data!;
                      if (box.values.isNotEmpty) {
                        // chart data
                        final List<ChartData> chartDataSys = [];
                        final List<ChartData> chartDataDia = [];
                        final List<ChartData> chartDataPul = [];

                        // convert iterable to list and sort
                        final boxList = box.values.toList();
                        boxList.sort((a, b) => a.dateTime.compareTo(b.dateTime));

                        for (var item in boxList) {
                          // add chart data
                          chartDataSys.add(ChartData(name: 'Systolic', dateTime: item.dateTime, value: item.systolic.toDouble()));
                          chartDataDia.add(ChartData(name: 'Diastolic', dateTime: item.dateTime, value: item.diastolic.toDouble()));
                          chartDataPul.add(ChartData(name: 'Pluse', dateTime: item.dateTime, value: item.pulse.toDouble()));
                        }

                        final List<List<ChartData>> chartData = [chartDataSys, chartDataDia, chartDataPul];

                        // return bmi info
                        return Column(
                          children: [
                            // statistics
                            Row(
                              children: [
                                StatsBoxWidget(
                                  width: ((constraints.maxWidth - 8) / 3),
                                  height: (constraints.maxWidth / 3) * 0.8,
                                  title: 'systolic'.toUpperCase(),
                                  value: boxList.last.systolic.toStringAsFixed(0),
                                  valueColor: listChartColor[0],
                                  subTitle: 'mm Hg',
                                ),
                                StatsBoxWidget(
                                  width: ((constraints.maxWidth - 8) / 3),
                                  height: (constraints.maxWidth / 3) * 0.8,
                                  title: 'diastolic'.toUpperCase(),
                                  value: boxList.last.diastolic.toStringAsFixed(0),
                                  valueColor: listChartColor[1],
                                  subTitle: 'mm Hg',
                                ),
                                StatsBoxWidget(
                                  width: ((constraints.maxWidth - 8) / 3),
                                  height: (constraints.maxWidth / 3) * 0.8,
                                  title: 'pulse'.toUpperCase(),
                                  value: boxList.last.pulse.toStringAsFixed(0),
                                  valueColor: listChartColor[2],
                                  subTitle: 'bmp',
                                ),
                              ],
                            ),

                            // result
                            SizedBox(
                              child: Card(
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text(
                                        "Result",
                                        style: textTitleStyle,
                                      ),
                                      Text(
                                        bloodPressureTypeLabel[boxList.last.type],
                                        style: TextStyle(
                                          color: listBloodPressureColor[boxList.last.type],
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),

                            // graph
                            Card(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  const Padding(
                                    padding: EdgeInsets.all(16.0),
                                    child: Text(
                                      "Statistic",
                                      style: textTitleStyle,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: SizedBox(
                                      height: constraints.maxWidth,
                                      child: SplineChartWidget(
                                        chartData: chartData,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            // history button
                            const SizedBox(height: 4.0),
                            SizedBox(
                              width: constraints.maxWidth - 16,
                              child: ElevatedButton(
                                style: buttonStyleRed,
                                child: const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 16.0),
                                  child: Text("History"),
                                ),
                                onPressed: () {
                                  Get.to(() => const BloodPressureHistoryPage());
                                },
                              ),
                            ),
                          ],
                        );
                      } else {
                        // return add data text
                        return SizedBox(
                          width: constraints.maxWidth,
                          child: const Card(
                            child: Center(
                              child: Padding(
                                padding: EdgeInsets.all(16.0),
                                child: Text("No data, please add your data"),
                              ),
                            ),
                          ),
                        );
                      }
                    }

                    return Container();
                  },
                );
              },
            ),
          ),
        );
      }),
    );
  }
}
