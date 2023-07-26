import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:college_gram_app/resources/firestore_methods.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:college_gram_app/providers/user_provider.dart';
import 'package:college_gram_app/utils/utils.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class EditEvent extends StatefulWidget {
  // final DateTime firstDate;
  // final DateTime lastDate;
  //final Event event;
  final eventId;
  const EditEvent(
      {Key? key,
      // required this.firstDate,
      // required this.lastDate,
      required this.eventId})
      : super(key: key);

  @override
  State<EditEvent> createState() => _EditEventState();
}

class _EditEventState extends State<EditEvent> {
  late DateTime _selectedDate;
  late TextEditingController _titleController;
  late TextEditingController _descController;
  late TextEditingController _meetingController;
  late TextEditingController _startTimeController;
  late TextEditingController _endTimeController;
  
  bool isLoading = false;
  var eventData = {};

  @override
  void initState() {
    super.initState();

    getEventDetail();
    _selectedDate = eventData['date'];
    _titleController = TextEditingController(text: eventData['title']);
    _descController = TextEditingController(text: eventData['description']);
    _meetingController = TextEditingController(text: eventData['meetingLink']);
    _startTimeController = TextEditingController(text:eventData['startTime']);
    _endTimeController = TextEditingController(text: eventData['endTime']);
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
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final UserProvider userProvider = Provider.of<UserProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Event'),
        leading: const BackButton(
          color: Colors.black, // <-- SEE HERE
        ),
        titleTextStyle: const TextStyle(
            color: Colors.black, fontSize: 25.0, fontWeight: FontWeight.w600),
        centerTitle: false,
        backgroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          FormBuilderTextField(
            validator: FormBuilderValidators.required(),
            name: "title",
            decoration: InputDecoration(
                hintText: "Event Title",
                border: InputBorder.none,
                contentPadding: const EdgeInsets.only(left: 48.0)),
            controller: _titleController,
          ),
          Divider(),
          FormBuilderTextField(
            validator: FormBuilderValidators.required(),
            name: "description",
            minLines: 1,
            maxLines: 5,
            decoration: InputDecoration(
                hintText: "Event Description",
                border: InputBorder.none,
                prefixIcon: Icon(Icons.short_text)),
            controller: _descController,
          ),
          const Divider(),
          Row(
            children: [
              Expanded(
                child: FormBuilderDateTimePicker(
                  validator: FormBuilderValidators.required(),
                  name: "startTime",
                  initialTime: TimeOfDay.now(),
                  inputType: InputType.time,
                  format:DateFormat.jm(),
                  decoration: InputDecoration(
                    hintText: 'Start Time',
                    border: InputBorder.none,
                    prefixIcon: Icon(CupertinoIcons.clock_fill),
                  ),
                  controller: _startTimeController,
                ),
              ),
              //Divider(),
              Expanded(
                child: FormBuilderDateTimePicker(
                  validator: FormBuilderValidators.required(),
                  name: "endTime",
                  initialTime: TimeOfDay.now(),
                  inputType: InputType.time,
                  format: DateFormat.jm(),
                  decoration: InputDecoration(
                    hintText: 'End Time',
                    border: InputBorder.none,
                    prefixIcon: Icon(CupertinoIcons.clock_fill),
                  ),
                  controller:_endTimeController,
                ),
              ),
            ],
          ),
          const Divider(),



          FormBuilderTextField(
            validator: FormBuilderValidators.required(),
            name: "meetingLink",
            minLines: 1,
            maxLines: 5,
            decoration: InputDecoration(
                hintText: "Event Meeting Link",
                border: InputBorder.none,
                prefixIcon: Icon(Icons.short_text)),
            controller: _meetingController,
          ),
          Divider(),
          FormBuilderDateTimePicker(
            validator: FormBuilderValidators.required(),
            name: "date",
            initialValue:DateTime.now(),
            initialDate: DateTime.now(),
            fieldHintText: "Add Date",
            initialDatePickerMode: DatePickerMode.day,
            inputType: InputType.date,
            format: DateFormat('EEEE, dd MMMM, yyyy'),
            decoration: InputDecoration(
              border: InputBorder.none,
              prefixIcon: Icon(Icons.calendar_today_sharp),
            ),
          ),
          Divider(),
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
                  onPressed: () {
                    _addEvent(
                        userProvider.getUser.name, userProvider.getUser.uid);
                  },
                  child: const Text(
                    'Save',
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
          )
        ],
      ),
    );
  }

  void _addEvent(String name, String uid) async {
    
    
    
    final title = _titleController.text;
    final description = _descController.text;
    final meetingLink = _meetingController.text;
    // final startTime = _startTimeController.text;
    // final endTime = _endTimeController.text;
    
    try {

    if (title.isEmpty) {
      showSnackBar("Title can not be empty", this.context);
      return;
    }else if(description.isEmpty)
    {
      showSnackBar("Description can not be empty", this.context);
      return;
    }
    // }else if(startTime.isEmpty || endTime.isEmpty)
    // {
    //   showSnackBar("Time can not be empty", this.context);
    //   return;
    // }
    else if (meetingLink.isEmpty) {
      showSnackBar("Please provide meeting link", this.context);
      return;
    }

    String res = await FirestoreMethods().uploadEvent(
      title, 
      description,
       meetingLink,
        uid,
         eventData['name'],
          _startTimeController.text,
       _endTimeController.text,
       _selectedDate
       );
    
    
    if(res == 'success'){
     setState(() {
       
     });
    showSnackBar("Posted!", context);
   
  }else{
    setState(() {
      
    });
    showSnackBar(res, this.context);
  }
}catch(err){
  setState(() {
    
  });
  showSnackBar(err.toString(), this.context);
}
}}
