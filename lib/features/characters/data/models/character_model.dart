import '../../domain/entities/character.dart';

class CharacterModel extends Character {
  const CharacterModel({
    required super.id,
    required super.name,
    required super.status,
    required super.species,
    required super.gender,
    required super.imageUrl,
    required super.location,
  });

  factory CharacterModel.fromJson(Map<String, dynamic> json) {
    return CharacterModel(
      id: json['id'] as int,
      name: json['name'] as String? ?? 'Unknown',
      status: json['status'] as String? ?? 'unknown',
      species: json['species'] as String? ?? 'Unknown',
      gender: json['gender'] as String? ?? 'unknown',
      imageUrl: json['image'] as String? ?? '',
      location: (json['location'] as Map<String, dynamic>?)?['name']
              as String? ??
          'Unknown',
    );
  }
}
