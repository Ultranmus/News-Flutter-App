import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gram_news/screens/saved_news_screen.dart';
import 'package:gram_news/widgets/news_list.dart';
import '../apis/api_controller.dart';
import '../enums.dart';
import '../models/news_model.dart';
import '../providers.dart';
import '../widgets/search_bar.dart';

class MainScreen extends ConsumerWidget {
  const MainScreen({Key? key}) : super(key: key);

  Color isSelectedButton(String text, Category category) {
    final String isCategory = category.name.toUpperCase();
    return text == isCategory ? Colors.lightBlueAccent : Colors.pink;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    late Future<List<NewsModel>> newsFuture;
    final String appName = ref.read(appNameProvider);
    newsFuture = ref.watch(newsListProvider).getListByCategory();
    final Category category = ref.watch(newsCategoryProvider);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const SavedNewsScreen()));
          },
          icon: const Icon(
            Icons.my_library_books,
            color: Colors.white,
            size: 30,
          ),
        ),
        leadingWidth: 40,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              appName,
              style: const TextStyle(color: Colors.white),
            ),
            const SizedBox(
              width: 10,
            ),
            const Expanded(child: MySearchBar()),
          ],
        ),
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
              child: Column(
            children: [
              const SizedBox(
                height: 20,
              ),
              Text(
                'CATEGORY ${category.name.toUpperCase()}',
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              const SizedBox(
                height: 10,
              ),
              const Divider(
                color: Colors.grey,
                indent: 20,
                endIndent: 20,
              ),
              const SizedBox(
                height: 10,
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    const SizedBox(
                      width: 10,
                    ),
                    ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            isSelectedButton('BUSINESS', category)),
                      ),
                      onPressed: () {
                        ref
                            .read(newsCategoryProvider.notifier)
                            .update((state) => Category.business);
                      },
                      child: const Text(
                        'BUSINESS',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                          isSelectedButton('SPORTS', category),
                        ),
                      ),
                      onPressed: () {
                        ref
                            .read(newsCategoryProvider.notifier)
                            .update((state) => Category.sports);
                      },
                      child: const Text(
                        'SPORTS',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                          isSelectedButton('FESTIVAL', category),
                        ),
                      ),
                      onPressed: () {
                        ref
                            .read(newsCategoryProvider.notifier)
                            .update((state) => Category.festival);
                      },
                      child: const Text(
                        'FESTIVAL',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            isSelectedButton('TECHNOLOGY', category)),
                      ),
                      onPressed: () {
                        ref
                            .read(newsCategoryProvider.notifier)
                            .update((state) => Category.technology);
                      },
                      child: const Text(
                        'TECHNOLOGY',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              const Divider(
                color: Colors.grey,
                indent: 20,
                endIndent: 20,
              ),
              const SizedBox(
                height: 20,
              ),
            ],
          )),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                return NewsList(newsFuture: newsFuture);
              },
              childCount: 1,
            ),
          ),
        ],
      ),
    );
  }
}
