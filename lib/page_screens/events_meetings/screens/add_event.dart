// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:college_gram_app/resources/firestore_methods.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:college_gram_app/providers/user_provider.dart';
import 'package:college_gram_app/utils/utils.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class AddEvent extends StatefulWidget {
  final DateTime firstDate;
  final DateTime lastDate;
  final DateTime? selectedDate;
  const AddEvent(
      {Key? key,
      required this.firstDate,
      required this.lastDate,
      this.selectedDate})
      : super(key: key);

  @override
  State<AddEvent> createState() => _AddEventState();
}

class _AddEventState extends State<AddEvent> {
  late DateTime _selectedDate;


  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  final _meetingController = TextEditingController();
   final _startTimeController = TextEditingController();
  final _endTimeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.selectedDate ?? DateTime.now();
   
  }

  @override
  Widget build(BuildContext context) {
    final UserProvider userProvider = Provider.of<UserProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Event'),
        leading: const BackButton(
          color: Colors.black, // <-- SEE HERE
        ),
        titleTextStyle: const TextStyle(
            color: Colors.black, fontSize: 25.0, fontWeight: FontWeight.w600),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          FormBuilderTextField(
            validator: FormBuilderValidators.required(),
            name: "title",
            decoration: const InputDecoration(
                hintText: "Event Title",
                border: InputBorder.none,
                contentPadding: EdgeInsets.only(left: 48.0)),
            controller: _titleController,
          ),
          const Divider(),
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
          Divider(),
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
            initialValue: _selectedDate,
            initialDate: DateTime.now(),
            fieldHintText: "Add Date",
            initialDatePickerMode: DatePickerMode.day,
            inputType: InputType.date,
            format: DateFormat('EEEE, dd MMMM, yyyy'),
            decoration: InputDecoration(
              border: InputBorder.none,
              prefixIcon: Icon(Icons.calendar_month),
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
    final startTime = _startTimeController.text;
    final endTime = _endTimeController.text;
    
    try {

    if (title.isEmpty) {
      showSnackBar("Title can not be empty", this.context);
      return;
    }else if(description.isEmpty)
    {
      showSnackBar("Description can not be empty", this.context);
      return;
    }else if(startTime.isEmpty || endTime.isEmpty)
    {
      showSnackBar("Time can not be empty", this.context);
      return;
    }
    else if (meetingLink.isEmpty) {
      showSnackBar("Please provide meeting link", this.context);
      return;
    }

    String res = await FirestoreMethods().uploadEvent(title, description, meetingLink, uid, name, startTime, endTime , _selectedDate);
  
    
    if(res == 'success'){
     setState(() {
       
     });
    showSnackBar("Posted!", context);
    // if (mounted) {
    //   Navigator.pop<bool>(context, true);
    // }
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
}
}