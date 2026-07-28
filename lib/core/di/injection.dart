import 'package:get_it/get_it.dart';

import '../../features/characters/data/datasources/characters_remote_data_source.dart';
import '../../features/characters/data/repositories/characters_exporter_impl.dart';
import '../../features/characters/data/repositories/characters_repository_impl.dart';
import '../../features/characters/domain/repositories/characters_exporter.dart';
import '../../features/characters/domain/repositories/characters_repository.dart';
import '../../features/characters/domain/usecases/export_characters.dart';
import '../../features/characters/domain/usecases/get_characters.dart';
import '../../features/characters/presentation/cubit/characters_cubit.dart';
import '../api/api_service.dart';
import '../export/excel_export_service.dart';

final getIt = GetIt.instance;

void setupDependencyInjection() {
  getIt.registerLazySingleton<ApiService>(() => ApiService());
  getIt.registerLazySingleton<ExcelExportService>(() => ExcelExportService());

  getIt.registerLazySingleton<CharactersRemoteDataSource>(
    () => CharactersRemoteDataSourceImpl(getIt<ApiService>()),
  );
  getIt.registerLazySingleton<CharactersRepository>(
    () => CharactersRepositoryImpl(getIt<CharactersRemoteDataSource>()),
  );
  getIt.registerLazySingleton<CharactersExporter>(
    () => CharactersExporterImpl(getIt<ExcelExportService>()),
  );

  getIt.registerLazySingleton<GetCharacters>(
    () => GetCharacters(getIt<CharactersRepository>()),
  );
  getIt.registerLazySingleton<ExportCharacters>(
    () => ExportCharacters(getIt<CharactersExporter>()),
  );

  getIt.registerFactory<CharactersCubit>(
    () => CharactersCubit(getIt<GetCharacters>(), getIt<ExportCharacters>()),
  );
}
