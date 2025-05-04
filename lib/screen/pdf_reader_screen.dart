import 'package:flutter/material.dart';
import 'package:new_ui/config.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class PdfReaderScreen extends StatelessWidget {
  final String url;
  final String fullUrl;

  PdfReaderScreen({super.key, required this.url})
      : fullUrl = Uri.parse(AppConfig.apiUrl).resolve(url).toString();

  @override
  Widget build(BuildContext context) {
    print("Loading PDF from: $fullUrl");

    return Scaffold(
      appBar: AppBar(
        title: Text('PDF Viewer'),
      ),
      body: SfPdfViewer.network(fullUrl),
    );
  }
}
