import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gram_news/screens/main_screen.dart';
import 'package:gram_news/widgets/news_item.dart';
import '../models/news_model.dart';
import '../providers.dart';

//Insta news app like horizontal page scroll interface
class NewsScreen extends ConsumerStatefulWidget {
  final Future<List<NewsModel>> newsFuture;
  const NewsScreen({Key? key, required this.newsFuture}) : super(key: key);

  @override
  ConsumerState<NewsScreen> createState() => _NewsScreen();
}

class _NewsScreen extends ConsumerState<NewsScreen> {
  late PageController _pageController;
  int currentPage = 0;
  late bool isMainScreenInStack;

  void goToMainScreen() {
    ref.read(mainScreenPresentProvider.notifier).update((state) => true);

    //This screen is used two times
    //1st was when the app launches it shows latest news and if we navigate to home screen it will be popped from stack and create instance of home screen
    //2nd is inside the home screen we have a  saved screen which also uses NewsScreen but when navigates to home screen ,it create instance of home screen two times
    //so to act differently when move to home screen differently we set a provider and check if the screen is at time of launch or it is used inside saved screen
    if (!isMainScreenInStack) {
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) {
            return const MainScreen();
          },
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            var begin = const Offset(0.0, -1.0); // Start from above the screen
            var end = Offset.zero; // End at the original position
            var curve = Curves.easeInOut;
            var tween =
                Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
            var offsetAnimation = animation.drive(tween);

            return SlideTransition(
              position: offsetAnimation,
              child: child,
            );
          },
          transitionDuration: const Duration(milliseconds: 400),
        ),
      );
    } else {
      Navigator.of(context).pop();
    }
  }

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    // getStringValuesSF();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    isMainScreenInStack = ref.read(mainScreenPresentProvider);
    return Scaffold(
      body: FutureBuilder<List<NewsModel>>(
        future: widget.newsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
            // Show loading indicator
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else if (snapshot.hasData) {
            final newsList = snapshot.data!;

            if (snapshot.data!.isEmpty) {
              Navigator.pop(context);
              Fluttertoast.showToast(
                  msg: "Nothing saved",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.CENTER,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Colors.red,
                  textColor: Colors.white,
                  fontSize: 16.0);
            }

            return PageView.builder(
              controller: _pageController,
              itemCount: newsList.length,
              onPageChanged: (index) {
                currentPage = index;

                // Preload the image for the next page
                if (currentPage + 1 < newsList.length) {
                  final nextImageUrl = newsList[currentPage + 1].imageUrl;
                  precacheImage(NetworkImage(nextImageUrl!), context);
                }
              },
              itemBuilder: (context, index) {
                final news = newsList[index];

                return NewsItem(
                  width: width,
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
      ),
      floatingActionButton: CircleAvatar(
        backgroundColor: Colors.white,
        child: IconButton(
          icon: const Icon(Icons.close),
          onPressed: goToMainScreen,
          splashColor: Colors.grey,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
    );
  }
}
