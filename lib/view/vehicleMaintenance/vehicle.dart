// Represents a record for vehicle maintenance

import 'package:floor/floor.dart';

@entity
class MaintenanceRecord {
  @PrimaryKey(autoGenerate: true)
  final int? id;

  final String vehicleName;
  final String vehicleType;
  final String serviceType;
  final String serviceDate;
  final int mileage;
  final double cost;

  MaintenanceRecord({
    this.id,
    required this.vehicleName,
    required this.vehicleType,
    required this.serviceType,
    required this.serviceDate,
    required this.mileage,
    required this.cost,
  });
}