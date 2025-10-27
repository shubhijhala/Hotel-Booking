import 'dart:convert';

/// Model class representing a User
/// Contains user information from Google Sign-In
class UserModel {
  final String id;
  final String displayName;
  final String email;
  final String? photoUrl;

  UserModel({
    required this.id,
    required this.displayName,
    required this.email,
    this.photoUrl,
  });

  /// Create UserModel from JSON
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      displayName: json['displayName'] as String,
      email: json['email'] as String,
      photoUrl: json['photoUrl'] as String?,
    );
  }

  /// Convert UserModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'displayName': displayName,
      'email': email,
      'photoUrl': photoUrl,
    };
  }

  /// Convert UserModel to JSON string
  String toJsonString() {
    return jsonEncode(toJson());
  }

  /// Create UserModel from JSON string
  factory UserModel.fromJsonString(String jsonString) {
    return UserModel.fromJson(jsonDecode(jsonString) as Map<String, dynamic>);
  }

  /// Get user initials for avatar fallback
  String get initials {
    final names = displayName.split(' ');
    if (names.length >= 2) {
      return '${names[0][0]}${names[1][0]}'.toUpperCase();
    }
    return displayName.isNotEmpty ? displayName[0].toUpperCase() : 'U';
  }
}
