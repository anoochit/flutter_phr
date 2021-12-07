import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:phr/const.dart';
import 'package:phr/controllers/app_controller.dart';
import 'package:phr/models/bmi.dart';
import 'package:phr/models/chartdata.dart';
import 'package:phr/pages/bmi/add_bmi.dart';
import 'package:phr/pages/bmi/bmi_history.dart';
import 'package:phr/themes/theme.dart';
import 'package:phr/widgets/spline_chart.dart';
import 'package:phr/widgets/statsbox_widget.dart';
import 'package:screenshot/screenshot.dart';

class BmiPage extends StatefulWidget {
  const BmiPage({Key? key}) : super(key: key);

  @override
  _BmiPageState createState() => _BmiPageState();
}

class _BmiPageState extends State<BmiPage> {
  ScreenshotController screenshotController = ScreenshotController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Body Mass Index"),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              // navigate tp add bmi page
              Get.to(() => const AddBMIPage());
            },
          )
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: GetBuilder<AppController>(
                init: AppController(),
                builder: (controller) {
                  return FutureBuilder(
                    future: controller.loadBMI(),
                    builder: (BuildContext context,
                        AsyncSnapshot<Box<Bmi>> snapshot) {
                      if (snapshot.hasError) {
                        return const Center(
                          child: Text("Error"),
                        );
                      }

                      if (snapshot.hasData) {
                        var box = snapshot.data!;
                        if (box.values.isNotEmpty) {
                          // chart data
                          final List<ChartData> chartDataWeight = [];
                          final List<ChartData> chartDataHeight = [];
                          final List<ChartData> chartDataBMI = [];

                          // convert iterable to list and sort
                          var boxList = box.values.toList();
                          boxList.sort(
                            (a, b) => a.dateTime.compareTo(b.dateTime),
                          );
                          // FIXME: load data only last 28 day
                          boxList = controller.getDataOnly(
                            box: boxList,
                            total: 28,
                          );

                          for (var item in boxList) {
                            chartDataWeight.add(
                              ChartData(
                                name: 'Weight',
                                dateTime: item.dateTime,
                                value: item.weight,
                              ),
                            );
                            chartDataHeight.add(
                              ChartData(
                                name: 'Height',
                                dateTime: item.dateTime,
                                value: item.height,
                              ),
                            );
                            chartDataBMI.add(
                              ChartData(
                                name: 'BMI',
                                dateTime: item.dateTime,
                                value: item.bmi,
                              ),
                            );
                          }

                          final List<List<ChartData>> chartData = [
                            chartDataWeight,
                            chartDataHeight,
                            chartDataBMI
                          ];

                          // return bmi info
                          return Column(
                            children: [
                              // statistics
                              Row(
                                children: [
                                  StatsBoxWidget(
                                    width: ((constraints.maxWidth - 8) / 3),
                                    height: (constraints.maxWidth / 3),
                                    title: 'WEIGHT',
                                    value:
                                        boxList.last.weight.toStringAsFixed(2),
                                    valueColor: listChartColor[0],
                                    subTitle: 'kg.',
                                  ),
                                  StatsBoxWidget(
                                    width: ((constraints.maxWidth - 8) / 3),
                                    height: (constraints.maxWidth / 3),
                                    title: 'HEIGHT',
                                    value:
                                        boxList.last.height.toStringAsFixed(1),
                                    valueColor: listChartColor[1],
                                    subTitle: 'cm.',
                                  ),
                                  StatsBoxWidget(
                                    width: ((constraints.maxWidth - 8) / 3),
                                    height: (constraints.maxWidth / 3),
                                    title: 'BMI',
                                    value: boxList.last.bmi.toStringAsFixed(2),
                                    valueColor: listChartColor[2],
                                    subTitle: 'kg./m^2',
                                  ),
                                ],
                              ),

                              // result
                              SizedBox(
                                child: Card(
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Text(
                                          "Result",
                                          style: textTitleStyle,
                                        ),
                                        Text(
                                          bmiTypeLabel[box.values.last.type],
                                          style: TextStyle(
                                            color: listBmiColor[
                                                box.values.last.type],
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
                                          legend: true,
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
                                    padding:
                                        EdgeInsets.symmetric(vertical: 16.0),
                                    child: Text("History"),
                                  ),
                                  onPressed: () =>
                                      Get.to(() => const BMIHistoryPage()),
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
        },
      ),
    );
  }
}
