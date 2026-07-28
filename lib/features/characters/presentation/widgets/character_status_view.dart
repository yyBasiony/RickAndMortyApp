import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/resources/app_colors.dart';
import '../../../../core/resources/app_constants.dart';
import '../cubit/characters_cubit.dart';
import '../cubit/characters_state.dart';
import 'character_grid.dart';

class CharacterStatusView extends StatelessWidget {
  const CharacterStatusView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CharactersCubit, CharactersState>(
      builder: (context, state) {
        return switch (state) {
          CharactersInitial() ||
          CharactersLoading() =>
            const Center(child: CircularProgressIndicator(color: AppColors.primary)),
          CharactersEmpty() => const _EmptyStateView(),
          CharactersError(:final message) => _ErrorStateView(message: message),
          CharactersLoaded(:final characters) ||
          CharactersLoadingMore(:final characters) ||
          CharactersExporting(:final characters) ||
          CharactersExportSuccess(:final characters) ||
          CharactersExportError(:final characters) =>
            CharacterGrid(
              characters: characters,
              isLoadingMore: state is CharactersLoadingMore,
            ),
        };
      },
    );
  }
}

class _EmptyStateView extends StatelessWidget {
  const _EmptyStateView();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off, size: 64, color: AppColors.textHint),
          SizedBox(height: 16),
          Text(
            AppConstants.noCharactersFound,
            style: TextStyle(fontSize: 18, color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }
}

class _ErrorStateView extends StatelessWidget {
  final String message;

  const _ErrorStateView({required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(message, style: const TextStyle(color: AppColors.error)),
          const SizedBox(height: 12),
          FilledButton.icon(
            style: FilledButton.styleFrom(backgroundColor: AppColors.primary),
            onPressed: () => context.read<CharactersCubit>().loadCharacters(),
            icon: const Icon(Icons.refresh),
            label: const Text(AppConstants.retry),
          ),
        ],
      ),
    );
  }
}
