import 'package:floor/floor.dart';
import 'vehicle.dart';

@dao
abstract class VehicleDao {
  @Query('SELECT * FROM MaintenanceRecord')
  Future<List<MaintenanceRecord>> findAll();

  @insert
  Future<void> insertRecord(MaintenanceRecord record);

  @delete
  Future<void> deleteRecord(MaintenanceRecord record);

  @update
  Future<void> updateRecord(MaintenanceRecord record);
}
