import 'package:flutter/material.dart';
import '../presentation/widgets/index.dart';
import '../viewModels/pokemon_detail_view_model.dart';

class PokemonDetailPage extends StatefulWidget {
  final int pokemonId;
  final String title;
  final String imageUrl;
  const PokemonDetailPage({
    super.key,
    required this.pokemonId,
    required this.title,
    required this.imageUrl,
  });

  @override
  State<PokemonDetailPage> createState() => _PokemonDetailPageState();
}

class _PokemonDetailPageState extends State<PokemonDetailPage> {
  final PokemonDetailViewModel _vm = PokemonDetailViewModel();

  @override
  void initState() {
    super.initState();
    _vm.load(widget.pokemonId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange[300],
        title: Text(widget.title),
      ),
      body: AnimatedBuilder(
        animation: _vm,
        builder: (context, _) {
          if (_vm.error != null) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('불러오는 중 오류가 발생했습니다.'),
                    const SizedBox(height: 8),
                    Text(
                      _vm.error!,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    const SizedBox(height: 16),
                    FilledButton.icon(
                      onPressed: () => _vm.load(widget.pokemonId),
                      icon: const Icon(Icons.refresh),
                      label: const Text('다시 시도'),
                    )
                  ],
                ),
              ),
            );
          }

          if (_vm.isLoading && _vm.detail == null) {
            return const Center(child: CircularProgressIndicator());
          }

          final d = _vm.detail;
          if (d == null) {
            return const SizedBox.shrink();
          }

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Center(
                child: CircleAvatar(
                  radius: 56,
                  backgroundColor: Colors.orange[100],
                  backgroundImage: NetworkImage(d.imageUrl.isNotEmpty ? d.imageUrl : widget.imageUrl),
                ),
              ),
              const SizedBox(height: 16),
              Center(
                child: CustomText(text: '#${d.id}  ${d.name}', fontSize: 22, color: Colors.black87),
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: d.types
                    .map((t) => Chip(
                          label: Text(t),
                          backgroundColor: Colors.orange[50],
                        ))
                    .toList(),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _StatTile(title: 'Height', value: '${d.height}'),
                  _StatTile(title: 'Weight', value: '${d.weight}'),
                ],
              ),
              const SizedBox(height: 16),
              Text('Abilities', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: d.abilities
                    .map((a) => Chip(
                          label: Text(a),
                          side: const BorderSide(color: Colors.orange),
                        ))
                    .toList(),
              ),
              const SizedBox(height: 16),
              Text('Base Stats', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 8),
              ...d.stats.entries.map(
                (e) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: Row(
                    children: [
                      SizedBox(width: 110, child: Text(e.key.toUpperCase())),
                      Expanded(
                        child: LinearProgressIndicator(
                          value: (e.value.clamp(0, 200)) / 200,
                          color: Colors.orange,
                          backgroundColor: Colors.orange[50],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text('${e.value}')
                    ],
                  ),
                ),
              )
            ],
          );
        },
      ),
    );
  }
}

class _StatTile extends StatelessWidget {
  final String title;
  final String value;
  const _StatTile({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(title, style: Theme.of(context).textTheme.bodySmall),
        const SizedBox(height: 4),
        Text(value, style: Theme.of(context).textTheme.titleMedium),
      ],
    );
  }
}

