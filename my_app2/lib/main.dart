import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:my_app2/auth_page.dart';
import 'package:my_app2/speakers.dart';
import 'package:my_app2/widgets/error_page.dart';
// import 'package:my_app2/ui/shared/colors.dart';
import 'package:my_app2/widgets/load_page.dart';
import 'package:my_app2/widgets/title_page.dart';
// import 'package:my_app2/speakers.dart';
import 'package:page_transition/page_transition.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: OnBoarding(),
    );
  }
}

class OnBoarding extends StatefulWidget {
  const OnBoarding({Key? key}) : super(key: key);

  @override
  _OnBoardingState createState() => _OnBoardingState();
}

class _OnBoardingState extends State<OnBoarding> {
  // final PageController _controller = PageController(initialPage: 0);
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  // bool top = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: FutureBuilder(
      future: _initialization,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          print(snapshot);
          print("a");
          return ErrorPage();
        }
        // Once complete, show your application
        if (snapshot.connectionState == ConnectionState.done) {
          if (FirebaseAuth.instance.currentUser == null) {
            return board_page('assets/images/night-4926430_1920.jpg', context,
                FirebaseAuth.instance.currentUser, null);
          } else {
            return FutureBuilder(
                future:
                    _fetchApiResults(FirebaseAuth.instance.currentUser!.uid),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    print(snapshot.data);
                    if (snapshot.data == true) {
                      return board_page('assets/images/night-4926430_1920.jpg',
                          context, FirebaseAuth.instance.currentUser, true);
                    } else if (snapshot.data == false) {
                      return board_page('assets/images/night-4926430_1920.jpg',
                          context, FirebaseAuth.instance.currentUser, false);
                    } else {
                      return board_page('assets/images/night-4926430_1920.jpg',
                          context, FirebaseAuth.instance.currentUser, null);
                    }
                  }
                  return load_page("anonymous", context);
                });
          }
        }

        return load_page("anonymous", context);
      },
    ));
  }

  Future<bool?> _fetchApiResults(String uid) async {
    var url = Uri.parse("http://192.168.0.45:8000/check/uuid/${uid}");
    print('a');

    final response = await http.get(url);
    print("response.statusCode");
    if (response.statusCode == 200) {
      // print(response.body);
      print('succece');
      Map<String, dynamic> ret = json.decode(utf8.decode(response.bodyBytes));
      if (ret["message"]) {
        return true;
      } else if (!ret["message"]) {
        return false;
      } else {
        return null;
      }
      // return true;

    } else {
      throw Exception('Failed to load API params');
    }
  }
}
