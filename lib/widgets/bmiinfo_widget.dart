import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:phr/controllers/appcontroller.dart';
import 'package:phr/models/bmi.dart';
import 'package:phr/widgets/boxcolumndata_widget.dart';

class BmiInfoWidget extends StatelessWidget {
  BmiInfoWidget({Key? key}) : super(key: key);

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
                        Text("BMI"),
                      ],
                    ),

                    // statistic
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: FutureBuilder(
                        future: appController.loadBMI(),
                        builder: (BuildContext context, AsyncSnapshot<Box<Bmi>> snapshot) {
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
                                  BoxColumnDataWidget(title: "Weight", value: '${box.values.last.weight}', subTitle: "kg."),
                                  BoxColumnDataWidget(title: "Height", value: '${box.values.last.height}', subTitle: "cm."),
                                  BoxColumnDataWidget(title: "BMI", value: box.values.last.bmi.toStringAsFixed(2), subTitle: "kg./m^2"),
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
            // Todo: add navigation to bmi page
          },
        );
      },
    );
  }
}
