import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../models/news_model.dart';
import '../services/api_service.dart';
import 'article_detail_screen.dart';
import 'saved_articles_screen.dart';
import 'settings_screen.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<NewsArticle>> _newsArticles;
  final ApiService _apiService = ApiService();
  String selectedCategory = 'general';
  String selectedCountry = 'global';
  int _currentIndex = 0;
  final List<NewsArticle> _savedArticles = [];
  Locale _currentLocale = const Locale('en', 'US');

  @override
  void initState() {
    super.initState();
    _fetchArticles();
  }

  void _fetchArticles() {
    setState(() {
      _newsArticles = _apiService.fetchNews(
          category: selectedCategory, country: selectedCountry);
    });
  }

  void _saveArticle(NewsArticle article) {
    setState(() {
      if (!_savedArticles.contains(article)) {
        _savedArticles.add(article);
        Fluttertoast.showToast(
          msg: _getTranslatedText('saved') + '!',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.green,
          textColor: Colors.white,
        );
      } else {
        Fluttertoast.showToast(
          msg: _getTranslatedText('already_saved'),
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.orange,
          textColor: Colors.white,
        );
      }
    });
  }

  void _unsaveArticle(NewsArticle article) {
    setState(() {
      _savedArticles.remove(article);
      Fluttertoast.showToast(
        msg: _getTranslatedText('unsaved') + '!',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    });
  }

  void _changeLanguage(Locale locale) {
    setState(() {
      _currentLocale = locale;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screens = [
      buildHomeScreen(context),
      SavedArticlesScreen(
        savedArticles: _savedArticles,
        onUnsave: _unsaveArticle,
        currentLocale: _currentLocale,
      ),
      SettingsScreen(
        currentLocale: _currentLocale,
        onChangeLanguage: _changeLanguage,
      ),
    ];

    return MaterialApp(
      locale: _currentLocale,
      supportedLocales: const [
        Locale('en', 'US'),
        Locale('fr', 'FR'),
        Locale('ar', 'MA'),
      ],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: Scaffold(
        body: screens[_currentIndex],
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          items: [
            BottomNavigationBarItem(
                icon: const Icon(Icons.home),
                label: _getTranslatedText('home')),
            BottomNavigationBarItem(
                icon: const Icon(Icons.bookmark),
                label: _getTranslatedText('saved')),
            BottomNavigationBarItem(
                icon: const Icon(Icons.settings),
                label: _getTranslatedText('settings')),
          ],
        ),
      ),
    );
  }

  String _getTranslatedText(String key) {
    const translations = {
      'home': {'en': 'Home', 'fr': 'Accueil', 'ar': 'الرئيسية'},
      'saved': {'en': 'Saved', 'fr': 'Enregistrés', 'ar': 'المحفوظة'},
      'settings': {'en': 'Settings', 'fr': 'Paramètres', 'ar': 'الإعدادات'},
      'unsave': {'en': 'Unsave', 'fr': 'Supprimer', 'ar': 'إزالة'},
      'already_saved': {
        'en': 'Already saved',
        'fr': 'Déjà enregistré',
        'ar': 'محفوظ بالفعل'
      },
      'unsaved': {'en': 'Unsaved', 'fr': 'Non enregistré', 'ar': 'غير محفوظ'},
      'global_news': {
        'en': 'Global News',
        'fr': 'Actualités Mondiales',
        'ar': 'الأخبار العالمية'
      },
      'general': {'en': 'General', 'fr': 'Général', 'ar': 'عام'},
      'business': {'en': 'Business', 'fr': 'Affaires', 'ar': 'الأعمال'},
      'health': {'en': 'Health', 'fr': 'Santé', 'ar': 'الصحة'},
      'technology': {
        'en': 'Technology',
        'fr': 'Technologie',
        'ar': 'التكنولوجيا'
      },
      'local_news': {
        'en': 'Local News (Morocco)',
        'fr': 'Actualités Locales (Maroc)',
        'ar': 'الأخبار المحلية (المغرب)',
      },
    };

    final languageCode = _currentLocale.languageCode;
    return translations[key]?[languageCode] ?? key;
  }

  Widget buildHomeScreen(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_getTranslatedText('global_news')),
        actions: [
          DropdownButton<String>(
            value: selectedCountry,
            icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
            underline: Container(),
            items: [
              DropdownMenuItem(
                value: 'global',
                child: Text(_getTranslatedText('global_news')),
              ),
              DropdownMenuItem(
                value: 'ma',
                child: Text(_getTranslatedText('local_news')),
              ),
            ],
            onChanged: (value) {
              setState(() {
                selectedCountry = value!;
                _fetchArticles();
              });
            },
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Container(
            color: Colors.indigo.shade50,
            height: 60,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: ['general', 'business', 'health', 'technology']
                  .map((category) => Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedCategory = category;
                              _fetchArticles();
                            });
                          },
                          child: Chip(
                            label: Text(
                              _getTranslatedText(category),
                              style: TextStyle(
                                color: category == selectedCategory
                                    ? Colors.white
                                    : Colors.indigo,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            backgroundColor: category == selectedCategory
                                ? Colors.indigo
                                : Colors.indigo.shade100,
                            elevation: 4,
                          ),
                        ),
                      ))
                  .toList(),
            ),
          ),
        ),
      ),
      body: FutureBuilder<List<NewsArticle>>(
        future: _newsArticles,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return ListView.builder(
              itemCount: 5,
              itemBuilder: (context, index) {
                return Shimmer.fromColors(
                  baseColor: Colors.grey.shade300,
                  highlightColor: Colors.grey.shade100,
                  child: Container(
                    height: 100,
                    margin: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                );
              },
            );
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final articles = snapshot.data ?? [];
          if (articles.isEmpty) {
            return const Center(child: Text('No news available'));
          }

          return ListView.builder(
            itemCount: articles.length,
            itemBuilder: (context, index) {
              final article = articles[index];
              return Card(
                margin: const EdgeInsets.all(8),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                elevation: 4,
                child: ListTile(
                  contentPadding: const EdgeInsets.all(16),
                  leading: article.urlToImage.isNotEmpty
                      ? Image.network(article.urlToImage,
                          width: 70, fit: BoxFit.cover)
                      : const Icon(Icons.image, size: 40),
                  title: Text(
                    article.title,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(article.description,
                      maxLines: 2, overflow: TextOverflow.ellipsis),
                  trailing: IconButton(
                    icon: _savedArticles.contains(article)
                        ? const Icon(Icons.bookmark, color: Colors.green)
                        : const Icon(Icons.bookmark_add_outlined),
                    onPressed: () => _savedArticles.contains(article)
                        ? _unsaveArticle(article)
                        : _saveArticle(article),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            ArticleDetailScreen(article: article),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
