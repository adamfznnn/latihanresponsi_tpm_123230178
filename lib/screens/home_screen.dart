import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'list_screen.dart'; // Import halaman list yang akan dibuat setelah ini
import 'login_screen.dart'; // Digunakan jika ingin kembali ke halaman login saat logout

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _username = "User";

  @override
  void initState() {
    super.initState();
    _loadUsername();
  }

  // Mengambil username dari SharedPreferences (Sesuai Ketentuan Soal)
  Future<void> _loadUsername() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      // Mengambil data string dengan key 'username' (sesuaikan dengan key saat register/login nanti)
      _username = prefs.getString('username') ?? "User";
    });
  }

  // Fungsi Logout untuk menghapus session SharedPreferences
  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear(); // Menghapus semua data sesi
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Hai, $_username!"), // AppBar menampilkan username (Sesuai Ketentuan Soal)
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _logout,
            tooltip: 'Logout',
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 10),
            
            // Menu 1: News
            _buildMenuCard(
              context,
              title: "News",
              description: "Get an overview of the latest SpaceFlight news, from various sources!. Easily link your users to the right websites.",
              icon: Icons.newspaper,
              color: Colors.blue.shade700,
              menuType: "articles", // Endpoint API untuk news adalah 'articles'
            ),
            const SizedBox(height: 16),
            
            // Menu 2: Blog
            _buildMenuCard(
              context,
              title: "Blog",
              description: "Blogs often provide a more detailed overview of launches and missions. A must-have for the serious spaceflight enthusiast.",
              icon: Icons.book,
              color: Colors.green.shade700,
              menuType: "blogs", // Endpoint API untuk blog adalah 'blogs'
            ),
            const SizedBox(height: 16),
            
            // Menu 3: Report
            _buildMenuCard(
              context,
              title: "Report",
              description: "Space stations and other missions often publish their data. With SNAPI, you can include it in your app.",
              icon: Icons.analytics,
              color: Colors.orange.shade700,
              menuType: "reports", // Endpoint API untuk report adalah 'reports'
            ),
          ],
        ),
      ),
    );
  }

  // Widget Reusable untuk membuat Card Menu agar kode lebih rapi
  Widget _buildMenuCard(
    BuildContext context, {
    required String title,
    required String description,
    required IconData icon,
    required Color color,
    required String menuType,
  }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () {
          // Mengarahkan ke halaman kedua (ListScreen) dengan melempar tipe menu
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ListScreen(menuType: menuType),
            ),
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                backgroundColor: color.withOpacity(0.1),
                child: Icon(icon, color: color),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      description,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }
}