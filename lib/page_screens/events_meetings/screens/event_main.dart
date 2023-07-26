import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:college_gram_app/utils/global_variables.dart';
import 'package:flutter/material.dart';
import 'package:college_gram_app/page_screens/events_meetings/screens/event_details.dart';
import 'package:college_gram_app/providers/user_provider.dart';
import 'package:college_gram_app/utils/utils.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

import '../model/event.dart';
import '../widgets/event_item.dart';
import 'add_event.dart';

class EventScreen extends StatefulWidget {
  const EventScreen({Key? key});

  @override
  State<EventScreen> createState() => _MyEventScreen();
}

class _MyEventScreen extends State<EventScreen> {
  // late DateTime _focusedDay;
  late DateTime _firstDay;
  late DateTime _lastDay;
  late DateTime _selectedDay;
  // late CalendarFormat _calendarFormat;
  // late Map<DateTime, List<Event>> _events;

  // late Map<DateTime, List<Event>> mySelectedEvents;
  // late Map<DateTime, List<Event>> _groupedEvents;

  bool isLoading = false;

  final today = DateTime.now();

  // int getHashCode(DateTime key) {
  //   return key.day * 1000000 + key.month * 10000 + key.year;
  // }


   



  @override
  void initState() {
    super.initState();
    // mySelectedEvents = {};
    // _groupedEvents = {};
    // _events = LinkedHashMap(
    //   equals: isSameDay,
    //   hashCode: getHashCode,
    // );
    // _focusedDay = DateTime.now();
     _firstDay = DateTime.now().subtract(const Duration(days: 1000));
     _lastDay = DateTime.now().add(const Duration(days: 1000));
     _selectedDay = DateTime.now();
    // _calendarFormat = CalendarFormat.month;
    // _loadFirestoreEvents();
  }

  // _loadFirestoreEvents() async {
  //   setState(() {
  //     isLoading = true;
  //   });

  //   final firstDay = DateTime(_focusedDay.year, _focusedDay.month, 1);
  //   final lastDay = DateTime(_focusedDay.year, _focusedDay.month + 1, 0);
  //   _events = {};

  //   final snap =  await FirebaseFirestore.instance
  //       .collection('events')
  //       .where('date', isGreaterThanOrEqualTo: firstDay)
  //       .where('date', isLessThanOrEqualTo: lastDay)
  //       .withConverter<Event>(
  //           fromFirestore: Event.fromFirestore,
  //           toFirestore: (event, options) => event.toFirestore())
  //       .get();
  //   for (var doc in snap.docs) {
  //     final event = doc.data();
  //     final day =
  //         DateTime.utc(event.date.year, event.date.month, event.date.day);
  //     if (_events[day] == null) {
  //       _events[day] = [];
  //     }
  //     _events[day]!.add(event);
  //   }
  //   setState(() {
  //     isLoading = false;
  //   });
  // }

  // List<Event> _getEventsForTheDay(DateTime day) {
  //   return _events[day] ?? [];
  // }

  // _groupEvents(List<Event> events)  {
  //   _groupedEvents = {};
  //   events.forEach((event) {
  //     DateTime date =
  //         DateTime.utc(event.date.year, event.date.month, event.date.day, 12);
  //     if (_groupedEvents[date] == null) _groupedEvents[date] = [];
  //     _groupedEvents[date]!.add(event);
  //   });
  // }

  // List<Event> _listOfDayEvents(DateTime dateTime) {
  //   return _groupedEvents[dateTime] ?? [];
  // }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final UserProvider userProvider = Provider.of<UserProvider>(context);
    
    final width = MediaQuery.of(context).size.width;


    return Scaffold(
      appBar: AppBar(
          title: (userProvider.getUser.choice == 'Society')
              ? const Text('Events')
              : const Text("Events "),
          titleTextStyle: const TextStyle(
              color: Colors.black, fontSize: 25.0, fontWeight: FontWeight.w600),
          centerTitle: true,
          //elevation: 0.0,
          backgroundColor: Colors.white),
      // body: userProvider.getUser.choice == 'Student' ?
      // Text('No New Meetings')
      // :
      body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('events')//.where('date', isEqualTo:DateTime.now())
              .orderBy('date', descending: true)
              .snapshots(),
          builder: (context,
              AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(color:Colors.black),
              );
            }
             
