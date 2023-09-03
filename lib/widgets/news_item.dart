import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gram_news/database/sql_helper.dart';
import '../screens/web_view_screen.dart';

class NewsItem extends ConsumerStatefulWidget {
  final double width;
  final String imageUrl;
  final String title;
  final String description;
  final String newsUrl;

  const NewsItem({
    Key? key,
    required this.width,
    required this.imageUrl,
    required this.title,
    required this.description,
    required this.newsUrl,
  }) : super(key: key);

  @override
  ConsumerState<NewsItem> createState() => _NewsItem();
}

class _NewsItem extends ConsumerState<NewsItem> {
  //method to save news in local database
  Future<void> saveNews(SQLHelper db, bool saved) async {
    if (saved) {
      Fluttertoast.showToast(
          msg: "Already Saved",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.SNACKBAR,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    } else {
      await db.createItem(
          widget.title, widget.description, widget.imageUrl, widget.newsUrl);
      await Fluttertoast.showToast(
          msg: "News Saved",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.SNACKBAR,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
      setState(() {
        saved = true;
      });
    }
  }

  //method to open webview with the news url link
  void readMore(BuildContext context) {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            WebViewScreen(url: widget.newsUrl, title: widget.title),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(0.0, 1.0);
          const end = Offset.zero;
          const curve = Curves.easeInOut;
          var tween =
              Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
          var offsetAnimation = animation.drive(tween);
          return SlideTransition(position: offsetAnimation, child: child);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final db = ref.read(databaseProvider);

    bool saved = false;

    return SafeArea(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CachedNetworkImage(
                fit: BoxFit.cover,
                height: 300,
                width: widget.width,
                imageUrl: widget.imageUrl,
                placeholder: (context, url) => const Center(
                  child: CircularProgressIndicator(),
                ),
                errorWidget: (context, url, error) => const Icon(
                  Icons.image_not_supported,
                  size: 70,
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.title,
                      maxLines: 5,
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      widget.description,
                      maxLines: 5,
                    ),
                  ],
                ),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                      tooltip: 'Save',
                      onPressed: () => saveNews(db, saved),
                      icon:

                          //this reads if such news already exist in local database using title and if it exist then update the icon and set saved as true
                          FutureBuilder(
                              future: db.getItem(widget.title),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return const Icon(Icons
                                      .save_alt_outlined); // Display a loading indicator.
                                } else if (snapshot.hasError) {
                                  saved = false;
                                  return const Icon(Icons.save_alt_outlined);
                                } else {
                                  saved = true;
                                  return const Icon(Icons.close);
                                }
                              })),
                  const SizedBox(
                    width: 10,
                  ),
                  ElevatedButton(
                      onPressed: () => readMore(context),
                      child: const Text('Read more...')),
                  const SizedBox(
                    width: 10,
                  ),
                ],
              ),
              const SizedBox(
                height: 30,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
