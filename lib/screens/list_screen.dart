import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/space_models.dart';
import 'detail_screen.dart';

class ListScreen extends StatefulWidget {
  final String menuType; // 'articles', 'blogs', atau 'reports'

  const ListScreen({Key? key, required this.menuType}) : super(key: key);

  @override
  State<ListScreen> createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen> {
  late Future<SpaceResponse> _spaceData;

  @override
  void initState() {
    super.initState();
    _spaceData = fetchSpaceData();
  }

  // Fungsi untuk mengambil list data dari API berdasarkan tipe menu
  Future<SpaceResponse> fetchSpaceData() async {
    final url = 'https://api.spaceflightnewsapi.net/v4/${widget.menuType}/';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        return SpaceResponse.fromJson(data);
      } else {
        throw Exception('Gagal memuat daftar data');
      }
    } catch (e) {
      throw Exception('Terjadi kesalahan jaringan: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    // Menyesuaikan judul AppBar sesuai dengan ketentuan tampilan di soal
    String appBarTitle = "Berita Terkini"; // Default untuk News
    if (widget.menuType == "blogs") appBarTitle = "Blog Terbaru";
    if (widget.menuType == "reports") appBarTitle = "Laporan Misi";

    return Scaffold(
      appBar: AppBar(
        title: Text(appBarTitle),
      ),
      body: FutureBuilder<SpaceResponse>(
        future: _spaceData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.results.isEmpty) {
            return const Center(child: Text('Tidak ada data tersedia'));
          }

          final listData = snapshot.data!.results;

          return ListView.builder(
            padding: const EdgeInsets.all(12.0),
            itemCount: listData.length,
            itemBuilder: (context, index) {
              final item = listData[index];

              return Card(
                elevation: 3,
                margin: const EdgeInsets.symmetric(vertical: 8.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: InkWell(
                  onTap: () {
                    // Berpindah ke halaman ketiga (DetailScreen) dengan membawa ID & Tipe Menu
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetailScreen(
                          id: item.id,
                          menuType: widget.menuType,
                        ),
                      ),
                    );
                  },
                  borderRadius: BorderRadius.circular(10),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Thumbnail Gambar di Sebelah Kiri
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8.0),
                          child: Image.network(
                            item.imageUrl,
                            width: 100,
                            height: 100,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                width: 100,
                                height: 100,
                                color: Colors.grey[300],
                                child: const Icon(Icons.broken_image, color: Colors.grey),
                              );
                            },
                          ),
                        ),
                        const SizedBox(width: 12),
                        
                        // Informasi Teks (Judul, Sumber, Tanggal) di Sebelah Kanan
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.title,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                item.newsSite,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.blue.shade800,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                item.publishedAt.substring(0, 10), // Format YYYY-MM-DD
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}