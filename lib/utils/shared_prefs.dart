import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefs {
  // Key yang digunakan agar konsisten di seluruh aplikasi
  static const String _keyUsername = 'username';
  static const String _keyIsLoggedIn = 'isLoggedIn';

  // 1. Fungsi untuk menyimpan data sesi login (Dipakai di LoginScreen)
  static Future<void> saveLoginSession(String username) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyUsername, username);
    await prefs.setBool(_keyIsLoggedIn, true);
  }

  // 2. Fungsi untuk mengambil username yang sedang login (Dipakai di HomeScreen)
  static Future<String> getUsername() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyUsername) ?? 'User';
  }

  // 3. Fungsi untuk mengecek status login user (Dipakai di main.dart)
  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyIsLoggedIn) ?? false;
  }

  // 4. Fungsi untuk menghapus sesi / logout (Dipakai di HomeScreen)
  static Future<void> clearSession() async {
    final prefs = await SharedPreferences.getInstance();
    // Menghapus key spesifik agar tidak mengganggu data penyimpanan lain jika ada
    await prefs.remove(_keyUsername);
    await prefs.remove(_keyIsLoggedIn);
  }
}