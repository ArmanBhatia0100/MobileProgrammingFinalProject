import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/eventPlanner_localizations.dart';
import 'EventPlannerForm.dart';
import 'event.dart';
import 'event_dao.dart';
import 'eventdatabase.dart';

class EventPlannerHome extends StatefulWidget {
  final EventDatabase eventdatabase;
  final void Function(Locale) onLocaleChange;

  const EventPlannerHome({
    super.key,
    required this.eventdatabase,
    required this.onLocaleChange,
  });

  @override
  State<EventPlannerHome> createState() => _EventPlannerHomeState();
}

class _EventPlannerHomeState extends State<EventPlannerHome> {
  late EventDao eventDao;
  List<Event> events = [];
  Event? selectedEvent;

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
    selectedEvent = null;
  }

  void _editEvent(Event event) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EventPlannerForm(
          eventdatabase: widget.eventdatabase,
          event: event,
        ),
      ),
    ).then((_) => _loadEvents());
  }

  void _changeLanguage(Locale locale) {
    widget.onLocaleChange(locale);
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text(localizations.eventPlanner),
        actions: [
          IconButton(
            icon: Icon(Icons.info),
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text(localizations.instructionsTitle),
                    content: Text(localizations.instructions),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: Text('OK'),
                      ),
                    ],
                  );
                },
              );
            },
          ),
          PopupMenuButton<Locale>(
            onSelected: _changeLanguage,
            itemBuilder: (BuildContext context) => <PopupMenuEntry<Locale>>[
              const PopupMenuItem<Locale>(
                value: Locale('en'),
                child: Text('English'),
              ),
              const PopupMenuItem<Locale>(
                value: Locale('fr'),
                child: Text('Français'),
              ),
            ],
            icon: Icon(Icons.language),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EventPlannerForm(
                      eventdatabase: widget.eventdatabase,
                    ),
                  ),
                );
                if (result != null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(result.toString())),
                  );
                  _loadEvents();
                }
              },
              child: Text(localizations.addEvent),
            ),
          ),
        ],
      ),
      body: reactiveLayout(),
    );
  }

  Widget reactiveLayout() {
    var size = MediaQuery.of(context).size;
    var height = size.height;
    var width = size.width;

    if ((width > height) && (width > 720)) {
      return Row(children: [
        Expanded(flex: 1, child: ListPage()),
        Expanded(flex: 2, child: DetailsPage()),
      ]);
    } else {
      return selectedEvent == null ? ListPage() : DetailsPage();
    }
  }

  Widget ListPage() {
    final localizations = AppLocalizations.of(context)!;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: events.isEmpty
                ? Text(localizations.noEvents)
                : ListView.builder(
              itemCount: events.length,
              itemBuilder: (context, rowNum) {
                final event = events[rowNum];
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedEvent = event;
                    });
                  },
                  child: Card(
                    margin: EdgeInsets.all(10),
                    child: ListTile(
                      title: Text(
                        event.eventName,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(event.description),
                      trailing: Icon(Icons.arrow_forward),
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

  Widget DetailsPage() {
    final localizations = AppLocalizations.of(context)!;

    if (selectedEvent == null) {
      return Center(
        child: Text(localizations.selectEvent),
      );
    } else {
      return Center(
        child: SingleChildScrollView(
          child: Card(
            margin: EdgeInsets.all(10),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${selectedEvent!.eventName}",
                    style: TextStyle(fontSize: 30),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "${localizations.description} ${selectedEvent!.description}",
                    style: TextStyle(fontSize: 20),
                  ),
                  SizedBox(height: 10),
                  Text("${localizations.date} ${selectedEvent!.date}", style: TextStyle(fontSize: 20)),
                  Text("${localizations.time} ${selectedEvent!.time}", style: TextStyle(fontSize: 20)),
                  Text("${localizations.location} ${selectedEvent!.location}", style: TextStyle(fontSize: 20)),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () => _editEvent(selectedEvent!),
                        child: Text(localizations.editEvent),
                      ),
                      SizedBox(width: 10),
                      ElevatedButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) => AlertDialog(
                              title: Text(localizations.removeEvent),
                              content: Text(localizations.areYouSureYouWantToDelete),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () {
                                    _deleteEvent(selectedEvent!.id);
                                    Navigator.of(context).pop();
                                  },
                                  child: Text(localizations.yes),
                                ),
                                TextButton(
                                  onPressed: () => Navigator.of(context).pop(),
                                  child: Text(localizations.no),
                                ),
                              ],
                            ),
                          );
                        },
                        child: Text(localizations.removeEvent),
                      ),
                    ],
                  ),
                  TextButton(
                    child: Text(localizations.close),
                    onPressed: () {
                      setState(() {
                        selectedEvent = null;
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }
  }
}