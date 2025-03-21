import 'package:floor/floor.dart';

@entity
class Event {
  @primaryKey
  int id;
  static int ID = 1;
  String title;
  String description;
  String number_of_attendees;


  Event(int this.id, String this.title, String this.description, String this.number_of_attendees){
    if(id >= ID) {
      ID = id + 1;
    }
  }
}
