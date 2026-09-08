import 'package:flutter/material.dart';

/// 渐变头像：用「渐变背景 + 首字符」渲染，不依赖外链图片，稳定且质感统一，
/// 对标主流剧本杀 APP 的本地方言色头像。可传入 [url] 优先加载网络图。
class GradientAvatar extends StatelessWidget {
  const GradientAvatar({
    super.key,
    required this.text,
    required this.size,
    this.imageUrl,
    this.gradient,
    this.borderColor = Colors.white12,
  });

  final String text;
  final double size;
  final String? imageUrl;
  final Gradient? gradient;
  final Color borderColor;

  static const List<Gradient> _palette = [
    LinearGradient(colors: [Color(0xFF7F5BE3), Color(0xFF43A6F6)], begin: Alignment.topLeft, end: Alignment.bottomRight),
    LinearGradient(colors: [Color(0xFFF6677E), Color(0xFFF6A05C)], begin: Alignment.topLeft, end: Alignment.bottomRight),
    LinearGradient(colors: [Color(0xFF4AC29A), Color(0xFF35B0E8)], begin: Alignment.topLeft, end: Alignment.bottomRight),
    LinearGradient(colors: [Color(0xFF8E54E9), Color(0xFFEF7A63)], begin: Alignment.topLeft, end: Alignment.bottomRight),
    LinearGradient(colors: [Color(0xFFF2994A), Color(0xFFF2C94C)], begin: Alignment.topLeft, end: Alignment.bottomRight),
  ];

  @override
  Widget build(BuildContext context) {
    final g = gradient ?? _palette[text.hashCode.abs() % _palette.length];
    final letter = text.isEmpty ? '?' : String.fromCharCode(text.runes.first);

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: g,
        border: Border.all(color: borderColor, width: 1.2),
      ),
      clipBehavior: Clip.antiAlias,
      child: imageUrl == null
          ? Center(
              child: Text(
                letter,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: size * 0.42,
                  fontWeight: FontWeight.w800,
                ),
              ),
            )
          : Image.network(
              imageUrl!,
              fit: BoxFit.cover,
              errorBuilder: (_, _, _) => Center(
                child: Text(
                  letter,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: size * 0.42,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ),
    );
  }
}

/// 渐变封面：剧本书封面占位，用标题首字 + 渐变组成，稳定美观。
class GradientCover extends StatelessWidget {
  const GradientCover({
    super.key,
    required this.title,
    this.imageUrl,
    this.radius = 14,
    this.icon = Icons.menu_book,
  });

  final String title;
  final String? imageUrl;
  final double radius;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final g = GradientAvatar._palette[title.hashCode.abs() % GradientAvatar._palette.length];
    final letter = title.isEmpty ? '?' : String.fromCharCode(title.runes.first);

    return Container(
      decoration: BoxDecoration(
        gradient: g,
        borderRadius: BorderRadius.circular(radius),
      ),
      clipBehavior: Clip.antiAlias,
      child: imageUrl == null
          ? Stack(
              fit: StackFit.expand,
              children: [
                Align(
                  alignment: const Alignment(0.0, 1.15),
                  child: Icon(icon, size: 90, color: Colors.white.withValues(alpha: 0.18)),
                ),
                Center(
                  child: Text(
                    letter,
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.95),
                      fontSize: 40,
                      fontWeight: FontWeight.w800,
                      shadows: [Shadow(color: Colors.black26, blurRadius: 8)],
                    ),
                  ),
                ),
              ],
            )
          : Image.network(
              imageUrl!,
              fit: BoxFit.cover,
              errorBuilder: (_, _, _) => Stack(
                fit: StackFit.expand,
                children: [
                  Align(
                    alignment: const Alignment(0.0, 1.15),
                    child: Icon(icon, size: 90, color: Colors.white.withValues(alpha: 0.18)),
                  ),
                  Center(
                    child: Text(
                      letter,
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.95),
                        fontSize: 40,
                        fontWeight: FontWeight.w800,
                        shadows: [Shadow(color: Colors.black26, blurRadius: 8)],
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}