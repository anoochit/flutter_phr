import 'dart:io';

import 'package:flutter/material.dart';
import 'package:share/share.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class PDFViewerPage extends StatelessWidget {
  const PDFViewerPage({
    super.key,
    required this.path,
  });

  final String path;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("PDF Viewer"),
        actions: [
          IconButton(
            onPressed: () => Share.shareFiles(
              [path],
            ),
            icon: const Icon(Icons.share),
          )
        ],
      ),
      body: SfPdfViewer.file(
        File(path),
      ),
    );
  }
}
