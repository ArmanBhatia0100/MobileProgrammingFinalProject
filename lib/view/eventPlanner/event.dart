import 'package:floor/floor.dart';

@entity
class Event {
  @PrimaryKey(autoGenerate: true)
  final int? id;
  final String title;
  final String description;
  final String number_of_attendees;

  Event(this.title, this.description, this.number_of_attendees, {this.id});
}