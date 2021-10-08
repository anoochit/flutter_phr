import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:phr/controllers/appcontroller.dart';
import 'package:phr/models/bloodpressure.dart';
import 'package:phr/models/chartdata.dart';
import 'package:phr/pages/bloodpressure/bloodpressure.dart';
import 'package:phr/themes/theme.dart';
import 'package:phr/widgets/boxcolumndata_widget.dart';
import 'package:phr/widgets/spline_chart.dart';

class BloodPressureWidget extends StatelessWidget {
  const BloodPressureWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return GestureDetector(
          child: Card(
            child: SizedBox(
              width: constraints.maxWidth,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    // title
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Text("Blood Pressure", style: textTitleStyle),
                      ],
                    ),

                    // statistic
                    GetBuilder<AppController>(
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
                              // has data
                              if (snapshot.hasData) {
                                final box = snapshot.data;

                                if (box!.values.isNotEmpty) {
                                  // convert to list and sort
                                  final boxList = box.values.toList();
                                  boxList.sort((a, b) => a.dateTime.compareTo(b.dateTime));

                                  final List<ChartData> chartDataSystolic = [];
                                  final List<ChartData> chartDataDiastolic = [];
                                  final List<ChartData> chartDataPulse = [];
                                  for (var item in boxList) {
                                    chartDataSystolic.add(ChartData(name: 'Systolic', dateTime: item.dateTime, value: item.systolic.toDouble()));
                                    chartDataDiastolic.add(ChartData(name: 'Diastolic', dateTime: item.dateTime, value: item.diastolic.toDouble()));
                                    chartDataPulse.add(ChartData(name: 'Pulse', dateTime: item.dateTime, value: item.pulse.toDouble()));
                                  }
                                  final List<List<ChartData>> chartData = [chartDataSystolic, chartDataDiastolic, chartDataPulse];

                                  return Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                        children: [
                                          BoxColumnDataWidget(
                                            title: "SYS",
                                            value: '${boxList.last.systolic}',
                                            //valueColor: listChartColor[0],
                                            subTitle: "mm Hg",
                                          ),
                                          BoxColumnDataWidget(
                                            title: "DIA",
                                            value: '${boxList.last.diastolic}',
                                            //valueColor: listChartColor[1],
                                            subTitle: "mm Hg",
                                          ),
                                          BoxColumnDataWidget(
                                            title: "PUL",
                                            value: boxList.last.pulse.toStringAsFixed(0),
                                            //valueColor: listChartColor[2],
                                            subTitle: "bpm",
                                          ),
                                        ],
                                      ),

                                      // graph
                                      SizedBox(
                                        width: constraints.maxWidth,
                                        height: constraints.maxWidth / 2,
                                        child: SplineChartWidget(
                                          chartData: chartData,
                                        ),
                                      )
                                    ],
                                  );
                                } else {
                                  return const Center(
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(vertical: 32.0),
                                      child: Text("No data, tap to add data."),
                                    ),
                                  );
                                }
                              }
                              // loading
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            },
                          );
                        }),
                  ],
                ),
              ),
            ),
          ),
          onTap: () {
            // Navogation to bloodpressure page
            Get.to(() => const BloodPressurePage());
          },
        );
      },
    );
  }
}