             return snapshot.data!.docs.isEmpty ? const Center(
                    child: Text(
                    'No Events',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  )) : Column(
                    children: [
                     Expanded(
                        child: ListView.builder(
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (context, index) => Container(
                            margin: EdgeInsets.symmetric(
                              horizontal:
                                  width > webScreenSize ? width * 0.3 : 0,
                              vertical: width > webScreenSize ? 10 : 0,
                            ),
                            child: EventItem(
                              snap: snapshot.data!.docs[index].data(),
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
             
          //   return ListView(
          //     children: [
          //       Card(
          //         margin: const EdgeInsets.all(8.0),
          //         elevation: 5.0,
          //         shape: const RoundedRectangleBorder(
          //           borderRadius: BorderRadius.all(
          //             Radius.circular(10),
          //           ),
          //           side: BorderSide(color: Colors.black, width: 2.0),
          //         ),
          //         child: TableCalendar(
          //           eventLoader: _getEventsForTheDay,
          //           calendarFormat: _calendarFormat,
          //           onFormatChanged: (format) {
          //             setState(() {
          //               _calendarFormat = format;
          //             });
          //           },
          //           focusedDay: _focusedDay,
          //           firstDay: _firstDay,
          //           lastDay: _lastDay,
          //           weekendDays: const [DateTime.sunday, 6],
          //           startingDayOfWeek: StartingDayOfWeek.monday,
          //           daysOfWeekHeight: 40.0,
          //           rowHeight: 46.0,
          //           onPageChanged: (focusedDay) {
          //             setState(() {
          //               _focusedDay = focusedDay;
          //             });
          //             _loadFirestoreEvents();
          //           },
          //           selectedDayPredicate: (day) => isSameDay(day, _selectedDay),
          //           onDaySelected: (selectedDay, focusedDay) {
          //             print(_events[selectedDay]);
          //             setState(() {
          //               _selectedDay = selectedDay;
          //               _focusedDay = focusedDay;
          //             });
          //           },
          //           calendarStyle: const CalendarStyle(
          //             weekendTextStyle: TextStyle(
          //               color: Colors.red,
          //             ),
          //             selectedDecoration: BoxDecoration(
          //               shape: BoxShape.circle,
          //               color: Color(0xFF54b435),
          //             ),
          //             // outsideDaysVisible: false,
          //           ),
          //           headerStyle: const HeaderStyle(
          //             titleCentered: true,
          //             titleTextStyle:
          //                 TextStyle(color: Colors.white, fontSize: 20.0),
          //             decoration: BoxDecoration(
          //                 color: Colors.black,
          //                 borderRadius: BorderRadius.only(
          //                     topLeft: Radius.circular(10),
          //                     topRight: Radius.circular(10))),
          //             formatButtonTextStyle:
          //                 TextStyle(color: Colors.red, fontSize: 16.0),
          //             formatButtonDecoration: BoxDecoration(
          //               color: Colors.yellow,
          //               borderRadius: BorderRadius.all(
          //                 Radius.circular(5.0),
          //               ),
          //             ),
          //             leftChevronIcon: Icon(
          //               Icons.chevron_left,
          //               color: Colors.yellow,
          //               size: 28,
          //             ),
          //             rightChevronIcon: Icon(
          //               Icons.chevron_right,
          //               color: Colors.yellow,
          //               size: 28,
          //             ),
          //           ),
          //         ),
          //       ),

          //       // edit event
          //       ..._getEventsForTheDay(_selectedDay).map(
          //         (event) => EventItem(
          //             event: event,
          //             onTap: () async {
          //               final res = await Navigator.push<bool>(
          //                 context,
          //                 MaterialPageRoute(
          //                     builder: (_) => EventDetails(
          //                           event: event,
          //                         )),
          //               );
          //               if (res ?? false) {
          //                 _loadFirestoreEvents();
          //               }
          //             },
          //             onDelete: () async {
          //               final delete = await showDialog<bool>(
          //                 context: context,
          //                 builder: (_) => AlertDialog(
          //                   title: const Text("Delete Event?"),
          //                   content:
          //                       const Text("Are you sure you want to delete?"),
          //                   actions: [
          //                     TextButton(
          //                       onPressed: () => Navigator.pop(context, false),
          //                       style: TextButton.styleFrom(
          //                         foregroundColor: Colors.black,
          //                       ),
          //                       child: const Text("No"),
          //                     ),
          //                     TextButton(
          //                       onPressed: () => Navigator.pop(context, true),
          //                       style: TextButton.styleFrom(
          //                         foregroundColor: Colors.red,
          //                       ),
          //                       child: const Text("Yes"),
          //                     ),
          //                   ],
          //                 ),
          //               );
          //               if (delete ?? false) {
          //                 await FirebaseFirestore.instance
          //                     .collection('events')
          //                     .doc(event.eventId)
          //                     .delete();

          //                 showSnackBar("Event Deleted Successfully!", context);
          //                 _loadFirestoreEvents();
          //               }
          //             }),
          //       ),
          //     ],
          //   );
           }),

      floatingActionButton: userProvider.getUser.choice == 'Society'
          ? FloatingActionButton.extended(
              label: const Text(' + Add Event'),
              backgroundColor: Colors.black,
              onPressed: () async {
                final result = await Navigator.push<bool>(
                  context,
                  MaterialPageRoute(
                    builder: (_) => AddEvent(
                      firstDate: _firstDay,
                      lastDate: _lastDay,
                      selectedDate: _selectedDay,
                    ),
                  ),
                );
                // if (result ?? false) {
                //   _loadFirestoreEvents();
                // }
              },
              //child: const Icon(Icons.add),
            )
          : Text(''),
    );
  }
}
