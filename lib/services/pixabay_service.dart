// services/pixabay_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../core/constants/api_constants.dart';
import '../features/dashboard/domain/pixabay_image.dart';

class PixabayService {
  Future<List<PixabayImage>> fetchImages({String query = "popular"}) async {
    final url = Uri.parse("${ApiConstants.baseUrl}?q=$query&page=1&per_page=20");
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List hits = data['hits'];
      return hits.map((json) => PixabayImage.fromJson(json)).toList();
    } else {
      throw Exception("Failed to load images: ${response.statusCode}");
    }
  }
}
