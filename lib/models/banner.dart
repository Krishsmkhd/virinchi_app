class Banner {
  final String? id;
  final String imageUrl;

  Banner({
    this.id,
    required this.imageUrl,
  });

  Map<String, dynamic> toMap() {
    return {
      'imageUrl': imageUrl,
      'type': 'banner',
    };
  }

  factory Banner.fromMap(Map<String, dynamic> map, String id) {
    return Banner(
      id: id,
      imageUrl: map['imageUrl'] ?? '',
    );
  }
}
