/// 剧本 / 房间领域模型。
class ScriptModel {
  final String id;
  final String title;
  final String coverUrl;
  final List<String> tags;
  final String authorName;
  final String authorAvatar;
  final int likes;
  final int players; // 建议人数
  final String category; // 类型：硬核/情感/恐怖/欢乐/阵营...
  final int durationMins; // 时长（分钟）

  ScriptModel({
    required this.id,
    required this.title,
    required this.coverUrl,
    required this.tags,
    required this.authorName,
    required this.authorAvatar,
    required this.likes,
    required this.players,
    required this.category,
    required this.durationMins,
  });

  /// 稳定评分展示：由点赞数推导，落在主流评分区间 8.0~9.4。
  double get score => (8.0 + (likes % 15) / 10.0);

  String get scoreText => score.toStringAsFixed(1);
}