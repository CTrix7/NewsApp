import 'package:flutter/material.dart';
import '../models/news_model.dart';

class SavedArticlesScreen extends StatelessWidget {
  final List<NewsArticle> savedArticles;
  final void Function(NewsArticle) onUnsave;
  final Locale currentLocale;

  const SavedArticlesScreen({
    Key? key,
    required this.savedArticles,
    required this.onUnsave,
    required this.currentLocale,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_getTranslatedText('saved', currentLocale.languageCode)),
      ),
      body: savedArticles.isEmpty
          ? Center(
              child: Text(
                _getTranslatedText('no_saved_articles', currentLocale.languageCode),
                style: const TextStyle(fontSize: 18, color: Colors.grey),
              ),
            )
          : ListView.builder(
              itemCount: savedArticles.length,
              itemBuilder: (context, index) {
                final article = savedArticles[index];
                return Card(
                  margin: const EdgeInsets.all(8),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 4,
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16),
                    leading: article.urlToImage.isNotEmpty
                        ? Image.network(article.urlToImage, width: 70, fit: BoxFit.cover)
                        : const Icon(Icons.image, size: 40),
                    title: Text(
                      article.title,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(article.description, maxLines: 2, overflow: TextOverflow.ellipsis),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete_outline),
                      onPressed: () => onUnsave(article),
                    ),
                  ),
                );
              },
            ),
    );
  }

  String _getTranslatedText(String key, String languageCode) {
    const translations = {
      'saved': {
        'en': 'Saved Articles',
        'fr': 'Articles Enregistrés',
        'ar': 'المقالات المحفوظة',
      },
      'no_saved_articles': {
        'en': 'No saved articles yet!',
        'fr': 'Aucun article enregistré pour le moment!',
        'ar': 'لا توجد مقالات محفوظة حتى الآن!',
      },
    };

    return translations[key]?[languageCode] ?? key;
  }
}
