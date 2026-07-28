import '../../../../core/error/api_result.dart';
import '../entities/paginated_characters.dart';
import '../repositories/characters_repository.dart';

class GetCharacters {
  final CharactersRepository _repository;

  const GetCharacters(this._repository);

  Future<ApiResult<PaginatedCharacters>> call({
    required int page,
    String? name,
    String? status,
    String? species,
    String? gender,
  }) {
    return _repository.getCharacters(
      page: page,
      name: name,
      status: status,
      species: species,
      gender: gender,
    );
  }
}
