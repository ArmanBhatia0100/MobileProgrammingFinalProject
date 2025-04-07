import 'package:encrypted_shared_preferences/encrypted_shared_preferences.dart';
/// This class is responsible for saving and loading vehicle maintenance records
class VehicleRepository {
  final _prefs = EncryptedSharedPreferences();

  static const String keyName = 'vehicle_name';
  static const String keyType = 'vehicle_type';
  static const String keyServiceType = 'service_type';
  static const String keyDate = 'service_date';
  static const String keyMileage = 'vehicle_mileage';
  static const String keyCost = 'vehicle_cost';
/// This method saves the last vehicle maintenance record
  Future<void> saveLastRecord({
    required String name,
    required String type,
    required String serviceType,
    required String date,
    required String mileage,
    required String cost,
  })
  /// Saves the last vehicle maintenance record to encrypted shared preferences
  async {
    await _prefs.setString(keyName, name);
    await _prefs.setString(keyType, type);
    await _prefs.setString(keyServiceType, serviceType);
    await _prefs.setString(keyDate, date);
    await _prefs.setString(keyMileage, mileage);
    await _prefs.setString(keyCost, cost);
  }
/// This method loads the last vehicle maintenance record
  Future<Map<String, String>> loadLastRecord() async {
    final name = await _prefs.getString(keyName) ?? '';
    final type = await _prefs.getString(keyType) ?? '';
    final serviceType = await _prefs.getString(keyServiceType) ?? '';
    final date = await _prefs.getString(keyDate) ?? '';
    final mileage = await _prefs.getString(keyMileage) ?? '';
    final cost = await _prefs.getString(keyCost) ?? '';

    return {
      keyName: name,
      keyType: type,
      keyServiceType: serviceType,
      keyDate: date,
      keyMileage: mileage,
      keyCost: cost,
    };
  }
}
