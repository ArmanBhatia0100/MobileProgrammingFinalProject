import 'package:floor/floor.dart';


///Entity class for the Event table
@entity
class Event {
  static int ID = 1;

  ///The unique identifier for the event
  @PrimaryKey()
  final int id;
  final String eventName;
  final String date;
  final String time;
  final String location;
  final String description;

  ///The Constructor for the Event class
  Event(this.id, this.eventName, this.date, this.time, this.location, this.description)
  {
    if(this.id == ID) {
      ID = (this.id+1);
    }
  }
}