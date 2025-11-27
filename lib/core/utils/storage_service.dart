import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/user_profile.dart';

class StorageService {
  static final StorageService instance = StorageService._init();
  final _storage = const FlutterSecureStorage();

  static const String _userProfileKey = 'user_profile';

  StorageService._init();

  Future<void> saveUserProfile(UserProfile profile) async {
    final jsonString = jsonEncode(profile.toJson());
    await _storage.write(key: _userProfileKey, value: jsonString);
  }

  Future<UserProfile?> getUserProfile() async {
    final jsonString = await _storage.read(key: _userProfileKey);
    if (jsonString == null) return null;

    final json = jsonDecode(jsonString) as Map<String, dynamic>;
    return UserProfile.fromJson(json);
  }

  Future<bool> hasUserProfile() async {
    return await _storage.containsKey(key: _userProfileKey);
  }

  Future<void> deleteUserProfile() async {
    await _storage.delete(key: _userProfileKey);
  }
}
