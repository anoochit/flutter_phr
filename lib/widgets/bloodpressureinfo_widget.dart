import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:phr/controllers/appcontroller.dart';
import 'package:phr/models/bloodpressure.dart';
import 'package:phr/widgets/boxcolumndata_widget.dart';

class BloodPressureWidget extends StatelessWidget {
  BloodPressureWidget({Key? key}) : super(key: key);

  final AppController appController = Get.find<AppController>();

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
                        Text("Blood Pressure"),
                      ],
                    ),

                    // statistic
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: FutureBuilder(
                        future: appController.loadBloodPressure(),
                        builder: (BuildContext context, AsyncSnapshot<Box<BloodPressure>> snapshot) {
                          if (snapshot.hasError) {
                            return const Center(
                              child: Text("Error"),
                            );
                          }
                          // has data
                          if (snapshot.hasData) {
                            var box = snapshot.data;

                            if (box!.values.isNotEmpty) {
                              return Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  BoxColumnDataWidget(title: "SYS", value: '${box.values.last.systolic}', subTitle: "mm Hg"),
                                  BoxColumnDataWidget(title: "DIA", value: '${box.values.last.diastolic}', subTitle: "mm Hg"),
                                  BoxColumnDataWidget(title: "PUL", value: box.values.last.pulse.toStringAsFixed(2), subTitle: "bpm"),
                                ],
                              );
                            } else {
                              return const Center(
                                child: Text("No data, tap to add data."),
                              );
                            }
                          }
                          // loading
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        },
                      ),
                    ),

                    // graph
                    Container(
                      width: constraints.maxWidth,
                      height: constraints.maxWidth / 2,
                      color: Colors.grey.shade200,
                      child: const Center(
                        child: Text("place graph here"),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
          onTap: () {
            // Todo: add navogation to bloodpressure page
          },
        );
      },
    );
  }
}
