class Breed {
  final String id;
  final String name;
  final String origin;
  final String temperament;
  final String description;

  Breed({
    required this.id,
    required this.name,
    required this.origin,
    required this.temperament,
    required this.description,
  });

  factory Breed.fromJson(Map<String, dynamic> json) {
    return Breed(
      id: json['id'] ?? '',
      name: json['name'] ?? 'Unknown',
      origin: json['origin'] ?? 'Unknown',
      temperament: json['temperament'] ?? '',
      description: json['description'] ?? '',
    );
  }
}

class Cat {
  final String id;
  final String imageUrl;
  final List<Breed> breeds;

  Cat({required this.id, required this.imageUrl, required this.breeds});

  factory Cat.fromJson(Map<String, dynamic> json) {
    List<Breed> breedList = [];
    if (json['breeds'] != null && (json['breeds'] as List).isNotEmpty) {
      breedList = (json['breeds'] as List)
          .map((b) => Breed.fromJson(b))
          .toList();
    }

    return Cat(
      id: json['id'] ?? '',
      imageUrl: json['url'] ?? '',
      breeds: breedList,
    );
  }
}
