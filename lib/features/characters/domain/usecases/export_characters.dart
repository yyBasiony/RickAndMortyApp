import '../entities/character.dart';
import '../repositories/characters_exporter.dart';

class ExportCharacters {
  final CharactersExporter _exporter;

  const ExportCharacters(this._exporter);

  Future<String> call(List<Character> characters) {
    return _exporter.export(characters);
  }
}
