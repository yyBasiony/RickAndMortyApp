import '../entities/character.dart';

abstract class CharactersExporter {
  Future<String> export(List<Character> characters);
}
