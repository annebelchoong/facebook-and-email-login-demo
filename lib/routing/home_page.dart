import 'dart:convert';

import 'package:advisory_assessment/domain/list.dart';
import 'package:advisory_assessment/routing/start_page.dart';
import 'package:advisory_assessment/service/api_service.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var lists = <Listing>[];

  @override
  void initState() {
    _getList();
    super.initState();
  }

  _getList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var id = prefs.getInt("id");
    var token = prefs.getString("token");
    if (id != null && token != null) {
      CallApi().getData('listing?id=$id&token=$token').then((response) {
        if (response.statusCode == 200) {
          var responseData = json.decode(response.body);
          var listings = responseData['listing'];
          setState(() {
            lists = listings
                .map<Listing>((item) => Listing.fromJson(item))
                .toList();
          });
        } else {
          debugPrint(
              'API request failed with status code: ${response.statusCode}');
        }
      });
    } else {
      const Center(
        child: Text('Facebook logged in'),
      );
    }
  }

  Future<String> _getEmail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var email = prefs.getString("email");
    return email.toString();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Home Page'),
        ),
        drawer: Drawer(
          child: SafeArea(
            child: Column(
              children: [
                const SizedBox(
                  height: 20,
                ),
                const CircleAvatar(
                  radius: 70,
                  child: Icon(
                    Icons.person,
                    size: 70,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: FutureBuilder(
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        return Text(
                          snapshot.data.toString(),
                        );
                      } else {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                    },
                    future: _getEmail(),
                  ),
                ),
                ElevatedButton(
                  onPressed: () async {
                    SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    prefs.clear();
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
                  },
                  child: const Text('Logout'),
                ),
              ],
            ),
          ),
        ),
        body: lists.isEmpty
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : SingleChildScrollView(
                child: Column(
                  children: lists.map((list) {
                    return ListTile(
                      title: Text(list.getName),
                      onTap: () {
                        // toast the clicked item
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("List Name: ${list.getName} \n"
                                "Distance: ${list.getDistance}"),
                          ),
                        );
                      },
                      subtitle: Text(list.getDistance.toString()),
                    );
                  }).toList(),
                ),
              ),
      ),
    );
  }
}
