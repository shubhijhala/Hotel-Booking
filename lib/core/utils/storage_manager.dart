import 'package:shared_preferences/shared_preferences.dart';
import '../../data/models/user_model.dart';

/// Manager class for handling local storage operations
/// Uses SharedPreferences for persistent data storage
class StorageManager {
  static const String _keyUser = 'user_data';
  static const String _keyIsLoggedIn = 'is_logged_in';
  static const String _keyVisitorToken = 'visitor_token';

  late final SharedPreferences _prefs;

  /// Initialize SharedPreferences instance
  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  /// Save user data to local storage
  Future<bool> saveUser(UserModel user) async {
    try {
      final jsonString = user.toJsonString();
      await _prefs.setString(_keyUser, jsonString);
      await _prefs.setBool(_keyIsLoggedIn, true);
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Get user data from local storage
  UserModel? getUser() {
    try {
      final jsonString = _prefs.getString(_keyUser);
      if (jsonString != null) {
        return UserModel.fromJsonString(jsonString);
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  /// Check if user is logged in
  bool isLoggedIn() {
    return _prefs.getBool(_keyIsLoggedIn) ?? false;
  }

  /// Clear user data from local storage (logout)
  Future<bool> clearUser() async {
    try {
      await _prefs.remove(_keyUser);
      await _prefs.setBool(_keyIsLoggedIn, false);
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Clear all stored data except visitor token
  Future<bool> clearAll() async {
    try {
      // Preserve visitor token before clearing
      final visitorToken = _prefs.getString(_keyVisitorToken);

      // Clear all data
      await _prefs.clear();

      // Restore visitor token if it existed
      if (visitorToken != null) {
        await _prefs.setString(_keyVisitorToken, visitorToken);
      }

      return true;
    } catch (e) {
      return false;
    }
  }

  /// Get user display name
  String? getUserDisplayName() {
    return getUser()?.displayName;
  }

  /// Get user email
  String? getUserEmail() {
    return getUser()?.email;
  }

  /// Get user photo URL
  String? getUserPhotoUrl() {
    return getUser()?.photoUrl;
  }

  /// Get user initials
  String getUserInitials() {
    return getUser()?.initials ?? 'U';
  }

  /// Save visitor token
  Future<bool> saveVisitorToken(String token) async {
    try {
      await _prefs.setString(_keyVisitorToken, token);
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Get visitor token
  String? getVisitorToken() {
    return _prefs.getString(_keyVisitorToken);
  }

  /// Check if visitor token exists
  bool hasVisitorToken() {
    return _prefs.getString(_keyVisitorToken) != null;
  }
}
