import 'package:floor/floor.dart';
import 'event.dart';
import 'event_dao.dart';
import 'dart:async';
import 'package:sqflite/sqflite.dart' as sqflite;
import 'package:path/path.dart';

part 'eventdatabase.g.dart';

@Database(version: 1, entities: [Event])
abstract class EventDatabase extends FloorDatabase {
  EventDao get eventDao;
}