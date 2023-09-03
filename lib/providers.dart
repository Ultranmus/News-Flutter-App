import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'enums.dart';

final appNameProvider = Provider((c) => 'GramNews');

final appThemeProvider = StateProvider((ref) => ThemeMode.light);

final newsCategoryProvider = StateProvider<Category>(
  (ref) => Category.business,
);

final mainScreenPresentProvider = StateProvider((ref) => false);

final searchTextProvider = StateProvider((ref) => '');

