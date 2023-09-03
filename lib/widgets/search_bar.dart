import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../enums.dart';
import '../providers.dart';

class MySearchBar extends ConsumerStatefulWidget {
  const MySearchBar({Key? key}) : super(key: key);

  @override
  ConsumerState<MySearchBar> createState() => _SearchBarState();
}

class _SearchBarState extends ConsumerState<MySearchBar> {
  final TextEditingController controller = TextEditingController();
  final FocusNode textFieldFocusNode = FocusNode();
  late bool isSwitched;
  var textValue = 'Light Mode';

  bool search = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    controller.dispose();
    textFieldFocusNode.dispose();
  }

  bool isDarkMode() {
    final theme = ref.watch(appThemeProvider);
    if (theme == ThemeMode.dark) {
      return true;
    }
    return false;
  }

  addThemeToSf(String mode) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('theme', mode);
  }

  Future<void> toggleSwitch(bool value) async {
    final newTheme = value ? ThemeMode.dark : ThemeMode.light;
    await addThemeToSf(value ? 'dark' : 'light');
    ref.read(appThemeProvider.notifier).update((state) => newTheme);
  }

  @override
  Widget build(BuildContext context) {
    isSwitched = isDarkMode();
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
        horizontalTitleGap: 10,
        leading: Switch(
          onChanged: toggleSwitch,
          value: isSwitched,
          activeColor: Colors.blue,
          activeTrackColor: Colors.yellow,
          inactiveThumbColor: Colors.redAccent,
          inactiveTrackColor: Colors.orange,
        ),
        title:
            //search bar with animation
            AnimatedContainer(
                height: search ? 40 : 0,
                duration: const Duration(milliseconds: 100),
                child: TextFormField(
                  focusNode: textFieldFocusNode,
                  controller: controller,
                  style:
                      const TextStyle(fontSize: 15, color: Colors.deepPurple),
                  textAlignVertical: TextAlignVertical.bottom,
                  decoration: InputDecoration(
                    isDense: true,
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: search ? Colors.black : Colors.transparent,
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(40),
                    ),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: search ? Colors.black : Colors.transparent,
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(40),
                    ),
                    hintText: 'Search Input',
                  ),
                )),
        trailing: CircleAvatar(
          backgroundColor: Colors.white38,
          child: IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              //if search bar is visible
              if (search) {
                //if search bar text field is not empty
                if (controller.text.trim().isNotEmpty) {
                  //update the searchTextProvider and change category to call apis with searchText as keyword
                  ref
                      .read(searchTextProvider.notifier)
                      .update((state) => controller.text.trim());
                  ref
                      .read(newsCategoryProvider.notifier)
                      .update((state) => Category.search);
                }
                // if not then make it invisible and remove focus
                else {
                  setState(() {
                    search = !search;
                    textFieldFocusNode.unfocus();
                  });
                }
              } else {
                setState(() {
                  search = !search;
                });
              }
            },
          ),
        ),
      ),
    );
  }
}
