import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../features/dashboard/domain/pixabay_image.dart';

class PixabayService {
  final String baseUrl;

  PixabayService({required this.baseUrl});

  Future<List<PixabayImage>> fetchTrendingImages() async {
    final url = Uri.parse(
      "$baseUrl?&order=popular&image_type=photo&per_page=30",
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
      "$baseUrl?&q=$query&image_type=photo&per_page=30",
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

