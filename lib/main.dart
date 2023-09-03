import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gram_news/providers.dart';
import 'package:gram_news/screens/news_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'apis/api_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final String value = ref.read(appNameProvider);
    final newsFuture = ref.watch(newsListProvider).getListByCategory();
    final appTheme = ref.watch(appThemeProvider);

    getStringValuesSF(ref);

    return MaterialApp(
      title: value,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.blue,
        appBarTheme: const AppBarTheme(color: Colors.blueGrey),
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      darkTheme: ThemeData.dark().copyWith(
          // Dark mode theme configuration
          primaryColor: Colors.teal,
          appBarTheme: const AppBarTheme(color: Colors.black),
          hintColor: Colors.white38,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          scaffoldBackgroundColor: Colors.black26),
      themeMode: appTheme,
      home: NewsScreen(
        newsFuture: newsFuture,
      ),
    );
  }
}

//method for checking if theme is saved in shared preference
//and if exist then updates the appThemeProvider
Future<void> getStringValuesSF(WidgetRef ref) async {
  //theme are saved as string in shared preference like 'light' or 'dark'
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? theme = prefs.getString('theme');
  if (theme != null) {
    final ThemeMode savedTheme =
        (theme == 'dark') ? ThemeMode.dark : ThemeMode.light;
    ref.read(appThemeProvider.notifier).update((currentTheme) {
      return savedTheme; // Update the theme mode state
    });
  }
}
