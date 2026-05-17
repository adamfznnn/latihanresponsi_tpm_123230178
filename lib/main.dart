import 'package:flutter/material.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';
import 'utils/shared_prefs.dart';

void main() async {
  // Memastikan framework Flutter sudah terinisialisasi sebelum memanggil SharedPreferences
  WidgetsFlutterBinding.ensureInitialized();
  
  // Mengecek apakah user sudah login sebelumnya lewat Helper Class SharedPrefs
  bool loggedIn = await SharedPrefs.isLoggedIn();

  runApp(MyApp(isLoggedIn: loggedIn));
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;

  const MyApp({Key? key, required this.isLoggedIn}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SpaceFlight Portal',
      // Menghilangkan banner debug merah di pojok kanan atas
      debugShowCheckedModeBanner: false, 
      
      // Kustomisasi Tema Aplikasi (Gaya Minimalis Gelap sesuai mockup berkas praktikum)
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: false, // Menjaga konsistensi komponen Material 2 standar responsi
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF212121), // Background AppBar abu-abu gelap
          foregroundColor: Colors.white,       // Warna teks & ikon AppBar putih
          elevation: 4,
        ),
        scaffoldBackgroundColor: const Color(0xFFF5F5F5), // Background halaman abu terang
      ),
      
      // Jalur otomatis (Auto-routing) berdasarkan status SharedPreferences
      home: isLoggedIn ? const HomeScreen() : const LoginScreen(),
    );
  }
}