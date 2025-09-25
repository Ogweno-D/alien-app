import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'pixabay_service.dart';

// Global PixabayService provider
final pixabayServiceProvider = Provider<PixabayService>((ref) {
  return PixabayService(
    // baseUrl: "https://pixabay.com/api/",
    // apiKey: "",

    baseUrl: "https://pixabay-proxy.vercel.app/api/pixabay"

  );
});
