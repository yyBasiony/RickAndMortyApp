import 'package:dio/dio.dart';

import '../../../../core/api/api_service.dart';
import '../models/character_model.dart';
import 'characters_exceptions.dart';

class RemoteCharactersPage {
  final List<CharacterModel> characters;
  final bool hasNextPage;

  const RemoteCharactersPage({
    required this.characters,
    required this.hasNextPage,
  });
}

abstract class CharactersRemoteDataSource {
  Future<RemoteCharactersPage> getCharacters({
    required int page,
    String? name,
    String? status,
    String? species,
    String? gender,
  });
}

class CharactersRemoteDataSourceImpl implements CharactersRemoteDataSource {
  final ApiService _apiService;

  const CharactersRemoteDataSourceImpl(this._apiService);

  @override
  Future<RemoteCharactersPage> getCharacters({
    required int page,
    String? name,
    String? status,
    String? species,
    String? gender,
  }) async {
    try {
      final response = await _apiService.get(
        '/character',
        queryParameters: {
          'page': page,
          if (name != null && name.isNotEmpty) 'name': name,
          if (status != null && status.isNotEmpty) 'status': status,
          if (species != null && species.isNotEmpty) 'species': species,
          if (gender != null && gender.isNotEmpty) 'gender': gender,
        },
      );

      final data = response.data as Map<String, dynamic>;
      final results = (data['results'] as List<dynamic>)
          .map((json) => CharacterModel.fromJson(json as Map<String, dynamic>))
          .toList();
      final nextPageUrl = (data['info'] as Map<String, dynamic>)['next'];

      return RemoteCharactersPage(
        characters: results,
        hasNextPage: nextPageUrl != null,
      );
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        throw const NotFoundException('No characters found');
      }
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.connectionError) {
        throw const NetworkException('No internet connection');
      }
      throw ServerException(e.message ?? 'Unexpected server error');
    }
  }
}
