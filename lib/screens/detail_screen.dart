import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/space_models.dart'; // Sesuaikan nama file modelmu jika tanpa huruf 's'
import '../services/api_service.dart'; // Disarankan memanggil lewat ApiService agar lebih bersih

class DetailScreen extends StatefulWidget {
  final int id;
  final String menuType; // 'articles', 'blogs', atau 'reports'

  const DetailScreen({
    Key? key,
    required this.id,
    required this.menuType,
  }) : super(key: key);

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  late Future<SpaceModel> _detailData;

  @override
  void initState() {
    super.initState(); // PERBAIKAN: Cara pemanggilan initState yang benar
    _detailData = ApiService().fetchDetailData(widget.menuType, widget.id);
  }

  // Fungsi untuk membuka URL di web browser eksternal ponsel
  Future<void> _launchUrl(String urlString) async {
    final Uri url = Uri.parse(urlString);
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Tidak dapat membuka link artikel')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Menyesuaikan judul AppBar berdasarkan tipe menu (Sesuai contoh mockup PDF)
    String titleAppBar = "News Detail";
    if (widget.menuType == "blogs") titleAppBar = "Blog Detail";
    if (widget.menuType == "reports") titleAppBar = "Report Detail";

    return Scaffold(
      appBar: AppBar(
        title: Text(titleAppBar),
      ),
      body: FutureBuilder<SpaceModel>(
        future: _detailData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return const Center(child: Text('Data tidak ditemukan'));
          }

          final data = snapshot.data!;

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Gambar Utama Berita
                Image.network(
                  data.imageUrl,
                  width: double.infinity,
                  height: 250,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      height: 250,
                      color: Colors.grey[300],
                      child: const Icon(Icons.broken_image, size: 50),
                    );
                  },
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Judul Utama
                      Text(
                        data.title,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      
                      // Row Informasi Situs Berita dan Tanggal Rilis
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            data.newsSite,
                            style: TextStyle(
                              color: Colors.blue[700],
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            data.publishedAt.length >= 10 
                                ? data.publishedAt.substring(0, 10) 
                                : data.publishedAt, // Ambil format YYYY-MM-DD
                            style: const TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                      const Divider(height: 30, thickness: 1),
                      
                      // Isi Summary / Detail Informasi Utama
                      Text(
                        data.summary,
                        style: const TextStyle(
                          fontSize: 16,
                          height: 1.5,
                        ),
                        textAlign: TextAlign.justify,
                      ),
                      const SizedBox(height: 80), // Beri ruang agar teks terbawah tidak tertutup FAB
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
      // PERBAIKAN: Menggunakan FloatingActionButton.extended agar memanjang bertuliskan "See more..." (Sesuai Soal)
      floatingActionButton: FutureBuilder<SpaceModel>(
        future: _detailData,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return FloatingActionButton.extended(
              onPressed: () => _launchUrl(snapshot.data!.url),
              backgroundColor: const Color(0xFF212121), // Menyesuaikan tema gelap AppBar-mu
              foregroundColor: Colors.white,
              icon: const Icon(Icons.chrome_reader_mode_outlined),
              label: const Text(
                "See more...",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}