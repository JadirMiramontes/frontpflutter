import 'package:flutter/material.dart';

class DigimonSearchScreen extends StatelessWidget {
  const DigimonSearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Buscar Digimons'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Busca tu Digimon favorito',
              style: TextStyle(fontSize: 24),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                decoration: const InputDecoration(
                  labelText: 'Nombre del Digimon',
                  border: OutlineInputBorder(),
                ),
                onSubmitted: (text) {
                  // Aquí puedes implementar la lógica de búsqueda de Digimon
                  print("Buscando Digimon: $text");
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
