import 'package:floor/floor.dart';
import 'dart:async';

import 'vehicle.dart';
import 'vehicle_dao.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

// Week 8/Final Project: Define the database
part 'vehicle_database.g.dart'; // Will be generated using build_runner

@Database(version: 1, entities: [MaintenanceRecord])
abstract class VehicleDatabase extends FloorDatabase {
  VehicleDao get vehicleDao;
}
