import 'package:floor/floor.dart';

@entity
class Event {
  static int ID = 1;

  @PrimaryKey()
  final int id;
  final String eventName;
  final String date;
  final String time;
  final String location;
  final String description;

  Event(this.id, this.eventName, this.date, this.time, this.location, this.description)
  {
    if(this.id == ID) {
      ID = (this.id+1);
    }
  }
}