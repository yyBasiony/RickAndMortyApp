import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/error/api_result.dart';
import '../../../../core/error/failure.dart';
import '../../domain/entities/character.dart';
import '../../domain/usecases/export_characters.dart';
import '../../domain/usecases/get_characters.dart';
import 'characters_state.dart';

class CharactersCubit extends Cubit<CharactersState> {
  final GetCharacters _getCharacters;
  final ExportCharacters _exportCharacters;

  CharactersCubit(this._getCharacters, this._exportCharacters)
      : super(const CharactersInitial());

  int _page = 1;
  bool _hasNextPage = true;
  bool _isFetchingNextPage = false;

  String? _name;
  String? _status;
  String? _species;
  String? _gender;

  Timer? _searchDebounce;

  Future<void> loadCharacters() async {
    emit(const CharactersLoading());
    _page = 1;
    await _fetch(isFirstPage: true);
  }

  Future<void> loadNextPage() async {
    if (_isFetchingNextPage || !_hasNextPage) return;
    final currentState = state;
    if (currentState is! CharactersLoaded) return;

    _isFetchingNextPage = true;
    emit(CharactersLoadingMore(currentState.characters));
    _page++;
    await _fetch(isFirstPage: false, previous: currentState.characters);
    _isFetchingNextPage = false;
  }

  void searchByName(String query) {
    _searchDebounce?.cancel();
    _searchDebounce = Timer(const Duration(milliseconds: 400), () {
      _name = query.trim().isEmpty ? null : query.trim();
      loadCharacters();
    });
  }

  void applyFilters({String? status, String? species, String? gender}) {
    _status = status;
    _species = species;
    _gender = gender;
    loadCharacters();
  }

  Future<void> _fetch({
    required bool isFirstPage,
    List<Character> previous = const [],
  }) async {
    final result = await _getCharacters(
      page: _page,
      name: _name,
      status: _status,
      species: _species,
      gender: _gender,
    );

    switch (result) {
      case ApiSuccess(data: final page):
        _hasNextPage = page.hasNextPage;
        final combined = [...previous, ...page.characters];
        if (combined.isEmpty) {
          emit(const CharactersEmpty());
        } else {
          emit(CharactersLoaded(
            characters: combined,
            hasNextPage: _hasNextPage,
          ));
        }
      case ApiFailure(failure: final failure):
        if (isFirstPage) {
          if (failure is NotFoundFailure) {
            emit(const CharactersEmpty());
          } else {
            emit(CharactersError(_messageFor(failure)));
          }
        } else {
          _page--;
          emit(CharactersLoaded(characters: previous, hasNextPage: false));
        }
    }
  }

  Future<void> exportToExcel() async {
    final currentState = state;
    final characters = switch (currentState) {
      CharactersLoaded(:final characters) => characters,
      CharactersLoadingMore(:final characters) => characters,
      _ => <Character>[],
    };

    if (characters.isEmpty) return;

    emit(CharactersExporting(characters));
    try {
      final filePath = await _exportCharacters(characters);
      emit(CharactersExportSuccess(characters: characters, filePath: filePath));
    } catch (e) {
      emit(CharactersExportError(characters: characters, message: e.toString()));
    }
  }

  String _messageFor(Failure failure) => switch (failure) {
        NetworkFailure() => 'No internet connection. Please try again.',
        ServerFailure() => 'Something went wrong. Please try again later.',
        NotFoundFailure() => 'No characters found.',
        UnknownFailure() => 'Unexpected error occurred.',
      };

  @override
  Future<void> close() {
    _searchDebounce?.cancel();
    return super.close();
  }
}
