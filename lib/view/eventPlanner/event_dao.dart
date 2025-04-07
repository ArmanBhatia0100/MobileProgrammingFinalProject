import 'package:floor/floor.dart';
import 'event.dart';

/// Entity class for the Event table
@dao
abstract class EventDao {
  /// The unique identifier for the event
  @insert
  Future<void> insertEvent(Event event);

  /// The Constructor for the Event class
  @update
  Future<void> updateEvent(Event event);

  /// The Constructor for the Event class
  @delete
  Future<void> deleteEvent(Event event);

  /// The Constructor for the Event class
  @Query('SELECT * FROM Event WHERE id = :id')
  Future<Event?> findEventById(int id);

  /// The Constructor for the Event class
  @Query('SELECT * FROM Event')
  Future<List<Event>> getAllEvents(); // Added method

  /// The Constructor for the Event class
  @Query('DELETE FROM Event WHERE id = :id')
  Future<void> deleteEventById(int id); // Added method
}