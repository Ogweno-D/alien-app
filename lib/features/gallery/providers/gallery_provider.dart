// features/gallery/providers/gallery_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/providers.dart';
import '../../dashboard/domain/pixabay_image.dart';


// search query state
final searchQueryProvider = StateProvider<String>((ref) => "cats");

// fetch images by query
final searchImagesProvider = FutureProvider<List<PixabayImage>>((ref) async {
  final query = ref.watch(searchQueryProvider);
  return ref.read(pixabayServiceProvider).searchImages(query);
});
