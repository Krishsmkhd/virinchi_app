class Feed {
  final String? id;
  final String title;
  final String description;

  Feed({
    this.id,
    required this.title,
    required this.description,
  });

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'type': 'feed',
    };
  }

  factory Feed.fromMap(Map<String, dynamic> map, String id) {
    return Feed(
      id: id,
      title: map['title'] ?? '',
      description: map['description'] ?? '',
    );
  }
}
