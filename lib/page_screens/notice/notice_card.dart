// import 'dart:io';
// import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:college_gram_app/model/users.dart';
import 'package:college_gram_app/page_screens/notice/notice_info.dart';
import 'package:college_gram_app/providers/user_provider.dart';
import 'package:college_gram_app/utils/colors.dart';
import 'package:college_gram_app/utils/global_variables.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class NoticeCard extends StatefulWidget {
  // ignore: prefer_typing_uninitialized_variables
  final snap;
  const NoticeCard({Key? key, required this.snap}) : super(key: key);

  @override
  State<NoticeCard> createState() => _NoticeCardState();
}

class _NoticeCardState extends State<NoticeCard> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final User user = Provider.of<UserProvider>(context).getUser;
    return Container(
      decoration: BoxDecoration(
          border: Border.all(
              color: MediaQuery.of(context).size.width > webScreenSize
                  ? secondaryColor
                  : primaryColor),
          color: Theme.of(context).scaffoldBackgroundColor),
      padding: const EdgeInsets.symmetric(
        vertical: 5,
      ),
      child: GestureDetector(
          child: Container(
            child: Card(
              //color: Color.fromARGB(255, 217, 217, 217),
              color: Colors.white,
              elevation: 4.0,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Align(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: Text(
                              widget.snap['title'],
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16.0),
                            ),
                          ),
                          Align(
                            alignment: Alignment.topRight,
                            child: Icon(
                              Icons.more_vert,
                              size: 19,
                            ),
                          ),
                        ],
                      ),
                      Divider(
                        color: Colors.grey[450],
                      ),
                      RichText(
                        text: TextSpan(
                          children: [
                            WidgetSpan(
                              child: Icon(
                                Icons.calendar_month_rounded,
                                size: 19,
                              ),
                              style: TextStyle(color: Colors.grey[800]),
                            ),
                            TextSpan(text: '  '),
                            TextSpan(
                              text: DateFormat.yMMMd().format(
                                  widget.snap['datePublished'].toDate()),
                              style: TextStyle(
                                  color: Colors.grey[800], fontSize: 15.0),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => NoticeInfo(
                      noticeId: widget.snap['noticeId'],
                    )));
          }),
    );
  }
}
