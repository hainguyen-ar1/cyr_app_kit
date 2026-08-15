import 'package:shared_preferences/shared_preferences.dart';

class TokenStorage {
  static const _keyAccess = 'access_token';
  static const _keyRefresh = 'refresh_token';

  String? _accessToken;
  String? _refreshToken;

  String? get accessToken => _accessToken;
  String? get refreshToken => _refreshToken;
  bool get hasToken => _accessToken != null && _accessToken!.isNotEmpty;

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    _accessToken = prefs.getString(_keyAccess);
    _refreshToken = prefs.getString(_keyRefresh);
  }

  Future<void> save({
    required String accessToken,
    required String refreshToken,
  }) async {
    _accessToken = accessToken;
    _refreshToken = refreshToken;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyAccess, accessToken);
    await prefs.setString(_keyRefresh, refreshToken);
  }

  Future<void> clear() async {
    _accessToken = null;
    _refreshToken = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyAccess);
    await prefs.remove(_keyRefresh);
  }
}
