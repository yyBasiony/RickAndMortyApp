import 'character.dart';
class PaginatedCharacters {
  final List<Character> characters;
  final bool hasNextPage;

  const PaginatedCharacters({
    required this.characters,
    required this.hasNextPage,
  });
}
