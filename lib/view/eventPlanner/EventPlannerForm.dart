import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'event.dart';
import 'event_dao.dart';
import 'eventdatabase.dart';

class EventPlannerForm extends StatefulWidget {
  final EventDatabase eventdatabase;
  final Event? event;

  EventPlannerForm({super.key, required this.eventdatabase, this.event});

  @override
  State<EventPlannerForm> createState() => _EventPlannerFormState();
}

class _EventPlannerFormState extends State<EventPlannerForm> {
  late EventDao eventDao;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController eventTitleController = TextEditingController();
  final TextEditingController eventDescriptionController = TextEditingController();
  final TextEditingController eventAttendeesController = TextEditingController();

  @override
  void initState() {
    super.initState();
    eventDao = widget.eventdatabase.eventDao;
    if (widget.event != null) {
      eventTitleController.text = widget.event!.title;
      eventDescriptionController.text = widget.event!.description;
      eventAttendeesController.text = widget.event!.number_of_attendees;
    }
  }

  Future<void> _saveEvent() async {
    if (_formKey.currentState!.validate()) {
      final newEvent = Event(
        eventTitleController.text,
        eventDescriptionController.text,
        eventAttendeesController.text,
        id: widget.event?.id ?? 0, // Ensure the id is correctly passed
      );

      if (widget.event == null) {
        await eventDao.insertEvent(newEvent);
      } else {
        await eventDao.updateEvent(newEvent);
      }

      Navigator.pushNamedAndRemoveUntil(context, "/eventplanner", (route) => false); // This will take the user back to the EventPlannerHome page
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text(widget.event == null ? "Add Event" : "Edit Event"),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(onPressed: _saveEvent, child: Text(widget.event == null ? "Add Event" : "Save Changes")),
          )
        ],
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(30),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Title(
                  color: Colors.black,
                  child: Text(
                    widget.event == null ? "Add Event" : "Edit Event",
                    style: TextStyle(fontSize: 30),
                  ),
                ),
                TextFormField(
                  controller: eventTitleController,
                  decoration: const InputDecoration(
                    border: UnderlineInputBorder(),
                    labelText: 'Event Name',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter an event name';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: eventDescriptionController,
                  decoration: const InputDecoration(
                    border: UnderlineInputBorder(),
                    labelText: 'Event Description',
                  ),
                  maxLines: null,
                  keyboardType: TextInputType.multiline,
                ),
                TextFormField(
                  controller: eventAttendeesController,
                  decoration: const InputDecoration(
                    border: UnderlineInputBorder(),
                    labelText: 'Number of attendees',
                  ),
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the number of attendees';
                    }
                    if (int.tryParse(value) == null) {
                      return 'Please enter a valid number';
                    }
                    return null;
                  },
                ),
                ElevatedButton(onPressed: _saveEvent, child: Text(widget.event == null ? "Add" : "Save"))
              ],
            ),
          ),
        ),
      ),
    );
  }
}