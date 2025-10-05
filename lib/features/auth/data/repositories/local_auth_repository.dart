import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:marketplace2/features/auth/data/models/user_model.dart';

class LocalAuthRepository {
  static const String _usersDbKey = 'users_db';
  static const String _loginStatusKey = 'is_logged_in';
  static const String _currentUserKey = 'current_user';
  List<UserModel> _users = [];

  LocalAuthRepository() {
    _loadUsers();
  }

  Future<void> _loadUsers() async {
    final prefs = await SharedPreferences.getInstance();
    final String? usersString = prefs.getString(_usersDbKey);

    if (usersString != null) {
      final List<dynamic> userListJson = jsonDecode(usersString);
      _users = userListJson.map((json) => UserModel.fromJson(json)).toList();
    }
  }

  Future<void> _saveUsers() async {
    final prefs = await SharedPreferences.getInstance();
    final String usersString =
        jsonEncode(_users.map((user) => user.toJson()).toList());
    await prefs.setString(_usersDbKey, usersString);
  }

  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_loginStatusKey) ?? false;
  }

  Future<UserModel?> getCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    final String? userString = prefs.getString(_currentUserKey);
    if (userString != null) {
      return UserModel.fromJson(jsonDecode(userString));
    }
    return null;
  }

  Future<void> login({
    required String email,
    required String password,
  }) async {
    await _loadUsers();
    await Future.delayed(const Duration(seconds: 1));
    try {
      final user = _users.firstWhere(
          (user) => user.email == email && user.password == password);

      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_loginStatusKey, true);
      await prefs.setString(_currentUserKey, jsonEncode(user.toJson()));

    } catch (e) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_loginStatusKey, false);
      await prefs.remove(_currentUserKey);
      throw Exception('Email atau password salah.');
    }
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_loginStatusKey, false);
    await prefs.remove(_currentUserKey);
    await Future.delayed(const Duration(milliseconds: 500));
  }

  Future<void> register({
    required String fullName,
    required String email,
    required String password,
  }) async {
    await _loadUsers();
    await Future.delayed(const Duration(seconds: 1));

    if (_users.any((user) => user.email == email)) {
      throw Exception('Email sudah terdaftar.');
    }

    final newUser = UserModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      fullName: fullName,
      email: email,
      password: password,
    );
    _users.add(newUser);
    await _saveUsers();
  }

  Future<void> resetPassword({required String email}) async {
    await _loadUsers();
    if (!_users.any((user) => user.email == email)) {
      throw Exception('Email tidak ditemukan.');
    }
  }
}