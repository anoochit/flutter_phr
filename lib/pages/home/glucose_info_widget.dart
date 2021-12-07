import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:phr/const.dart';
import 'package:phr/controllers/app_controller.dart';
import 'package:phr/models/chartdata.dart';
import 'package:phr/models/glucose.dart';
import 'package:phr/pages/glucose/gluecose.dart';
import 'package:phr/themes/theme.dart';
import 'package:phr/widgets/boxcolumndata_widget.dart';
import 'package:phr/widgets/spline_chart.dart';

class GlucoseInfoWidget extends StatelessWidget {
  const GlucoseInfoWidget({Key? key, this.showGraph = true}) : super(key: key);

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
                        Text("Blood Glucose", style: textTitleStyle),
                      ],
                    ),

                    // statistic
                    GetBuilder<AppController>(
                        init: AppController(),
                        builder: (controller) {
                          return FutureBuilder(
                            future: controller.loadGlucose(),
                            builder: (BuildContext context, AsyncSnapshot<Box<Glucose>> snapshot) {
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

                                  final List<ChartData> chartDataGlucose = [];
                                  //final List<ChartData> chartDataA1C = [];
                                  for (var item in boxList) {
                                    chartDataGlucose.add(ChartData(name: 'Glucose', dateTime: item.dateTime, value: item.unit.toDouble()));
                                    //chartDataA1C.add(ChartData(name: 'A1C', dateTime: item.dateTime, value: controller.glucoseToA1C(unit: item.unit)));
                                  }
                                  final List<List<ChartData>> chartData = [chartDataGlucose];

                                  return Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                          children: [
                                            BoxColumnDataWidget(
                                              title: "GLUCOSE",
                                              value: '${boxList.last.unit}',
                                              valueColor: listChartColor[0],
                                              subTitle: "mg/dL",
                                            ),
                                            BoxColumnDataWidget(
                                              title: "A1C",
                                              value: '${controller.glucoseToA1C(unit: boxList.last.unit).toStringAsFixed(1)}',
                                              valueColor: listChartColor[1],
                                              subTitle: "%",
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
              // Navogation to bloodpressure page
              Get.to(() => const GlucosePage());
            }
          },
        );
      },
    );
  }
}
