import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:phr/controllers/appcontroller.dart';

class YourInfoWidget extends StatelessWidget {
  YourInfoWidget({Key? key}) : super(key: key);

  final AppController appController = Get.find<AppController>();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          GetBuilder<AppController>(
            init: AppController(),
            builder: (controller) {
              return Text('${controller.yourName}');
            },
          )
        ],
      ),
    );
  }
}
