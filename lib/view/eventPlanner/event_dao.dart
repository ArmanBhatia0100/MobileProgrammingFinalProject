import 'package:floor/floor.dart';
import 'event.dart';

@dao
abstract class EventDao {
  @insert
  Future<void> insertEvent(Event event);

  @update
  Future<void> updateEvent(Event event);

  @delete
  Future<void> deleteEvent(Event event);

  @Query('SELECT * FROM Event WHERE id = :id')
  Future<Event?> findEventById(int id);

  @Query('SELECT * FROM Event')
  Future<List<Event>> getAllEvents(); // Added method

  @Query('DELETE FROM Event WHERE id = :id')
  Future<void> deleteEventById(int id); // Added method
}