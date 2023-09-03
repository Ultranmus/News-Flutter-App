import 'package:flutter/material.dart';
import '../models/news_model.dart';
import 'news_item.dart';

class NewsList extends StatelessWidget {
  final Future<List<NewsModel>> newsFuture;
  const NewsList({Key? key, required this.newsFuture}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<NewsModel>>(
      future: newsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          ); // Show loading indicator
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (snapshot.hasData) {
          final newsList = snapshot.data!;

          return ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: newsList.length,
            itemBuilder: (context, index) {
              final news = newsList[index];
              return NewsItem(
                width: double.infinity,
                imageUrl: news.imageUrl!,
                title: news.title!,
                description: news.description!,
                newsUrl: news.newsUrl!,
              );
            },
          );
        } else {
          return const Text('No data available.');
        }
      },
    );
  }
}
