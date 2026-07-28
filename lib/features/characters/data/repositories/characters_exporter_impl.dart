import '../../../../core/export/excel_export_service.dart';
import '../../domain/entities/character.dart';
import '../../domain/repositories/characters_exporter.dart';

class CharactersExporterImpl implements CharactersExporter {
  final ExcelExportService _excelExportService;

  const CharactersExporterImpl(this._excelExportService);

  @override
  Future<String> export(List<Character> characters) {
    return _excelExportService.exportCharacters(characters);
  }
}
