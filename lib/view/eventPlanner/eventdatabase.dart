import 'dart:async';
import 'package:floor/floor.dart';
import 'package:sqflite/sqflite.dart' as sqflite;
import 'event.dart';
import 'event_dao.dart';


part 'eventdatabase.g.dart';

@Database(version: 1, entities: [Event])
abstract class EventDatabase extends FloorDatabase {
  EventDao get eventDao;
}
