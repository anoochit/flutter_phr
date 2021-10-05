import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:phr/controllers/appcontroller.dart';
import 'package:phr/models/chartdata.dart';
import 'package:phr/models/glucose.dart';
import 'package:phr/pages/glucose/gluecose.dart';
import 'package:phr/themes/theme.dart';
import 'package:phr/widgets/boxcolumndata_widget.dart';
import 'package:phr/widgets/spline_chart.dart';

class GlucoseInfoWidget extends StatelessWidget {
  const GlucoseInfoWidget({Key? key}) : super(key: key);

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
                                  final List<ChartData> chartDataGlucose = [];
                                  for (var item in box.values) {
                                    chartDataGlucose.add(ChartData(name: 'Glucose', dateTime: item.dateTime, value: item.unit.toDouble()));
                                  }
                                  final List<List<ChartData>> chartData = [chartDataGlucose];

                                  return Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                        children: [
                                          BoxColumnDataWidget(
                                            title: "GLUCOSE",
                                            value: '${box.values.last.unit}',
                                            subTitle: "mg/dL",
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
            Get.to(() => const GlucosePage());
          },
        );
      },
    );
  }
}
