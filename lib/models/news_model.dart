class NewsModel {
  String? id;
  String? title;
  String? description;
  String? imageUrl;
  String? newsUrl;

  NewsModel(
      {required this.id,
      required this.title,
      required this.description,
      required this.imageUrl,
      required this.newsUrl});

  factory NewsModel.fromJson(Map<String, dynamic> json) {
    return NewsModel(
      id: json['author'] as String?,
      title: json['title'] as String?,
      description: json['description'] as String?,
      imageUrl:
          json['urlToImage'] == null ? 'None' : json['urlToImage'] as String,
      newsUrl: json['url'] as String?,
    );
  }
}
