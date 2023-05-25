import 'package:advisory_assessment/routing/home_page.dart';
import 'package:advisory_assessment/routing/start_page.dart';
import 'package:advisory_assessment/util/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  Future<bool> isLoggedIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var isLoggedIn = prefs.getBool("isLoggedIn");
    if (isLoggedIn == true) {
      return true;
    } else {
      return false;
    }
  }

  Future<Widget> getInitialRoute() async {
    bool loggedIn = await isLoggedIn();
    return loggedIn ? const HomePage() : const StartPage();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: AppColors.materialPrimary,
      ),
      home: FutureBuilder<Widget>(
        future: getInitialRoute(),
        builder: (
          BuildContext context,
          AsyncSnapshot<Widget> snapshot,
        ) {
          if (snapshot.hasData) {
            return snapshot.data!;
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}
