import '../../../../core/error/api_result.dart';
import '../../../../core/error/failure.dart';
import '../../domain/entities/paginated_characters.dart';
import '../../domain/repositories/characters_repository.dart';
import '../datasources/characters_exceptions.dart';
import '../datasources/characters_remote_data_source.dart';

class CharactersRepositoryImpl implements CharactersRepository {
  final CharactersRemoteDataSource _remoteDataSource;

  const CharactersRepositoryImpl(this._remoteDataSource);

  @override
  Future<ApiResult<PaginatedCharacters>> getCharacters({
    required int page,
    String? name,
    String? status,
    String? species,
    String? gender,
  }) async {
    try {
      final page_ = await _remoteDataSource.getCharacters(
        page: page,
        name: name,
        status: status,
        species: species,
        gender: gender,
      );
      return ApiSuccess(
        PaginatedCharacters(
          characters: page_.characters,
          hasNextPage: page_.hasNextPage,
        ),
      );
    } on NotFoundException catch (e) {
      return ApiFailure(NotFoundFailure(e.message));
    } on NetworkException catch (e) {
      return ApiFailure(NetworkFailure(e.message));
    } on ServerException catch (e) {
      return ApiFailure(ServerFailure(e.message));
    } catch (e) {
      return ApiFailure(UnknownFailure(e.toString()));
    }
  }
}
