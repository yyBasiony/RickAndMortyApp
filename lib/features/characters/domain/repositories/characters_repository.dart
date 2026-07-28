import '../../../../core/error/api_result.dart';
import '../entities/paginated_characters.dart';

abstract class CharactersRepository {
  Future<ApiResult<PaginatedCharacters>> getCharacters({
    required int page,
    String? name,
    String? status,
    String? species,
    String? gender,
  });
}
