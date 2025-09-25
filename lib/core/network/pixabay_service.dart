import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features/dashboard/domain/pixabay_image.dart';

class PixabayService {
  final String baseUrl;
  final String apiKey;

  PixabayService({required this.baseUrl, required this.apiKey});

  Future<List<PixabayImage>> fetchTrendingImages() async {
    final url = Uri.parse(
      "$baseUrl?key=$apiKey&order=popular&image_type=photo&per_page=30",
    );
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final body = json.decode(response.body) as Map<String, dynamic>;
      final hits = body['hits'] as List;
      return hits.map((e) => PixabayImage.fromJson(e)).toList();
    } else {
      throw Exception("Failed to load trending images");
    }
  }

  Future<List<PixabayImage>> searchImages(String query) async {
    final url = Uri.parse(
      "$baseUrl?key=$apiKey&q=$query&image_type=photo&per_page=30",
    );
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final body = json.decode(response.body) as Map<String, dynamic>;
      final hits = body['hits'] as List;
      return hits.map((e) => PixabayImage.fromJson(e)).toList();
    } else {
      throw Exception("Failed to load search results");
    }
  }
}

// Provider for dependency injection
final pixabayServiceProvider = Provider<PixabayService>((ref) {
  return PixabayService(
    baseUrl: "https://pixabay.com/api/",
    apiKey: "A",
  );
});
