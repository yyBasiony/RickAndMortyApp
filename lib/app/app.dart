import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../core/resources/app_colors.dart';
import '../core/resources/app_routes.dart';
import '../features/characters/presentation/cubit/characters_cubit.dart' show CharactersCubit;

import '../core/di/injection.dart';
import '../features/characters/presentation/pages/characters_page.dart';
import '../features/splash/splash_screen.dart';

class RickAndMortyApp extends StatelessWidget {
  const RickAndMortyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Rick and Morty',
      theme: ThemeData(
        colorSchemeSeed: AppColors.primary,
        useMaterial3: true,
        scaffoldBackgroundColor: AppColors.background,
      ),
      initialRoute: AppRoutes.splash,
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case AppRoutes.splash:
            return MaterialPageRoute(builder: (_) => const SplashScreen());
          case AppRoutes.characters:
            return MaterialPageRoute(
              builder: (_) => BlocProvider(
                create: (_) => getIt<CharactersCubit>(),
                child: const CharactersPage(),
              ),
            );
          default:
            return MaterialPageRoute(
              builder: (_) => const Scaffold(
                body: Center(child: Text('Error: Unknown route')),
              ),
            );
        }
      },
    );
  }
}
