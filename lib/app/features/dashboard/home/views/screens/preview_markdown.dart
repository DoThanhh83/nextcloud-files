import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class PreviewMarkdown extends StatefulWidget {
  final Uint8List? data;
  final String? title;

  const PreviewMarkdown({Key? key, this.data, this.title}) : super(key: key);

  @override
  State<PreviewMarkdown> createState() => _PreviewMarkdownState();
}

class _PreviewMarkdownState extends State<PreviewMarkdown> {
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
      child = Markdown(
        data: String.fromCharCodes(_documentBytes!),
        imageBuilder: (Uri uri, String? title, String? alt) {
          return Image.memory(_documentBytes!);
        },
      );
    }
    return Scaffold(
      appBar: AppBar(title: Text(widget.title ?? 'PDF Viewer')),
      body: child,
    );
  }
}
