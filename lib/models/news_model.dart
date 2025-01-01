class NewsArticle {
  final String title;
  final String description;
  final String urlToImage;
  final String content;

  NewsArticle({
    required this.title,
    required this.description,
    required this.urlToImage,
    required this.content,
  });

  factory NewsArticle.fromJson(Map<String, dynamic> json) {
    return NewsArticle(
      title: json['title'] ?? 'Pas de titre',
      description: json['description'] ?? 'Pas de description',
      urlToImage: json['urlToImage'] ?? '',
      content: json['content'] ?? 'Pas de contenu',
    );
  }
}
