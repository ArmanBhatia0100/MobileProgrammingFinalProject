import 'package:floor/floor.dart';
import 'vehicle.dart';

@dao
abstract class VehicleDao {
  // Week 8/Final Project: Insert new maintenance record
  @insert
  Future<void> insertRecord(MaintenanceRecord record);

  // Week 8/Final Project: Retrieve all maintenance records
  @Query('SELECT * FROM MaintenanceRecord')
  Future<List<MaintenanceRecord>> getAllRecords();

  // Week 9/Final Project: Delete a maintenance record
  @delete
  Future<void> deleteRecord(MaintenanceRecord record);

  // Final Project: Update an existing record
  @update
  Future<void> updateRecord(MaintenanceRecord record);
}
