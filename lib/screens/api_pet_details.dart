import 'package:flutter/material.dart';
import '../model/api_model.dart';

class ApiPetDetails extends StatelessWidget {
  final Cat cat;

  const ApiPetDetails({super.key, required this.cat});

  @override
  Widget build(BuildContext context) {
    final breed = cat.breeds.first;

    return Scaffold(
      appBar: AppBar(title: Text(breed.name)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(cat.imageUrl),
            ),
            const SizedBox(height: 16),
            Text(
              breed.name,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Origin: ${breed.origin}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(
              'Temperament: ${breed.temperament}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            Text(breed.description, style: const TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
