import 'dart:io';
import 'dart:convert';

import 'package:csv/csv.dart';

import 'package:flutter/material.dart';
import 'package:share/share.dart';

class CSVViewerPage extends StatelessWidget {
  const CSVViewerPage({
    super.key,
    required this.path,
  });

  final String path;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("CSV Viewer"),
        actions: [
          IconButton(
            onPressed: () => Share.shareFiles(
              [path],
            ),
            icon: const Icon(Icons.share),
          )
        ],
      ),
      body: const Center(
        child: Text(
          'To view, please export this',
        ),
      ),
    );
  }

  Future<List<List<dynamic>>> loadingCsvData(String path) async {
    final csvFile = File(path).openRead();
    return await csvFile
        .transform(utf8.decoder)
        .transform(
          const CsvToListConverter(),
        )
        .toList();
  }
}
