import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:college_gram_app/utils/utils.dart';
import 'package:college_gram_app/widgets/constants.dart';
import 'package:college_gram_app/resources/firestore_methods.dart';
import 'package:provider/provider.dart';
import '../../providers/user_provider.dart';
import 'Upload files Modal/button_widget.dart';

class UploadNotice extends StatefulWidget {
  @override
  _UploadNotice createState() => _UploadNotice();
}

class _UploadNotice extends State<UploadNotice> {
  final TextEditingController _title = TextEditingController();
  final TextEditingController _notice_desc = TextEditingController();
  bool isLoading = false;
  late String basename = 'No File Selected';
  UploadTask? task;
  File? file;

  void postNotice(String uid, String name) async {
    setState(() {
      isLoading = true;
    });
    try {
      String res = await FirestoreMethods().uploadNotice(
        file!,
        _title.text,
        _notice_desc.text,
        uid,
        name,
      );

      if (res == 'success') {
        setState(() {
          isLoading = false;
          //uploadFile();
        });
        showSnackBar("Posted!", this.context);
        clearNotice();
      } else {
        setState(() {
          isLoading = false;
        });
        showSnackBar(res, this.context);
      }
    } catch (err) {
      setState(() {
        isLoading = false;
      });
      showSnackBar(err.toString(), this.context);
    }
  }

  void clearNotice() {
    setState(() {
      file = null;
      basename = 'No File Selected';
    });
  }

  @override
  void dispose() {
    super.dispose();
    _title.dispose();
    _notice_desc.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //final fileName = file != null ? basename : 'No File Selected';
    final UserProvider userProvider = Provider.of<UserProvider>(context);

    return Scaffold(
      appBar: AppBar(
          title: Text('Upload New Notice'),
          backgroundColor: Colors.white,
          titleTextStyle: const TextStyle(
              color: Colors.black, fontSize: 20.0, fontWeight: FontWeight.w600),
          centerTitle: true,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.of(context).pop(),
          )),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.only(left: 32, right: 32, top: 42),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Title',
                    style: kLabelStyle,
                  ),
                  SizedBox(height: 10.0),
                  Container(
                    alignment: Alignment.centerLeft,
                    decoration: kBoxDecorationStyle,
                    height: 60.0,
                    child: TextFormField(
                      keyboardType: TextInputType.text,
                      style: TextStyle(
                        color: Colors.black,
                        fontFamily: 'OpenSans',
                      ),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.only(top: 14.0),
                        prefixIcon: const Icon(
                          Icons.title_rounded,
                          color: Colors.black,
                        ),
                        hintText: 'Title',
                        //hintStyle: kHintTextStyle,
                      ),
                      controller: _title,
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 40.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Description',
                      style: kLabelStyle,
                    ),
                    SizedBox(height: 10.0),
                    Container(
                      alignment: Alignment.topLeft,
                      decoration: kBoxDecorationStyle,
                      height: 120.0,
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: TextField(
                          maxLines: null,
                          expands: true,
                          keyboardType: TextInputType.text,
                          style: TextStyle(
                            color: Colors.black,
                            fontFamily: 'OpenSans',
                          ),
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: 'If any (optional)',
                          ),
                          controller: _notice_desc,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 40.0,
              ),
              Padding(
                padding:
                    const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 8.0),
                child: ButtonWidget(
                  text: 'Select File',
                  icon: Icons.attach_file,
                  onClicked: selectFile,
                ),
              ),
              file != null
                  ? Text((file!.path.split('/').last).toString())
                  : Text(basename),
              SizedBox(height: 30),
              Container(
                padding: EdgeInsets.symmetric(vertical: 20.0),
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    height: 50.0,
                    child: ElevatedButton(
                      //elevation: 5.0,
                      style: ElevatedButton.styleFrom(
                        primary: Color.fromRGBO(41, 49, 48, 1),
                      ),
                      onPressed: () => postNotice(
                          userProvider.getUser.uid, userProvider.getUser.name),
                      child: isLoading
                          ? const Center(
                              child: CircularProgressIndicator(
                                color: Colors.white,
                              ),
                            )
                          : const Text(
                              'Upload Notice',
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
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Future selectFile() async {
    final result = await FilePicker.platform.pickFiles(allowMultiple: false);

    if (result == null) return;
    final path = result.files.single.path;
    setState(() {
      file = File(path!);
      basename = File(path).toString();
    });
  }
}
