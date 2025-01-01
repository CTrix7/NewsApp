import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  final Locale currentLocale;
  final void Function(Locale) onChangeLanguage;

  const SettingsScreen({
    Key? key,
    required this.currentLocale,
    required this.onChangeLanguage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_getTranslatedText('settings', currentLocale.languageCode)),
      ),
      body: ListView(
        children: [
          ListTile(
            title: const Text('Language'),
            subtitle: Text(_getLanguageName(currentLocale.languageCode)),
            trailing: const Icon(Icons.language),
            onTap: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Select Language'),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _buildLanguageOption(context, 'English', const Locale('en', 'US')),
                      _buildLanguageOption(context, 'French', const Locale('fr', 'FR')),
                      _buildLanguageOption(context, 'Arabic', const Locale('ar', 'MA')),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildLanguageOption(BuildContext context, String language, Locale locale) {
    return RadioListTile(
      title: Text(language),
      value: locale,
      groupValue: currentLocale,
      onChanged: (value) {
        onChangeLanguage(value!);
        Navigator.pop(context); // Close the dialog
      },
    );
  }

  String _getTranslatedText(String key, String languageCode) {
    const translations = {
      'settings': {
        'en': 'Settings',
        'fr': 'Paramètres',
        'ar': 'الإعدادات',
      },
    };

    return translations[key]?[languageCode] ?? key;
  }

  String _getLanguageName(String languageCode) {
    switch (languageCode) {
      case 'en':
        return 'English';
      case 'fr':
        return 'French';
      case 'ar':
        return 'Arabic';
      default:
        return 'Unknown';
    }
  }
}
