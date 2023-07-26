import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:college_gram_app/page_screens/events_meetings/screens/event_details.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:college_gram_app/providers/user_provider.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../utils/colors.dart';
import '../../../utils/global_variables.dart';


class EventItem extends StatefulWidget {
  
  final snap;


  const EventItem({
    Key? key, required this.snap,

  }) : super(key: key);

  @override
  State<EventItem> createState() => _EventItemState();
}

class _EventItemState extends State<EventItem>{


  @override
  void initState()
  {
    super.initState();
     
  }


  @override
  Widget build(BuildContext context) {
    final UserProvider userProvider = Provider.of<UserProvider>(context);
    
    return  Container(
      decoration: BoxDecoration(
          border: Border.all(
              color: MediaQuery.of(context).size.width > webScreenSize
                  ? secondaryColor
                  : primaryColor),
          color: Theme.of(context).scaffoldBackgroundColor),
      padding: const EdgeInsets.symmetric(
        vertical: 5,
      ),
      child:GestureDetector(
      child: Padding(
        padding: const EdgeInsets.all(4.0),
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
                          child: userProvider.getUser.uid == widget.snap['uid']
                              ? IconButton(
                                  icon: Icon(
                                    Icons.delete,
                                    size: 19,
                                  ),
                                  onPressed: () async{
                                  
                               await FirebaseFirestore.instance
                              .collection('events')
                              .doc(widget.snap['eventId'])
                              .delete();
                              //EventScreen();
                                  }
                                  
                                  //onDelete,
                                )
                              : Icon(Icons.more_vert),
                        ),
                      ],
                    ),
                    Divider(
                      color: Colors.grey[500],
                    ),
                    // Text(DateFormat.yMMMd().format(
                    //   widget.snap['datePublished'].toDate(),
                    // )),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: RichText(
                        text: TextSpan(
                          children: [
                            WidgetSpan(
                              child: Icon(
                                CupertinoIcons.clock_fill,
                                size: 19,
                                color: Colors.grey[800],
                              ),
                            ),
                            TextSpan(text: '  '),
                            TextSpan(
                                text: widget.snap['startTime'],
                                style: TextStyle(color: Colors.grey[800])),
                            TextSpan(text: ' - '),
                            TextSpan(
                                text: widget.snap['endTime'],
                                style: TextStyle(color: Colors.grey[800])),
                          ],
                        ),
                      ),
                    ),
      
                    RichText(
                      text: TextSpan(
                        children: [
                          WidgetSpan(
                            child: Icon(
                              Icons.calendar_month_rounded,
                              size: 19,
                              color: Colors.grey[800],
                            ),
                          ),
                          TextSpan(text: '  '),
                          TextSpan(
                              text: widget.snap['date'] == null ? DateTime.now().toString(): DateFormat("EEEE, dd MMMM, yyyy")
                                  .format(widget.snap['date'].toDate()).toString(),
                              style: TextStyle(color: Colors.grey[800])),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => EventDetails(
                      eventId: widget.snap['eventId'],
                    )));
      } 
      
    ));


  }
}
