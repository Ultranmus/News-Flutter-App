import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gram_news/models/news_model.dart';
import 'package:gram_news/providers.dart';
import '../enums.dart';
import 'api_repository.dart';

final newsListProvider = Provider((ref) {
  Category category = ref.watch(newsCategoryProvider);
  NewsApi api = ref.read(newsApiProvider);
  String searchText = ref.watch(searchTextProvider);
  return ApiController(category: category, api: api, searchText: searchText);
});

class ApiController {
  final Category category;
  final NewsApi api;
  final String searchText;
  ApiController({
    required this.category,
    required this.api,
    required this.searchText,
  });

  //this method watches over newsCategoryProvider and perform api call accordingly
  Future<List<NewsModel>> getListByCategory() async {
    switch (category) {
      case Category.business:
        return api.getArticle('business');
      case Category.sports:
        return api.getArticle('sports');
      case Category.festival:
        return api.getArticle('festival');
      case Category.technology:
        return api.getArticle('technology');
      case Category.search:
        if (searchText.isNotEmpty) {
          return api.getArticle(searchText);
        }
        return api.getArticle('tesla');
    }
  }
}
