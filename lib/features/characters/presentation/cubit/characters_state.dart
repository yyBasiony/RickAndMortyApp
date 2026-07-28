import '../../domain/entities/character.dart';

sealed class CharactersState {
  const CharactersState();
}

class CharactersInitial extends CharactersState {
  const CharactersInitial();
}

class CharactersLoading extends CharactersState {
  const CharactersLoading();
}

class CharactersLoadingMore extends CharactersState {
  final List<Character> characters;
  const CharactersLoadingMore(this.characters);
}

class CharactersLoaded extends CharactersState {
  final List<Character> characters;
  final bool hasNextPage;
  const CharactersLoaded({
    required this.characters,
    required this.hasNextPage,
  });
}

class CharactersEmpty extends CharactersState {
  const CharactersEmpty();
}

class CharactersError extends CharactersState {
  final String message;
  const CharactersError(this.message);
}

class CharactersExporting extends CharactersState {
  final List<Character> characters;
  const CharactersExporting(this.characters);
}

class CharactersExportSuccess extends CharactersState {
  final List<Character> characters;
  final String filePath;
  const CharactersExportSuccess({
    required this.characters,
    required this.filePath,
  });
}

class CharactersExportError extends CharactersState {
  final List<Character> characters;
  final String message;
  const CharactersExportError({
    required this.characters,
    required this.message,
  });
}
