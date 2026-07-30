import 'package:flutter/material.dart';

class LegalDocumentScreen extends StatelessWidget {
  final String title;
  final String content;

  const LegalDocumentScreen({
    super.key,
    required this.title,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        centerTitle: true,
      ),
      body: Scrollbar(
        thumbVisibility: true,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: SelectableText( // Allows user to select/copy text if needed
            content,
            style: const TextStyle(
              fontSize: 14, 
              color: Colors.black87,
              height: 1.4,
            ),
          ),
        ),
      ),
    );
  }
}
