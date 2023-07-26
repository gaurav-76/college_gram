import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:college_gram_app/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:college_gram_app/page_screens/events_meetings/screens/edit_event.dart';
import 'package:college_gram_app/providers/user_provider.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

// import '../model/event.dart';

class EventDetails extends StatefulWidget {
  final eventId;
  // final Function() onDelete;

  const EventDetails({Key? key, required this.eventId});

  @override
  State<EventDetails> createState() => _EventDetails();
}

class _EventDetails extends State<EventDetails> {
  late DateTime _firstDay;
  late DateTime _lastDay;
  bool isLoading = false;
  var eventData = {};
  //String meetingLink = "google.com";
  //const EventDetails({Key? key, required this.event}) : super(key: key);

  @override
  void initState() {
    super.initState();
    _firstDay = DateTime.now().subtract(const Duration(days: 1000));
    _lastDay = DateTime.now().add(const Duration(days: 1000));
    getEventDetail();
  }


  getEventDetail() async {
    setState(() {
      isLoading = true;
    });
    try {
      var noticeSnapshot = await FirebaseFirestore.instance
          .collection("events")
          .doc(widget.eventId)
          .get();

      eventData = noticeSnapshot.data()!;

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
    final UserProvider userProvider = Provider.of<UserProvider>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('Event Details'),
        titleTextStyle: const TextStyle(
            color: Colors.black, fontSize: 25.0, fontWeight: FontWeight.w600),
        leading: IconButton(
          icon: Icon(Icons.clear),
          color: Colors.black,
          onPressed: () => Navigator.pop(context),
        ),
        actions: userProvider.getUser.uid == eventData['uid']
            ? [
                IconButton(
                  icon: Icon(Icons.edit),
                  color: Colors.black,
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => EditEvent(
                                  eventId: eventData['eventId'],
                                )));
                  },
                ),
              ]
            : [],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: <Widget>[
          Align(
            alignment: Alignment.bottomLeft,
            child: Padding(
              padding: const EdgeInsets.only(
                  left: 15.0, right: 25.0, bottom: 10.0, top: 10.0),
              child: RichText(
                text: TextSpan(
                  style: TextStyle(fontSize: 15.0, color: Colors.black),
                  children: <TextSpan>[
                    TextSpan(
                        text: 'Event Title : ',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    TextSpan(text: eventData['title']),
                  ],
                ),
              ),
            ),
          ),
          const Divider(),

          const SizedBox(height: 10.0),
          Align(
            alignment: Alignment.bottomLeft,
            child: Padding(
              padding: const EdgeInsets.only(
                  left: 15.0, right: 25.0, bottom: 10.0, top: 10.0),
              child: RichText(
                text: TextSpan(
                  style: TextStyle(fontSize: 15.0, color: Colors.black),
                  children: <TextSpan>[
                    TextSpan(
                        text: 'Event Description : ',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    TextSpan(text: eventData['description']),
                  ],
                ),
              ),
            ),
          ),
          const Divider(),
          
          Padding(
            padding: const EdgeInsets.only(
                left: 15.0, right: 25.0, bottom: 10.0, top: 10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: TextSpan(
                    style: TextStyle(fontSize: 15.0, color: Colors.black),
                    children: <TextSpan>[
                      TextSpan(
                          text: 'Event Start Time : ',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      TextSpan(text:eventData['startTime']),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 4.0),
                  child: RichText(
                    text: TextSpan(
                      style: TextStyle(fontSize: 15.0, color: Colors.black),
                      children: <TextSpan>[
                        TextSpan(
                            text: 'Event End Time : ',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            )),
                        TextSpan(text: eventData['endTime']),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          const Divider(),
          ListTile(
            //leading: Icon(Icons.short_text),
            title: Text(
              'Event Meeting Link',
              style: TextStyle(
                  fontSize: 15.0,
                  color: Colors.black,
                  fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              '${eventData['meetingLink']}',
              style: TextStyle(fontSize: 15.0, color: Colors.black),
            ),
            trailing: Icon(Icons.arrow_forward),
            onTap: () {
              showGeneralDialog(
                  context: context,
                  pageBuilder: (BuildContext buildContext, Animation animation,
                          Animation secondaryAnimation) =>
                      AlertDialog(
                        actions: [
                          Column(
                            children: [
                              _getCloseButton(context),
                              Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Center(
                                  child: ElevatedButton(
                                    child: Text(
                                      "Open in Browser",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 20),
                                    ),
                                    onPressed: () async {
                                      final url = '${eventData['meetingLink']}';

                                      if (await canLaunch(url)) {
                                        await launch(url);
                                      } else {
                                        throw 'Could not launch $url';
                                      }
                                    },
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Center(
                                  child: ElevatedButton(
                                    child: Text(
                                      "Open in App",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 20),
                                    ),
                                    onPressed: () async {
                                      final url = '${eventData['meetingLink']}';

                                      if (await canLaunch(url)) {
                                        await launch(url);
                                      } else {
                                        throw 'Could not launch $url';
                                      }
                                    },
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 20.0,
                              )
                            ],
                          ),
                        ],
                      ));
            },
          ),
          const Divider(),
          Align(
            alignment: Alignment.bottomLeft,
            child: Padding(
              padding: const EdgeInsets.only(
                  left: 15.0, right: 25.0, bottom: 10.0, top: 10.0),
              child: RichText(
                text: TextSpan(
                  style: TextStyle(fontSize: 15.0, color: Colors.black),
                  children: <TextSpan>[
                    TextSpan(
                        text: 'Event Date : ',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    TextSpan(
                        text:
                           eventData['date']== null ? DateTime.now().toString() : '${DateFormat("EEEE, dd MMMM, yyyy").format(eventData['date'].toDate()).toString()}'),
                  ],
                ),
              ),
            ),
          ),
          const Divider(),
        ],
      ),
    );
  }

  _getCloseButton(context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 10, 10, 0),
      child: GestureDetector(
        onTap: () {},
        child: Container(
          alignment: FractionalOffset.topRight,
          child: GestureDetector(
            child: Icon(
              Icons.clear,
              color: Colors.red,
            ),
            onTap: () {
              Navigator.pop(context);
            },
          ),
        ),
      ),
    );
  }
}
