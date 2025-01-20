import '../../core/app_singletons/app_singletons.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesManager {
  static late SharedPreferences _preferences;

  // Private constructor to ensure that the class is a singleton
  SharedPreferencesManager._();

  // Initialize SharedPreferences
  static Future<void> initialize() async {
    _preferences = await SharedPreferences.getInstance();

    AppSingletons.storedInvoiceCurrency.value = SharedPreferencesManager.getValue('setDefaultCurrency_INV') ?? 'Rs';

  }

  // Get a value from SharedPreferences
  static dynamic getValue(String key) {
    return _preferences.get(key);
  }

  // Set a value in SharedPreferences
  static Future<void> setValue(String key, dynamic value) async {
    if (value is String) {
      await _preferences.setString(key, value);
    } else if (value is int) {
      await _preferences.setInt(key, value);
    } else if (value is double) {
      await _preferences.setDouble(key, value);
    } else if (value is bool) {
      await _preferences.setBool(key, value);
    } else if (value is List<String>) {
      await _preferences.setStringList(key, value);
    } else {
      throw Exception("Unsupported value type");
    }
  }

  // Remove a value from SharedPreferences
  static Future<void> removeValue(String key) async {
    await _preferences.remove(key);
  }

  // Clear all values from SharedPreferences
  static Future<void> clear() async {
    await _preferences.clear();
  }
}
