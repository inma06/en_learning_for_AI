import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage {
  static const String _tokenKey = 'auth_token';
  static const String _userIdKey = 'user_id';
  static const String _userNameKey = 'user_name';
  static const String _userEmailKey = 'user_email';

  final SharedPreferences _prefs;
  final Box _box;

  LocalStorage(this._prefs, this._box);

  // Token 관련 메서드
  Future<void> saveToken(String token) async {
    await _prefs.setString(_tokenKey, token);
  }

  String? getToken() {
    return _prefs.getString(_tokenKey);
  }

  Future<void> removeToken() async {
    await _prefs.remove(_tokenKey);
  }

  // 사용자 정보 관련 메서드
  Future<void> saveUserInfo({
    required String userId,
    required String userName,
    required String userEmail,
  }) async {
    await _box.put(_userIdKey, userId);
    await _box.put(_userNameKey, userName);
    await _box.put(_userEmailKey, userEmail);
  }

  Map<String, String?> getUserInfo() {
    return {
      'userId': _box.get(_userIdKey) as String?,
      'userName': _box.get(_userNameKey) as String?,
      'userEmail': _box.get(_userEmailKey) as String?,
    };
  }

  Future<void> removeUserInfo() async {
    await _box.delete(_userIdKey);
    await _box.delete(_userNameKey);
    await _box.delete(_userEmailKey);
  }

  // 로그아웃
  Future<void> logout() async {
    await removeToken();
    await removeUserInfo();
  }
}
