class CommunityPostModel {
  final String id;
  final String author;
  final String authorInitial;
  final String text;
  final String group;
  final String timestamp;

  CommunityPostModel({
    required this.id,
    required this.author,
    required this.authorInitial,
    required this.text,
    required this.group,
    required this.timestamp,
  });

  factory CommunityPostModel.fromMap(Map<String, dynamic> map, String id) {
    return CommunityPostModel(
      id: id,
      author: map['author'] ?? '',
      authorInitial: map['authorInitial'] ?? '',
      text: map['text'] ?? '',
      group: map['group'] ?? '',
      timestamp: map['timestamp'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'author': author,
      'authorInitial': authorInitial,
      'text': text,
      'group': group,
      'timestamp': timestamp,
    };
  }
}
