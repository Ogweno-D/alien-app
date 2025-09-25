import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/network/providers.dart';
import '../domain/pixabay_image.dart';


// FutureProvider to fetch trending images
final trendingImagesProvider = FutureProvider<List<PixabayImage>>((ref) async {
  final service = ref.read(pixabayServiceProvider);
  return service.fetchTrendingImages();
});

// Provider to search images
final searchImagesProvider = FutureProvider.family<List<PixabayImage>, String>((ref, query) async {
  final service = ref.read(pixabayServiceProvider);
  return service.searchImages(query);
});