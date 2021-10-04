import 'package:flutter/material.dart';

class GlucosePage extends StatefulWidget {
  const GlucosePage({Key? key}) : super(key: key);

  @override
  _GlucosePageState createState() => _GlucosePageState();
}

class _GlucosePageState extends State<GlucosePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Blood Glucose"),
      ),
      body: Container(),
    );
  }
}
