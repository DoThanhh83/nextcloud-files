import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
class PreviewFile extends StatefulWidget {
  final Uint8List? data;
  final String? title;
  const PreviewFile({Key? key, this.data,this.title}) : super(key: key);

  @override
  State<PreviewFile> createState() => _PreviewFileState();
}

class _PreviewFileState extends State<PreviewFile> {
  Uint8List? _documentBytes;

  @override
  void initState() {
    super.initState();
    _documentBytes = widget.data;
  }

  @override
  Widget build(BuildContext context) {
    Widget child = const Center(child: CircularProgressIndicator());
    if (_documentBytes != null) {
      child = SfPdfViewer.memory(
        _documentBytes!,
      );
    }
    return Scaffold(
      appBar: AppBar(title:  Text( widget.title ?? 'PDF Viewer')),
      body: child,
    );
  }
}
