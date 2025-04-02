import 'package:encrypted_shared_preferences/encrypted_shared_preferences.dart';

/// class for storing the data and retrieving data using encrypted shared reference
class Repository {
  final EncryptedSharedPreferences prefs = EncryptedSharedPreferences();

  /// saving customer information
  Future<void> saveProfileData(
      String firstName, String lastName, String address, String birthday) async {
    await prefs.setString('first_name', firstName);
    await prefs.setString('last_name', lastName);
    await prefs.setString('address', address);
    await prefs.setString('birthday', birthday);
  }

  /// loads last saved customer profile
  Future<Map<String, String?>> loadProfileData() async {
    return {
      'first_name': await prefs.getString('first_name'),
      'last_name': await prefs.getString('last_name'),
      'address': await prefs.getString('address'),
      'birthday': await prefs.getString('birthday'),
    };
  }
}
