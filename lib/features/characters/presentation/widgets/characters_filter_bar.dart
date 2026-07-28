import 'package:flutter/material.dart';
import '../../../../core/resources/app_colors.dart';
import '../../../../core/resources/app_constants.dart';

class CharactersFilterBar extends StatefulWidget {
  final void Function({String? status, String? species, String? gender})
      onApply;

  const CharactersFilterBar({super.key, required this.onApply});

  @override
  State<CharactersFilterBar> createState() => _CharactersFilterBarState();
}

class _CharactersFilterBarState extends State<CharactersFilterBar> {
  String? _status;
  String? _gender;
  String? _species;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            _buildFilterChip(
              label: 'Status',
              value: _status,
              items: AppConstants.statuses,
              onChanged: (val) => setState(() {
                _status = val;
                _apply();
              }),
            ),
            const SizedBox(width: 8),
            _buildFilterChip(
              label: 'Gender',
              value: _gender,
              items: AppConstants.genders,
              onChanged: (val) => setState(() {
                _gender = val;
                _apply();
              }),
            ),
            const SizedBox(width: 8),
            _buildFilterChip(
              label: 'Species',
              value: _species,
              items: AppConstants.speciesList,
              onChanged: (val) => setState(() {
                _species = val;
                _apply();
              }),
            ),
            if (_status != null || _gender != null || _species != null)
              IconButton(
                onPressed: () => setState(() {
                  _status = null;
                  _gender = null;
                  _species = null;
                  _apply();
                }),
                icon: const Icon(Icons.clear_all, color: AppColors.error),
                tooltip: 'Clear Filters',
              ),
          ],
        ),
      ),
    );
  }

  void _apply() {
    widget.onApply(status: _status, gender: _gender, species: _species);
  }

  Widget _buildFilterChip({
    required String label,
    required String? value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return PopupMenuButton<String>(
      onSelected: onChanged,
      itemBuilder: (context) => items
          .map((item) => PopupMenuItem(
                value: item,
                child: Text(item),
              ))
          .toList(),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: value != null ? AppColors.primary.withOpacity(0.1) : AppColors.background,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: value != null ? AppColors.primary : AppColors.border,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              value ?? label,
              style: TextStyle(
                fontSize: 13,
                color: value != null ? AppColors.primary : AppColors.textSecondary,
                fontWeight: value != null ? FontWeight.bold : FontWeight.normal,
              ),
            ),
            const SizedBox(width: 4),
            Icon(
              Icons.arrow_drop_down,
              size: 18,
              color: value != null ? AppColors.primary : AppColors.textSecondary,
            ),
          ],
        ),
      ),
    );
  }
}
