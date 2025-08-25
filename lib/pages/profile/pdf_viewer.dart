import 'dart:io';

import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class PDFViewerPage extends StatelessWidget {
  const PDFViewerPage({super.key, required this.path});

  final String path;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("PDF Viewer"),
        actions: [
          IconButton(
            onPressed: () async {
              //  SharePlus.shareFiles([path])
              final params = ShareParams(
                title: 'Share file',
                files: [XFile(path)],
              );
              await SharePlus.instance.share(params);
            },
            icon: const Icon(Icons.share),
          ),
        ],
      ),
      body: SfPdfViewer.file(File(path)),
    );
  }
}
