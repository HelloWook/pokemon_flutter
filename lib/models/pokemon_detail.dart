class PokemonDetail {
  final int id;
  final String name;
  final String imageUrl;
  final int height;
  final int weight;
  final List<String> types;
  final List<String> abilities;
  final Map<String, int> stats;

  PokemonDetail({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.height,
    required this.weight,
    required this.types,
    required this.abilities,
    required this.stats,
  });

  factory PokemonDetail.fromJson(Map<String, dynamic> json) {
    final List<String> types = (json['types'] as List? ?? [])
        .map((e) => (e['type']?['name'] as String?) ?? '')
        .where((e) => e.isNotEmpty)
        .toList();
    final List<String> abilities = (json['abilities'] as List? ?? [])
        .map((e) => (e['ability']?['name'] as String?) ?? '')
        .where((e) => e.isNotEmpty)
        .toList();
    final Map<String, int> stats = <String, int>{
      for (final s in (json['stats'] as List? ?? []))
        if (s['stat']?['name'] != null && s['base_stat'] != null)
          (s['stat']['name'] as String): (s['base_stat'] as int)
    };

    return PokemonDetail(
      id: json['id'] as int,
      name: json['name'] as String,
      imageUrl: (json['sprites']?['front_default']) as String? ?? '',
      height: json['height'] as int? ?? 0,
      weight: json['weight'] as int? ?? 0,
      types: types,
      abilities: abilities,
      stats: stats,
    );
  }
}

