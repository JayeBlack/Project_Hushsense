import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_constants.dart';

class LanguageScreen extends ConsumerWidget {
  const LanguageScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final languages = [
      {'code': 'en', 'name': 'English (US)'},
      {'code': 'es', 'name': 'Español'},
      {'code': 'fr', 'name': 'Français'},
      {'code': 'de', 'name': 'Deutsch'},
      {'code': 'zh', 'name': '中文'},
      {'code': 'ar', 'name': 'العربية'},
      {'code': 'hi', 'name': 'हिन्दी'},
      {'code': 'pt', 'name': 'Português'},
      {'code': 'ru', 'name': 'Русский'},
      {'code': 'ja', 'name': '日本語'},
    ];
    String selectedCode = 'en';
    return Scaffold(
      backgroundColor: AppConstants.backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back, color: AppConstants.textPrimary),
        ),
        title: const Text(
          'Language',
          style: TextStyle(
            color: AppConstants.textPrimary,
            fontWeight: FontWeight.w600,
            fontFamily: 'Funnel Sans',
          ),
        ),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(AppConstants.paddingL),
        itemCount: languages.length,
        separatorBuilder: (context, i) => const SizedBox(height: 12),
        itemBuilder: (context, i) {
          final lang = languages[i];
          final isSelected = lang['code'] == selectedCode;
          return ListTile(
            leading: const Icon(Icons.language, color: AppConstants.primaryTeal),
            title: Text(lang['name']!, style: const TextStyle(fontFamily: 'Funnel Sans')),
            trailing: isSelected ? const Icon(Icons.check, color: AppConstants.primaryTeal) : null,
            onTap: () {
              // TODO: Change language
            },
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
              side: BorderSide(
                color: isSelected ? AppConstants.primaryTeal : AppConstants.borderColor,
                width: isSelected ? 2 : 1,
              ),
            ),
            tileColor: AppConstants.cardBackground,
            selected: isSelected,
          );
        },
      ),
    );
  }
}
