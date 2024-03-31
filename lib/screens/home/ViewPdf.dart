import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';
import 'package:hellomegha/core/utils/strings.dart';

class ViewPdf extends StatefulWidget {
  final String? path;

  ViewPdf({Key? key, this.path}) : super(key: key);

  @override
  State<ViewPdf> createState() => _ViewPdfState();
}

class _ViewPdfState extends State<ViewPdf> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70.0),
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: AppBar(
            leading: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: const Padding(
                padding: EdgeInsets.only(left: 3.0),
                child: SizedBox(
                  height: 27,
                  child: Icon(
                    Icons.arrow_back,
                    color: Colors.amber,
                  ),
                ),
              ),
            ),
            elevation: 0,
            titleSpacing: 0,
            backgroundColor: Colors.white,
            title: Text(
              'View Bank Statement',
              style: TextStyle(
                  fontFamily: Strings.robotoMedium,
                  fontSize: 21.0,
                  color: Colors.black),
            ),
            iconTheme: const IconThemeData(color: Colors.black),
          ),
        ),
      ),
      body:  PDF().cachedFromUrl(
        '${widget.path}',
        placeholder: (progress) => Center(child: Text('$progress %')),
        errorWidget: (error) => Center(child: Text(error.toString())),
      ),
    );
  }
}
