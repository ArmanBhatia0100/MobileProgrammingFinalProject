import 'package:flutter/material.dart';

import 'event.dart';
import 'event_dao.dart';
import 'eventdatabase.dart';

class EventPlannerForm extends StatefulWidget {
  final EventDatabase eventdatabase;
  EventPlannerForm({super.key, required this.eventdatabase});

  @override
  State<EventPlannerForm> createState() => _EventPlannerFormState();
}

class _EventPlannerFormState extends State<EventPlannerForm> {
  late EventDao eventDao;
  final TextEditingController eventTitleController = TextEditingController();
  final TextEditingController eventDescriptionController = TextEditingController();
  final TextEditingController eventAttendeesController = TextEditingController();

  Future<void> _addEvent() async {
    if (eventTitleController.text.isEmpty && eventDescriptionController.text.isEmpty && eventAttendeesController .text.isEmpty ) return;
    final newEvent = Event(Event.ID++, eventTitleController.text, eventDescriptionController.text, eventAttendeesController.text);
    await eventDao.insertEvent(newEvent);
    Navigator.pushNamed(context, "/eventplanner");
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue,
          title: Text("Event Planner"),
          actions: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(onPressed: () {}, child: Text("Add Event")),
            )
          ],
        ),
        body: Center(
            child: Padding(
              padding: EdgeInsets.all(30),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Title(
                      color: Colors.black,
                      child: Text(
                        "Add Event",
                        style: TextStyle(fontSize: 30),
                      )),
                  SizedBox(
                      width: 500,
                      child: SizedBox(
                        width: 100,
                        child: TextFormField(
                          decoration: const InputDecoration(
                            border: UnderlineInputBorder(),
                            labelText: 'Event Name',
                          ),
                        ),
                      )
                  ),
                  SizedBox(
                    width: 500,
                    height: 400,
                    child: SizedBox(
                      width: 100,
                      child: TextFormField(
                        decoration: const InputDecoration(
                          border: UnderlineInputBorder(),
                          labelText: 'Event Description',
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 500,
                    height: 400,
                    child: SizedBox(
                      width: 100,
                      child: TextFormField(
                        decoration: const InputDecoration(
                          border: UnderlineInputBorder(),
                          labelText: 'Number of attendees',
                        ),
                      ),
                    ),
                  ),
                  ElevatedButton(onPressed: _addEvent, child: Text("Add"))

                ],
              ),
            )));
  }
}
