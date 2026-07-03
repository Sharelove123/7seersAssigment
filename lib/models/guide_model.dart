class GuideModel {
  final String id;
  final String title;
  final String description;
  final String imageUrl;
  final String category;
  final String? tag;
  final int order;

  GuideModel({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.category,
    this.tag,
    required this.order,
  });

  factory GuideModel.fromMap(Map<String, dynamic> map, String id) {
    return GuideModel(
      id: id,
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
      category: map['category'] ?? '',
      tag: map['tag'],
      order: map['order'] ?? 1,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'imageUrl': imageUrl,
      'category': category,
      'tag': tag,
      'order': order,
    };
  }
}
