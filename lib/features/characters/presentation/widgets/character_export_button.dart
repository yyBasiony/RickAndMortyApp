import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:share_plus/share_plus.dart';
import '../../../../core/resources/app_colors.dart';
import '../../../../core/resources/app_constants.dart';
import '../cubit/characters_cubit.dart';
import '../cubit/characters_state.dart';

class CharacterExportButton extends StatelessWidget {
  const CharacterExportButton({super.key});

  Future<void> _shareFile(BuildContext context, String path) async {
    try {
      await Share.shareXFiles(
        [XFile(path)],
        text: AppConstants.shareText,
        subject: AppConstants.shareSubject,
      );
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error sharing file: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CharactersCubit, CharactersState>(
      listenWhen: (previous, current) =>
          current is CharactersExportSuccess || current is CharactersExportError,
      listener: (context, state) {
        final messenger = ScaffoldMessenger.of(context);
        if (state is CharactersExportSuccess) {
          messenger.showSnackBar(
            const SnackBar(
              content: Text(AppConstants.exportSuccess),
              backgroundColor: AppColors.success,
            ),
          );
          _shareFile(context, state.filePath);
        } else if (state is CharactersExportError) {
          messenger.showSnackBar(
            SnackBar(
              content: Text('${AppConstants.exportFailed}${state.message}'),
              backgroundColor: AppColors.error,
            ),
          );
        }
      },
      builder: (context, state) {
        if (state is CharactersExporting) {
          return const Padding(
            padding: EdgeInsets.all(12.0),
            child: SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: AppColors.primary,
              ),
            ),
          );
        }

        return IconButton(
          icon: const Icon(Icons.file_download_outlined, color: AppColors.textPrimary),
          tooltip: 'Export to Excel',
          onPressed: () => context.read<CharactersCubit>().exportToExcel(),
        );
      },
    );
  }
}
