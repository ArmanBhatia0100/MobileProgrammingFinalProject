import 'package:flutter/material.dart';
import 'EventPlannerForm.dart';
import 'event.dart';
import 'event_dao.dart';
import 'eventdatabase.dart';

class EventPlannerHome extends StatefulWidget {
  final EventDatabase eventdatabase;
  EventPlannerHome({super.key, required this.eventdatabase});

  @override
  State<EventPlannerHome> createState() => _EventPlannerHomeState();
}

class _EventPlannerHomeState extends State<EventPlannerHome> {
  late EventDao eventDao;
  List<Event> events = [];

  @override
  void initState() {
    super.initState();
    eventDao = widget.eventdatabase.eventDao;
    _loadEvents();
  }

  Future<void> _loadEvents() async {
    final allEvents = await eventDao.getAllEvents();
    setState(() {
      events = allEvents;
    });
  }

  Future<void> _deleteEvent(int? id) async {
    if (id != null) {
      await eventDao.deleteEventById(id);
      _loadEvents();
    }
  }

  void _editEvent(Event event) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EventPlannerForm(eventdatabase: widget.eventdatabase, event: event),
      ),
    ).then((_) => _loadEvents());
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
            child: ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, "/eventplannerform");
                },
                child: Text("Add Event")),
          )
        ],
      ),
      body: ListPage(),
    );
  }

  Widget ListPage() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: events.isEmpty
                ? Text("There are no items in the list")
                : ListView.builder(
              itemCount: events.length,
              itemBuilder: (context, rowNum) {
                final event = events[rowNum];
                return Card(
                  margin: EdgeInsets.all(10),
                  child: ListTile(
                    title: Text(event.title, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          event.description,
                          maxLines: null,
                          overflow: TextOverflow.visible,
                        ),
                        Text("Number of attendees: ${event.number_of_attendees}"),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit, color: Colors.blue),
                          onPressed: () => _editEvent(event),
                        ),
                        IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) => AlertDialog(
                                title: const Text('Would you like to remove this item?'),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: () {
                                      _deleteEvent(event.id);
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text('Yes'),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text('No'),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}