import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:my_app2/bottom_bar.dart';
import 'package:my_app2/user_screens/user_create.dart';

import '../speakers.dart';
import '../auth_page.dart';

Widget board_page(
    String imgPath, BuildContext context, User? user, notCreated) {
  TextStyle titleStyle = const TextStyle(
      color: Colors.white, fontSize: 36, fontWeight: FontWeight.bold);
  TextStyle descStyle = const TextStyle(
      color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold);
  TextStyle welcomStyle = const TextStyle(
      color: Colors.white,
      fontSize: 20,
      fontWeight: FontWeight.bold,
      fontFamily: 'poppin');
  bool showAnime = false;
  Future.delayed(const Duration(milliseconds: 2000), () {
    showAnime = true;
  });

  return Scaffold(
    body: Container(
      decoration: BoxDecoration(
        color: Colors.white,
        image: DecorationImage(
          image: AssetImage(imgPath),
          fit: BoxFit.cover,
        ),
      ),
      padding: const EdgeInsets.all(18),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("data"),
          Expanded(child: Container()),
          AnimatedTextKit(
            // totalRepeatCount: 2,
            isRepeatingAnimation: false,
            animatedTexts: [
              TypewriterAnimatedText(
                "Welcome, dear.",
                curve: Curves.easeIn,
                speed: const Duration(milliseconds: 200),
                textStyle: welcomStyle,
              ),
            ],
          ),
          // Text(welcom, style: welcomStyle),
          Container(child: Text("始めましょう！", style: titleStyle)),
          const SizedBox(height: 20),
          Align(
            child: RawMaterialButton(
                onPressed: () {
                  if (user == null) {
                    Navigator.of(context)
                        .push(MaterialPageRoute(builder: (context) {
                      return const Auth_page();
                    }));
                  } else if (notCreated) {
                    Navigator.of(context)
                        .push(MaterialPageRoute(builder: (context) {
                      return UserCreate(user.uid);
                    }));
                  } else {
                    Navigator.of(context)
                        .push(MaterialPageRoute(builder: (context) {
                      return Bottombar();
                    }));
                  }
                },
                fillColor: Colors.orange.withOpacity(0.88),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30)),
                padding:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                child: Text('ココをタップ', style: descStyle)),
          ),
          const SizedBox(height: 50),
        ],
      ),
    ),
  );
}
