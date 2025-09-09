import 'package:flutter/foundation.dart';
import '../models/pokemon_detail.dart';
import '../services/pokemon_service.dart';

class PokemonDetailViewModel extends ChangeNotifier {
  final PokemonService _service = PokemonService();

  PokemonDetail? _detail;
  bool _isLoading = false;
  String? _error;

  PokemonDetail? get detail => _detail;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> load(int id) async {
    if (_isLoading) return;
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      _detail = await _service.fetchPokemonDetail(id);
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}

