import 'package:flutter/material.dart';
import '../presentation/widgets/index.dart';
import '../viewModels/pokemon_view_model.dart';
import 'detail.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final PokemonViewModel _vm = PokemonViewModel();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _vm.fetchMore();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    final threshold = 200.0;
    final max = _scrollController.position.maxScrollExtent;
    final offset = _scrollController.offset;
    if (max - offset <= threshold) {
      _vm.fetchMore();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange[300],
        centerTitle: true,
        title: const CustomText(text: '포켓몬백과사전'),
      ),
      body: AnimatedBuilder(
        animation: _vm,
        builder: (context, _) {
          if (_vm.error != null && _vm.pokemons.isEmpty) {
            return _ErrorView(message: _vm.error!, onRetry: _vm.refresh);
          }

          return RefreshIndicator(
            onRefresh: _vm.refresh,
            child: ListView.builder(
              controller: _scrollController,
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: _vm.pokemons.length + (_vm.hasMore ? 1 : 0),
              itemBuilder: (context, index) {
                if (index < _vm.pokemons.length) {
                  final p = _vm.pokemons[index];
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.orange[100],
                      backgroundImage: NetworkImage(p.imageUrl),
                    ),
                    title: Text(p.name),
                    trailing: Text('#${p.id}'),
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => PokemonDetailPage(
                            pokemonId: p.id,
                            title: p.name,
                            imageUrl: p.imageUrl,
                          ),
                        ),
                      );
                    },
                  );
                }
                if (_vm.error != null) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: Center(
                      child: TextButton.icon(
                        onPressed: _vm.fetchMore,
                        icon: const Icon(Icons.refresh),
                        label: const Text('다시 시도'),
                      ),
                    ),
                  );
                }
                return const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16.0),
                  child: Center(child: CircularProgressIndicator()),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  final String message;
  final Future<void> Function() onRetry;
  const _ErrorView({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '에러가 발생했어요',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text('다시 시도'),
            )
          ],
        ),
      ),
    );
  }
}

