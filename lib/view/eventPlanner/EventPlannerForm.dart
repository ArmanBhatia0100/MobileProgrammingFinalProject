import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/localizations.dart';
import 'EventPlannerHome.dart';
import 'event.dart';
import 'event_dao.dart';
import 'eventdatabase.dart';
import 'package:encrypted_shared_preferences/encrypted_shared_preferences.dart';

class EventPlannerForm extends StatefulWidget {
  final EventDatabase eventdatabase;
  final Event? event;

  const EventPlannerForm({super.key, required this.eventdatabase, this.event});

  @override
  State<EventPlannerForm> createState() => _EventPlannerFormState();
}

class _EventPlannerFormState extends State<EventPlannerForm> {
  late EventDao eventDao;
  final _formKey = GlobalKey<FormState>();

  final TextEditingController eventNameController = TextEditingController();
  final TextEditingController eventDescriptionController = TextEditingController();
  final TextEditingController eventDateController = TextEditingController();
  final TextEditingController eventTimeController = TextEditingController();
  final TextEditingController eventLocationController = TextEditingController();

  EncryptedSharedPreferences prefs = EncryptedSharedPreferences();
  @override
  void initState() {
    super.initState();
    eventDao = widget.eventdatabase.eventDao;

    if (widget.event != null) {
      eventNameController.text = widget.event!.eventName;
      eventDescriptionController.text = widget.event!.description;
      eventDateController.text = widget.event!.date;
      eventTimeController.text = widget.event!.time;
      eventLocationController.text = widget.event!.location;
    }else{
      loadPrefs();
    }
  }

  Future<void> loadPrefs() async {
    String? eventName = await prefs.getString("eventName");
    String? eventDescription = await prefs.getString("eventDescription");
    String? eventLocation = await prefs.getString("eventLocation");
    String? eventDate = await prefs.getString("eventDate");
    String? eventTime = await prefs.getString("eventTime");

    setState(() {
      eventNameController.text = eventName ?? '';
      eventDescriptionController.text = eventDescription ?? '';
      eventLocationController.text = eventLocation ?? '';
      eventDateController.text = eventDate ?? '';
      eventTimeController.text = eventTime ?? '';
    });
  }

  Future<void> savePrefs() async {{
    await prefs.setString("eventName", eventNameController.text);
    await prefs.setString("eventDescription", eventDescriptionController.text);
    await prefs.setString("eventLocation", eventLocationController.text);
    await prefs.setString("eventDate", eventDateController.text);
    await prefs.setString("eventTime", eventTimeController.text);
  }}

  @override
  void dispose() {
    savePrefs();
    eventNameController.dispose();
    eventDescriptionController.dispose();
    eventDateController.dispose();
    eventTimeController.dispose();
    eventLocationController.dispose();
    super.dispose();
  }

  Future<void> cleanPrefs() async {
    await prefs.clear();
    setState(() {
      eventNameController.clear();
      eventDescriptionController.clear();
      eventLocationController.clear();
      eventDateController.clear();
      eventTimeController.clear();
    });
  }

  Future<void> _saveEvent() async {
    if (_formKey.currentState!.validate()) {
      final newEvent = Event(
        widget.event?.id ?? Event.ID++,
        eventNameController.text,
        eventDateController.text,
        eventTimeController.text,
        eventLocationController.text,
        eventDescriptionController.text,
      );

      if (widget.event == null) {
        await eventDao.insertEvent(newEvent);
      } else {
        await eventDao.updateEvent(newEvent);
      }

      await cleanPrefs();

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => EventPlannerHome(
            eventdatabase: widget.eventdatabase,
            onLocaleChange: (Locale locale) {},
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text(widget.event == null
            ? localizations.addEvent
            : localizations.editEvent),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: _saveEvent,
              child: Text(widget.event == null
                  ? localizations.addEvent
                  : localizations.saveChanges),
            ),
          )
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(30),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    widget.event == null
                        ? localizations.addEvent
                        : localizations.editEvent,
                    style: const TextStyle(fontSize: 30),
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: eventNameController,
                    decoration: InputDecoration(
                      border: const UnderlineInputBorder(),
                      labelText: localizations.eventName,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return localizations.enterEventName;
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: eventDateController,
                    decoration: InputDecoration(
                      border: const UnderlineInputBorder(),
                      labelText: localizations.date,
                    ),
                    onTap: () async {
                      FocusScope.of(context).unfocus();
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2100),
                      );
                      if (picked != null) {
                        eventDateController.text =
                        "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
                      }
                    },
                    readOnly: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return localizations.enterDate;
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: eventTimeController,
                    decoration: InputDecoration(
                      border: const UnderlineInputBorder(),
                      labelText: localizations.time,
                    ),
                    onTap: () async {
                      FocusScope.of(context).unfocus();
                      final picked = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.now(),
                      );
                      if (picked != null) {
                        eventTimeController.text = picked.format(context);
                      }
                    },
                    readOnly: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return localizations.enterTime;
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: eventLocationController,
                    decoration: InputDecoration(
                      border: const UnderlineInputBorder(),
                      labelText: localizations.location,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return localizations.enterLocation;
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: eventDescriptionController,
                    decoration: InputDecoration(
                      border: const UnderlineInputBorder(),
                      labelText: localizations.eventDescription,
                    ),
                    maxLines: null,
                    keyboardType: TextInputType.multiline,
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _saveEvent,
                    child: Text(widget.event == null
                        ? localizations.add
                        : localizations.save),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
