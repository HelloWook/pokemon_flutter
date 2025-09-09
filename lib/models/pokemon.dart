import '../const/api.dart';

class Pokemon {
  final int id;
  final String name;
  final String imageUrl;

  Pokemon({required this.id, required this.name, required this.imageUrl});

  // 상세 엔드포인트 응답에서 파싱 시 사용
  factory Pokemon.fromJson(Map<String, dynamic> json) {
    return Pokemon(
      id: json['id'] as int,
      name: json['name'] as String,
      imageUrl: (json['sprites']?['front_default']) as String,
    );
  }

  // 목록(results) 아이템에서 파싱 시 사용
  factory Pokemon.fromListItem(Map<String, dynamic> json) {
    final String url = json['url'] as String;
    final int id = Pokemon.idFromUrl(url);
    return Pokemon(
      id: id,
      name: json['name'] as String,
      imageUrl: '$spritesBaseUrl/$id.png',
    );
  }

  static int idFromUrl(String url) {
    final reg = RegExp(r"/pokemon/(\d+)/?");
    final match = reg.firstMatch(url);
    if (match != null) {
      return int.parse(match.group(1)!);
    }
    // fallback: 끝의 숫자만 추출
    final digits = RegExp(r"(\d+)").allMatches(url).map((m) => m.group(1)!).toList();
    return int.parse(digits.isNotEmpty ? digits.last : '0');
  }
}

