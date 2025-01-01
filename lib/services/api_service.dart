import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/news_model.dart';

class ApiService {
  final String _newsApiKey = 'fbfb43a99e2a4d4d925b7c4900dc338a'; // Replace with your actual key
  final String _newsdataApiKey = 'pub_63565fd85d9d37916306d7180fecdae34fd0d'; // Replace with your actual key
  final String _newsApiBaseUrl = 'https://newsapi.org/v2';
  final String _newsdataBaseUrl = 'https://newsdata.io/api/1';

  Future<List<NewsArticle>> fetchNews({String category = 'general', String country = 'global'}) async {
    try {
      final Uri url = (country == 'global')
          ? Uri.parse('$_newsApiBaseUrl/top-headlines?category=$category&apiKey=$_newsApiKey')
          : Uri.parse('$_newsdataBaseUrl/news?country=$country&category=$category&apikey=$_newsdataApiKey');

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(utf8.decode(response.bodyBytes)); // Properly decode response
        final List articles = data['articles'] ?? data['results'] ?? [];
        return articles.map((article) => NewsArticle.fromJson(article)).toList();
      } else {
        throw Exception('Failed to load news: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}
