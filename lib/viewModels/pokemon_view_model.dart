import 'package:flutter/foundation.dart';
import '../models/pokemon.dart';
import '../services/pokemon_service.dart';

class PokemonViewModel extends ChangeNotifier {
  final PokemonService _pokemonService = PokemonService();

  final List<Pokemon> _pokemons = [];
  bool _isLoading = false;
  String? _error;
  int _offset = 0;
  final int _limit = 20;
  bool _hasMore = true;

  List<Pokemon> get pokemons => List.unmodifiable(_pokemons);
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get hasMore => _hasMore;

  Future<void> refresh() async {
    _offset = 0;
    _hasMore = true;
    _pokemons.clear();
    notifyListeners();
    await fetchMore();
  }

  Future<void> fetchMore() async {
    if (_isLoading || !_hasMore) return;
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      final items = await _pokemonService.fetchPokemonList(limit: _limit, offset: _offset);
      if (items.isEmpty) {
        _hasMore = false;
      } else {
        _pokemons.addAll(items);
        _offset += items.length;
      }
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
