// features/dashboard/presentation/dashboard_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/widgets/image_card.dart';
import '../../../core/widgets/state_widgets.dart';
import '../providers/dashboard_provider.dart';
import '../domain/pixabay_image.dart';

class DashboardPage extends ConsumerWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncImages = ref.watch(trendingImagesProvider);

    return asyncImages.when(
      data: (images) {
        if (images.isEmpty) {
          return const EmptyState(message: "No trending images right now.");
        }
        return _buildGrid(context, images);
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, _) => ErrorState(
        message: "Failed to load images: $err",
        onRetry: () => ref.refresh(trendingImagesProvider),
      ),
    );
  }

  Widget _buildGrid(BuildContext context, List<PixabayImage> images) {
    final crossAxisCount =
    MediaQuery.of(context).size.width < 600 ? 2 : 4;

    return GridView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: images.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        childAspectRatio: 0.8,
      ),
      itemBuilder: (context, index) {
        return ImageCard(image: images[index]);
      },
    );
  }
}
