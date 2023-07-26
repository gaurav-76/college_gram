import 'dart:io' as io;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:college_gram_app/page_screens/notice/pdf_view.dart';
import 'package:college_gram_app/utils/utils.dart';
import 'package:intl/intl.dart';
import 'package:dio/dio.dart';
import 'package:permission_handler/permission_handler.dart';

class NoticeInfo extends StatefulWidget {
  final String noticeId;

  const NoticeInfo({
    Key? key,
    required this.noticeId,
  }) : super(key: key);

  @override
  State<NoticeInfo> createState() => _NoticeInfoState();
}

class _NoticeInfoState extends State<NoticeInfo> {
  var noticeData = {};
  bool isLoading = false;

  //double? _progress;

  @override
  void initState() {
    super.initState();
    getNoticeDetail();
  }

  getNoticeDetail() async {
    setState(() {
      isLoading = true;
    });
    try {
      var noticeSnapshot = await FirebaseFirestore.instance
          .collection("notices")
          .doc(widget.noticeId)
          .get();

      noticeData = noticeSnapshot.data()!;

      setState(() {});
    } catch (e) {
      showSnackBar(e.toString(), context);
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    
    return isLoading
        ? const Center(
            child: CircularProgressIndicator(
               color: Colors.black,
            ),
          )
        : Scaffold(
            appBar: AppBar(
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              centerTitle: false,
              leading: const BackButton(
                color: Colors.black,
              ),
            ),
            body: Column(
              children: [
                //const Divider(),
                Align(
                  alignment: Alignment.bottomLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 25.0, right: 25.0, bottom: 10.0, top: 20.0),
                    child: RichText(
                      text: TextSpan(
                        style: TextStyle(fontSize: 15.0, color: Colors.black),
                        children: <TextSpan>[
                          TextSpan(
                              text: 'Title : ',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          TextSpan(text: noticeData["title"]),
                        ],
                      ),
                    ),
                  ),
                ),
                const Divider(),
                Align(
                  alignment: Alignment.bottomLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 25.0, right: 25.0, bottom: 10.0, top: 10.0),
                    child: RichText(
                      text: TextSpan(
                        style: TextStyle(fontSize: 15.0, color: Colors.black),
                        children: <TextSpan>[
                          TextSpan(
                              text: 'Description : ',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          TextSpan(
                              text: noticeData['description'].isEmpty
                                  ? 'No Description Available'
                                  : noticeData['description']),
                        ],
                      ),
                    ),
                  ),
                ),
                const Divider(),
                Align(
                  alignment: Alignment.bottomLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 25.0, right: 25.0, bottom: 10.0, top: 10.0),
                    child: RichText(
                      text: TextSpan(
                        style: TextStyle(fontSize: 15.0, color: Colors.black),
                        children: <TextSpan>[
                          TextSpan(
                              text: 'Uploaded By : ',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          TextSpan(text: noticeData['name']),
                        ],
                      ),
                    ),
                  ),
                ),
                const Divider(),
                Align(
                  alignment: Alignment.bottomLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 25.0, right: 25.0, bottom: 10.0, top: 10.0),
                    child: RichText(
                      text: TextSpan(
                        style: TextStyle(fontSize: 15.0, color: Colors.black),
                        children: <TextSpan>[
                          TextSpan(
                              text: 'Uploaded On : ',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          TextSpan(
                              text: DateFormat.yMMMd().format(
                                  noticeData['datePublished'].toDate())),
                        ],
                      ),
                    ),
                  ),
                ),
                Divider(),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 20.0),
                        width: double.infinity,
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: SizedBox(
                            height: 40.0,
                            child: ElevatedButton(
                              //elevation: 5.0,
                              style: ElevatedButton.styleFrom(
                                primary: Color.fromRGBO(41, 49, 48, 1),
                              ),
                              onPressed: () =>
                                  Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) =>
                                    PdfView(url: noticeData["postUrl"]),
                              )),

                              child: const Text(
                                'View',
                                style: TextStyle(
                                  color: Color(0xFFffffff),
                                  letterSpacing: 1.5,
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'OpenSans',
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                   
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 20.0),
                        width: double.infinity,
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: SizedBox(
                            height: 40.0,
                            child: ElevatedButton(
                              //elevation: 5.0,
                              style: ElevatedButton.styleFrom(
                                primary: Color.fromRGBO(41, 49, 48, 1),
                              ),

                              onPressed: () async {
                                Map<Permission, PermissionStatus> statuses =
                                    await [
                                  Permission.storage,
                                  //add more permission to request here.
                                ].request();

                                if (statuses[Permission.storage]!.isGranted) {
                                  var path = "/storage/emulated/0/Download/";
                                  var dir = io.Directory(path);
                                 
                                  if (dir != null) {
                                    String name = noticeData["title"];
                                    String savename = "$name.pdf";
                                    String savePath = dir.path + "/$savename";
                                    print(savePath);
                                    //output:  /storage/emulated/0/Download/banner.png

                                    try {
                                       showSnackBar("Downloading Started...",
                                            this.context);
                                      await Dio().download(
                                          noticeData['postUrl'], savePath,
                                          onReceiveProgress: (received, total) {
                                        if (total != -1) {
                                          print((received / total * 100)
                                                  .toStringAsFixed(0) +
                                              "%");
                                          
                                        }
                                      });
                                      //print("File is saved to download folder.");
                                      showSnackBar(
                                          "File is saved to download folder!",
                                          this.context);
                                      
                                    } on DioError catch (e) {
                                      print(e.message);
                                      showSnackBar(
                                          (e.message).toString(), this.context);
                                    }
                                  }
                                } else {
                                  print("No permission to read and write.");
                                }
                              },
                              child: const Text(
                                'Download',
                                style: TextStyle(
                                  color: Color(0xFFffffff),
                                  letterSpacing: 1.5,
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'OpenSans',
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          );
  }
}
