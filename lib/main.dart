import 'package:flutter/material.dart';
import './pages/index.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (context) => const Home(),
        '/detail': (context) => const PokemonDetailPage(
          pokemonId: 1,
          title: 'Pikachu',
          imageUrl: 'https://example.com/pikachu.png',
        ),
      },
    );
  }
}
