// features/gallery/presentation/gallery_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/widgets/image_card.dart';
import '../../../core/widgets/state_widgets.dart';
import '../providers/gallery_provider.dart';
import '../../dashboard/domain/pixabay_image.dart';

class GalleryPage extends ConsumerWidget {
  const GalleryPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncImages = ref.watch(searchImagesProvider);
    final query = ref.watch(searchQueryProvider);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: TextField(
            decoration: InputDecoration(
              hintText: "Search images...",
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onSubmitted: (value) {
              if (value.isNotEmpty) {
                ref.read(searchQueryProvider.notifier).state = value;
              }
            },
          ),
        ),
        Expanded(
          child: asyncImages.when(
            data: (images) {
              if (images.isEmpty) {
                return EmptyState(
                  message: "No results for \"$query\"",
                );
              }
              return _buildResponsiveLayout(context, images);
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (err, _) => ErrorState(
              message: "Search failed: $err",
              onRetry: () => ref.refresh(searchImagesProvider),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildResponsiveLayout(BuildContext context, List<PixabayImage> images) {
    final isMobile = MediaQuery.of(context).size.width < 600;

    if (isMobile) {
      return ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: images.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) => SizedBox(
          height: 200,
          child: ImageCard(image: images[index]),
        ),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: images.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        childAspectRatio: 0.8,
      ),
      itemBuilder: (context, index) => ImageCard(image: images[index]),
    );
  }
}
