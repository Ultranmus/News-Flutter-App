import 'dart:async';
import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart';
import '../models/news_model.dart';

final newsApiProvider = Provider((ref) {
  final currentTime = DateTime.now();

// Subtract one month
  final modifiedTime =
      DateTime(currentTime.year, currentTime.month - 1, currentTime.day);

// Format the modified time as desired: "yyyy-MM-dd"
  final formattedTime =
      '${modifiedTime.year}-${modifiedTime.month.toString().padLeft(2, '0')}-${modifiedTime.day.toString().padLeft(2, '0')}';

  return NewsApi(time: formattedTime);
});

class NewsApi {
  final String time;
  NewsApi({required this.time});

  Future<List<NewsModel>> getArticle(String search) async {
    //don't use my api key
    String apiUrl =
        'https://newsapi.org/v2/everything?q=$search&from=$time&sortBy=publishedAt&apiKey=cf225876bbba48b39f0b09705fcc6454';

    try {
      Response res = await get(
        Uri.parse(apiUrl),
      );

      if (res.statusCode == 200) {
        Map json = jsonDecode(res.body);

        List<dynamic> articlesJson = json['articles'];

        List<NewsModel> newsList =
            articlesJson.map((e) => NewsModel.fromJson(e)).toList();
        return newsList;
      }

      // Process the response here
    } catch (error) {
      // Handle other errors
      print('API request error: $error');
    }
    throw ClientException("Resource Not Found");
  }
}
