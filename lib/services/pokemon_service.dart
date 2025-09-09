import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;
import '../const/api.dart';
import '../models/pokemon.dart';
import '../models/pokemon_detail.dart';

class PokemonService {
  Future<List<Pokemon>> fetchPokemonList({int limit = 20, int offset = 0}) async {
    final url = Uri.parse('${apiUrl}?limit=$limit&offset=$offset');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final List results = (data['results'] as List? ?? []);
      final items = results
          .map((e) => Pokemon.fromListItem(e as Map<String, dynamic>))
          .toList();
      log('Fetched ${items.length} pokemon (offset=$offset)');
      return items;
    } else {
      throw Exception('Failed to load Pokemon: ${response.statusCode}');
    }
  }

  Future<PokemonDetail> fetchPokemonDetail(int id) async {
    final url = Uri.parse('$apiUrl$id');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      return PokemonDetail.fromJson(data);
    } else {
      throw Exception('Failed to load Pokemon detail: ${response.statusCode}');
    }
  }
}
