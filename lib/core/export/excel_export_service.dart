import 'dart:io';

import 'package:excel/excel.dart';
import 'package:path_provider/path_provider.dart';

import '../../features/characters/domain/entities/character.dart';
class ExcelExportService {
  Future<String> exportCharacters(List<Character> characters) async {
    final excel = Excel.createExcel();
    final sheet = excel['Characters'];
    excel.setDefaultSheet('Characters');

    sheet.appendRow([
      TextCellValue('ID'),
      TextCellValue('Name'),
      TextCellValue('Status'),
      TextCellValue('Species'),
      TextCellValue('Gender'),
      TextCellValue('Location'),
    ]);

    for (final character in characters) {
      sheet.appendRow([
        IntCellValue(character.id),
        TextCellValue(character.name),
        TextCellValue(character.status),
        TextCellValue(character.species),
        TextCellValue(character.gender),
        TextCellValue(character.location),
      ]);
    }

    final bytes = excel.encode();
    if (bytes == null) {
      throw Exception('Failed to encode Excel file');
    }

    final directory = await getTemporaryDirectory();
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final filePath = '${directory.path}/Rick_and_Morty_Characters_$timestamp.xlsx';

    final file = File(filePath);
    await file.writeAsBytes(bytes);

    return filePath;
  }
}
