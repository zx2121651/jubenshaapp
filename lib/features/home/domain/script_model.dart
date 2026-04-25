class ScriptModel {
  final String id;
  final String title;
  final String coverUrl;
  final List<String> tags;
  final String authorName;
  final String authorAvatar;
  final int likes;

  ScriptModel({
    required this.id,
    required this.title,
    required this.coverUrl,
    required this.tags,
    required this.authorName,
    required this.authorAvatar,
    required this.likes,
  });
}
