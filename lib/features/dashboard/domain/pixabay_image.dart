// models/pixabay_image.dart
class PixabayImage {
  final String id;
  final String previewURL;
  final String webformatURL;
  final String largeImageURL;
  final String user;
  final List<String> tags;

  PixabayImage({
    required this.id,
    required this.previewURL,
    required this.webformatURL,
    required this.largeImageURL,
    required this.user,
    required this.tags,
  });

  factory PixabayImage.fromJson(Map<String, dynamic> json) {
    return PixabayImage(
      id: json['id'].toString(),
      previewURL: json['previewURL'] ?? '',
      webformatURL: json['webformatURL'] ?? '',
      largeImageURL: json['largeImageURL'] ?? '',
      user: json['user'] ?? '',
      tags: (json['tags'] as String).split(',').map((t) => t.trim()).toList(),
    );
  }
}
