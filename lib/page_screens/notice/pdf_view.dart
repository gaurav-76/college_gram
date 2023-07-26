

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class PdfView extends StatefulWidget {

  final url;

  PdfView({
    Key? key,
    this.url,
  }) : super(key: key);

  @override
  State<PdfView> createState() => _PdfViewState();
}

class _PdfViewState extends State<PdfView> {
  

  PdfViewerController? _pdfViewerController;

  void initState() {
    _pdfViewerController = PdfViewerController();
  }

  @override
  Widget build(BuildContext context) {
    

    return Scaffold(
        appBar: AppBar(
          
          backgroundColor: Colors.white,
          leading: const BackButton(color: Colors.black),
          actions: <Widget>[
            IconButton(
              icon: Icon(
                Icons.keyboard_arrow_up,
                color: Colors.white,
              ),
              onPressed: () {
                _pdfViewerController!.previousPage();
              },
            ),
            IconButton(
              icon: Icon(
                Icons.keyboard_arrow_down,
                color: Colors.white,
              ),
              onPressed: () {
                _pdfViewerController!.nextPage();
              },
            )
          ],
        ),
        body: SfPdfViewer.network(widget.url,
            controller: _pdfViewerController,
            pageLayoutMode: PdfPageLayoutMode.continuous,
            enableDoubleTapZooming: true,
            scrollDirection: PdfScrollDirection.vertical)
        );
  }
}
