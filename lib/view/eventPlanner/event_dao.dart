import 'package:floor/floor.dart';
import 'event.dart';


@dao
abstract class EventDao {
  @Query('SELECT * FROM Event')
  Future<List<Event>> getAllEvents();

  @insert
  Future<void> insertEvent(Event event);

  @Query('DELETE FROM Event WHERE id = :id')
  Future<void> deleteEvent(int id);
}