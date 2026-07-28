import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/resources/app_colors.dart';
import '../../../../core/resources/app_constants.dart';
import '../cubit/characters_cubit.dart';
import '../widgets/character_export_button.dart';
import '../widgets/character_search_bar.dart';
import '../widgets/character_status_view.dart';
import '../widgets/characters_filter_bar.dart';

class CharactersPage extends StatefulWidget {
  const CharactersPage({super.key});

  @override
  State<CharactersPage> createState() => _CharactersPageState();
}

class _CharactersPageState extends State<CharactersPage> {
  @override
  void initState() {
    super.initState();
    context.read<CharactersCubit>().loadCharacters();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.surface,
        title: const Text(
          AppConstants.appTitle,
          style: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: const [
          CharacterExportButton(),
          SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          const CharacterSearchBar(),
          Container(
            color: AppColors.surface,
            child: CharactersFilterBar(
              onApply: ({status, species, gender}) => context
                  .read<CharactersCubit>()
                  .applyFilters(status: status, species: species, gender: gender),
            ),
          ),
          const Divider(height: 1, color: AppColors.divider),
          const Expanded(
            child: CharacterStatusView(),
          ),
        ],
      ),
    );
  }
}
