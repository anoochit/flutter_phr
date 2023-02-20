import 'dart:typed_data';

import 'package:flutter/material.dart';

Future<dynamic> showCapturedWidget(
    BuildContext context, Uint8List capturedImage) {
  return showDialog(
    useSafeArea: false,
    context: context,
    builder: (context) => Scaffold(
      appBar: AppBar(
        title: const Text("Captured Widget Screenshot"),
      ),
      body: Center(
        child: Image.memory(capturedImage),
      ),
    ),
  );
}
