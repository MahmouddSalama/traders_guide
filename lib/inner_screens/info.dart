import 'package:flutter/material.dart';
import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';

class InFo extends StatelessWidget {
  final String pdfPath;
  final String title;

  const InFo({
    Key? key,
    required this.pdfPath,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          title,
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          color: Colors.white,
          height: size.height,
          width: size.width,
          child: PDF().fromAsset(pdfPath),
        ),
      ),
    );
  }
}
