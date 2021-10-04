import 'package:flutter/material.dart';

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
      ),
      body: Container(),
    );
  }
}
