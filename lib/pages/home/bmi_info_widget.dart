import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:phr/const.dart';
import 'package:phr/controllers/app_controller.dart';
import 'package:phr/models/bmi.dart';
import 'package:phr/models/chartdata.dart';
import 'package:phr/pages/bmi/bmi.dart';
import 'package:phr/themes/theme.dart';
import 'package:phr/widgets/boxcolumndata_widget.dart';
import 'package:phr/widgets/spline_chart.dart';

class BmiInfoWidget extends StatelessWidget {
  const BmiInfoWidget({Key? key, this.showGraph = true}) : super(key: key);

  final bool showGraph;

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
                        Text("Body Mass Index (BMI)", style: textTitleStyle),
                      ],
                    ),

                    // statistic
                    GetBuilder<AppController>(
                        init: AppController(),
                        builder: (controller) {
                          return FutureBuilder(
                            future: controller.loadBMI(),
                            builder: (BuildContext context, AsyncSnapshot<Box<Bmi>> snapshot) {
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
                                  var boxList = box.values.toList();
                                  boxList.sort((a, b) => a.dateTime.compareTo(b.dateTime));
                                  // FIXME: load data only last 28 day
                                  boxList = controller.getDataOnly(box: boxList, total: 28);

                                  final List<ChartData> chartDataWeight = [];
                                  final List<ChartData> chartDataHeight = [];
                                  final List<ChartData> chartDataBMI = [];
                                  for (var item in boxList) {
                                    chartDataWeight.add(ChartData(name: 'Weight', dateTime: item.dateTime, value: item.weight));
                                    chartDataHeight.add(ChartData(name: 'Height', dateTime: item.dateTime, value: item.height));
                                    chartDataBMI.add(ChartData(name: 'BMI', dateTime: item.dateTime, value: item.bmi));
                                  }
                                  final List<List<ChartData>> chartData = [chartDataWeight, chartDataHeight, chartDataBMI];

                                  return Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                          children: [
                                            BoxColumnDataWidget(
                                              title: "Weight".toUpperCase(),
                                              value: '${box.values.last.weight}',
                                              valueColor: listChartColor[0],
                                              subTitle: "kg.",
                                            ),
                                            BoxColumnDataWidget(
                                              title: "Height".toUpperCase(),
                                              value: '${box.values.last.height}',
                                              valueColor: listChartColor[1],
                                              subTitle: "cm.",
                                            ),
                                            BoxColumnDataWidget(
                                              title: "BMI".toUpperCase(),
                                              value: box.values.last.bmi.toStringAsFixed(2),
                                              valueColor: listChartColor[2],
                                              subTitle: "kg./m^2",
                                            ),
                                          ],
                                        ),
                                      ),

                                      // graph
                                      (showGraph)
                                          ? SizedBox(
                                              width: constraints.maxWidth,
                                              height: constraints.maxWidth / 2,
                                              child: SplineChartWidget(
                                                chartData: chartData,
                                                legend: false,
                                              ),
                                            )
                                          : Container()
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
            if (showGraph) {
              // Navigation to bmi page
              Get.to(() => const BmiPage());
            }
          },
        );
      },
    );
  }
}
