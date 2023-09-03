import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gram_news/database/sql_helper.dart';
import 'package:gram_news/models/news_model.dart';
import 'package:gram_news/screens/news_screen.dart';

class SavedNewsScreen extends ConsumerWidget {
  const SavedNewsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //call all saved news from database and passed to NewsScreen()
    final Future<List<NewsModel>>? data = ref.read(databaseProvider).getItems();
    return NewsScreen(
      newsFuture: data!,
    );
  }
}
