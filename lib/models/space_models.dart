// lib/models/space_model.dart

class SpaceResponse {
  final int count;
  final List<SpaceModel> results;

  SpaceResponse({
    required this.count,
    required this.results,
  });

  // Fungsi untuk mem-parsing JSON utama (yang memiliki key 'results')
  factory SpaceResponse.fromJson(Map<String, dynamic> json) {
    return SpaceResponse(
      count: json['count'] ?? 0,
      results: json['results'] != null 
          ? List<SpaceModel>.from(json['results'].map((x) => SpaceModel.fromJson(x)))
          : [],
    );
  }
}

class SpaceModel {
  final int id;
  final String title;
  final String url;
  final String imageUrl;
  final String newsSite;
  final String summary;
  final String publishedAt;

  SpaceModel({
    required this.id,
    required this.title,
    required this.url,
    required this.imageUrl,
    required this.newsSite,
    required this.summary,
    required this.publishedAt,
  });

  // Fungsi untuk mem-parsing JSON detail dari masing-masing item
  factory SpaceModel.fromJson(Map<String, dynamic> json) {
    return SpaceModel(
      id: json['id'] ?? 0,
      title: json['title'] ?? 'No Title',
      url: json['url'] ?? '',
      imageUrl: json['image_url'] ?? 'https://via.placeholder.com/150', // Fallback gambar
      newsSite: json['news_site'] ?? 'Unknown Site',
      summary: json['summary'] ?? 'No Summary available.',
      publishedAt: json['published_at'] ?? '',
    );
  }
}