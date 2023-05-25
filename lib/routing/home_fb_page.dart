import 'package:advisory_assessment/routing/start_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeFBPage extends StatefulWidget {
  const HomeFBPage({super.key});

  @override
  State<HomeFBPage> createState() => _HomeFBPageState();
}

class _HomeFBPageState extends State<HomeFBPage> {
  var data = {};
  _getDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var email = prefs.get("email");
    var picture = prefs.get("picture");
    setState(() {
      data = {
        "email": email,
        "picture": picture,
      };
    });
  }

  _logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    FacebookAuth.instance.logOut().then((value) {
      setState(() {
        prefs.clear();
      });
    });
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) {
            return const StartPage();
          },
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Home Page for Facebook'),
          actions: [
            IconButton(
              onPressed: () {
                _logout();
              },
              icon: const Icon(Icons.logout),
            ),
          ],
        ),
        body: FutureBuilder(
          future: _getDetails(),
          builder: (context, snapshot) {
            return Center(
              child: Column(
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                    width: 200,
                    height: 200,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: NetworkImage(data['picture']),
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(data['email']),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
