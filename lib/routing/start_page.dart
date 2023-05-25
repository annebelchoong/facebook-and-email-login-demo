import 'package:advisory_assessment/routing/home_fb_page.dart';
import 'package:advisory_assessment/routing/login_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StartPage extends StatefulWidget {
  const StartPage({super.key});

  @override
  State<StartPage> createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {
  Map userObj = {};

  _loginFB() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    FacebookAuth.instance.login(
      permissions: const ["public_profile", "email", "password"],
    ).then((value) {
      FacebookAuth.instance.getUserData().then((userData) {
        setState(() {
          prefs.setBool("isLoggedInFB", true);
          userObj = userData;
          prefs.setString("email", userObj['email']);
          prefs.setString("password", userObj['password']);
          prefs.setString("name", userObj['name']);
          prefs.setString("picture", userObj['picture']['data']['url']);
        });
      });
    });
    var fbEmail = prefs.get("email");
    var fbPassword = prefs.get("password");
    var fbPic = prefs.get("picture");
    debugPrint("Email: $fbEmail");
    debugPrint("Password: $fbPassword");
    debugPrint("Picture: $fbPic");

    // var data = {
    //   'email': fbEmail,
    //   'password': fbPassword,
    // };

    // var res = await CallApi().postData(data, 'login');
    // var status = res.statusCode;
  }

  _ifUserIsLoggedIn() async {
    final accessToken = await FacebookAuth.instance.accessToken;

    if (accessToken != null && mounted) {
      // user is logged
      // navigate to home page
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) {
            return const HomeFBPage();
          },
        ),
      );
    } else {
      _loginFB();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.5,
                child: Image.asset(
                  "assets/advisory_app_logo.png",
                  scale: 0.5,
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  "Welcome to Advisory App Assessment",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text("Choose a method to log in!"),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      fixedSize: const Size(double.infinity, 50),
                      backgroundColor: const Color(0xFF926A22),
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(30),
                        ),
                      ),
                    ),
                    onPressed: () async {
                      // logout();
                      _ifUserIsLoggedIn();
                      // if (await _loginFB()) {

                      // }
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(
                          Icons.facebook,
                          color: Colors.white,
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          "Facebook",
                          style: TextStyle(
                            fontSize: 17,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      fixedSize: const Size(double.infinity, 50),
                      backgroundColor: const Color(0xFF926A22),
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(30),
                        ),
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return const LoginPage();
                      }));
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(
                          Icons.email,
                          color: Colors.white,
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          "Email",
                          style: TextStyle(
                            fontSize: 17,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
