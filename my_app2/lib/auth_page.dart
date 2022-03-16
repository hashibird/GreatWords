import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:my_app2/bottom_bar.dart';
import 'package:my_app2/speakers.dart';
// import 'package:my_app2/speakers.dart';
import 'package:my_app2/ui/shared/colors.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:my_app2/user_screens/user_create.dart';

import 'package:http/http.dart' as http;

class Auth_page extends StatefulWidget {
  const Auth_page({Key? key}) : super(key: key);

  @override
  _Auth_pageState createState() => _Auth_pageState();
}

class _Auth_pageState extends State<Auth_page> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _anonymous = true;
  String user_name = "";
  String email = "";
  String password = "";
  String infoText = "";
  bool tapped = false;
  Future<bool> _willPopCallback() async {
    return true;
  }

  _check() async {
    print(_auth.currentUser);
  }

  _signout() async {
    await FirebaseAuth.instance.signOut();
    //
  }

  _signInWithAnonymous() async {
    await FirebaseAuth.instance.signInAnonymously();
    await Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) {
        return UserCreate(_auth.currentUser!.uid);
      }),
    );
  }

  _signin() async {
    await FirebaseAuth.instance.signInAnonymously();
    print("success");
  }

  signInWithGoogle() async {
    debugPrint("sas");
    final GoogleSignInAccount? googleUser = await GoogleSignIn(scopes: [
      'email',
      'https://www.googleapis.com/auth/contacts.readonly',
    ]).signIn();
    // print(googleUser);
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,

    );debugPrint("sass");
    try {
      if (_auth.currentUser == null || _auth.currentUser!.isAnonymous) {
        if (_auth.currentUser?.isAnonymous ?? false) {
          final userInfo = await FirebaseAuth.instance.currentUser!
              .linkWithCredential(credential);
        }
        await FirebaseAuth.instance.signInWithCredential(credential);
        // return "success";
        var ret = await _fetchApiResults();
        if (ret == false) {
          await Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) {
              return Bottombar();
            }),
          );
        } else {
          await Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) {
              return UserCreate(_auth.currentUser!.uid);
            }),
          );
        }
      }
    } on Exception catch (e) {
      // print(_auth.currentUser);
      setState(() {
        infoText = "このユーザーは既に紐づけられています。サインアウトしてからお試しください";
      });
      // return
      // await FirebaseAuth.instance.signOut();
      // await FirebaseAuth.instance.signInWithCredential(credential);
    }

    // print(userInfo);
    // Once signed in, return the UserCredential
    // return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  _signinWithEMail() async {
    try {
      // メール/パスワードでユーザー登録
      final FirebaseAuth auth = FirebaseAuth.instance;
      await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      // ユーザー登録に成功した場合
      // チャット画面に遷移＋ログイン画面を破棄
      await Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) {
          return Speakers();
        }),
      );
    } catch (e) {
      // ユーザー登録に失敗した場合
      setState(() {
        infoText = "登録に失敗しました：${e.toString()}";
      });
    }
  }

  _loginWithEmail() async {
    try {
      // メール/パスワードでログイン
      final FirebaseAuth auth = FirebaseAuth.instance;
      await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      // ログインに成功した場合
      // チャット画面に遷移＋ログイン画面を破棄
      if (auth.currentUser!.emailVerified) {
        await Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) {
            return Bottombar();
          }),
        );
      } else {
        setState(() {
          infoText = "メール認証をしてください。";
        });
      }
    } catch (e) {
      // ログインに失敗した場合
      setState(() {
        infoText = "ログインに失敗しました：${e.toString()}";
      });
    }
  }

  // _authCheck() {
  //   setState(() {
  //     if (_auth.currentUser == null) {
  //       _anonymous = true;
  //     } else if (_auth.currentUser!.isAnonymous) {
  //       _anonymous = false;
  //     } else {
  //       _anonymous = false;
  //     }
  //   });
  //   print(_anonymous);
  // }

  @override
  void initState() {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        print('User is currently signed out!');
      } else {
        print('User is signed in!');
      }
      // _authCheck();
    });
    // _authCheck();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _willPopCallback,
      child: Scaffold(
          body: Container(
        padding: EdgeInsets.all(15),
        width: MediaQuery.of(context).size.width,
        color: AppColor.secondColor,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          // crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(child: Container()),
            Text(
              "ユーザー登録",
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
            SizedBox(height: 20),
            // Container(
            //   child: TextField(
            //     maxLength: 10,
            //     decoration: InputDecoration(
            //       border: OutlineInputBorder(
            //         borderRadius: BorderRadius.circular(10),
            //       ),
            //       icon: Icon(Icons.face),
            //       hintText: "ユーザー名",
            //     ),
            //     onChanged: (String value) {
            //       setState(() {
            //         user_name = value;
            //       });
            //     },
            //   ),
            // ),
            // SizedBox(height: 10),
            // TextField(
            //   decoration: InputDecoration(
            //       border: OutlineInputBorder(
            //         borderRadius: BorderRadius.circular(10),
            //       ),
            //       icon: Icon(Icons.mail_outline),
            //       hintText: "メールアドレス"),
            //   onChanged: (String value) {
            //     setState(() {
            //       email = value;
            //     });
            //   },
            // ),
            // SizedBox(height: 30),
            // TextField(
            //   decoration: InputDecoration(
            //       border: OutlineInputBorder(
            //         borderRadius: BorderRadius.circular(10),
            //       ),
            //       icon: Icon(Icons.security_outlined),
            //       hintText: "パスワード"),
            //   obscureText: true,
            //   onChanged: (String value) {
            //     setState(() {
            //       password = value;
            //     });
            //   },
            // ),
            // SizedBox(height: 10),
            // MaterialButton(
            //   onPressed: () async {
            //     _loginWithEmail();
            //   },
            //   shape: RoundedRectangleBorder(
            //       borderRadius: BorderRadius.circular(30)),
            //   color: AppColor.secondColor,
            //   child: Container(
            //     height: 50,
            //     width: MediaQuery.of(context).size.width,
            //     child: Center(
            //       child: const Text(
            //         "ログイン",
            //         style: TextStyle(
            //             color: Colors.white,
            //             fontSize: 20,
            //             fontWeight: FontWeight.bold),
            //       ),
            //     ),
            //   ),
            // ),
            // SizedBox(height: 20),
            // MaterialButton(
            //   onPressed: () async {
            //     _signinWithEMail();
            //   },
            //   shape: RoundedRectangleBorder(
            //       borderRadius: BorderRadius.circular(30)),
            //   color: AppColor.secondColor,
            //   child: Container(
            //     height: 50,
            //     width: MediaQuery.of(context).size.width,
            //     child: Center(
            //       child: const Text(
            //         "ユーザー登録",
            //         style: TextStyle(
            //             color: Colors.white,
            //             fontSize: 20,
            //             fontWeight: FontWeight.bold),
            //       ),
            //     ),
            //   ),
            // ),
            // Text(infoText),
            // SizedBox(height: 20),
            // Text("OR", style: TextStyle(fontSize: 20)),
            SignInButton(
              Buttons.Google,
              text: "Sign up with Google",
              // shape: ShapeBorder.lerp(a, b, t),
              onPressed: () async {
                signInWithGoogle();
              },
            ),
            Expanded(child: Container()),
            MaterialButton(
              onPressed: () {
                if (tapped) {
                } else {
                  tapped = true;
                  _signInWithAnonymous();
                }
              },
              height: 50,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30)),
              color: AppColor.fifthColor,
              child: Text(
                "登録をスキップ",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 20)
          ],
        ),
      )),
    );
  }

  Future<bool?> _fetchApiResults() async {
    var url = Uri.parse(
        "http://192.168.0.45:8000/check/uuid/${_auth.currentUser!.uid}");
    print('a');

    final response = await http.get(url);
    print("response.statusCode");
    if (response.statusCode == 200) {
      // print(response.body);
      print('succece');
      Map<String, dynamic> ret = json.decode(utf8.decode(response.bodyBytes));
      print(ret["message"]);
      return ret["message"];
    } else {
      throw Exception('Failed to load API params');
    }
  }
}

class ApiResults {
  final results;

  ApiResults({this.results});

  factory ApiResults.fromJson(Map<String, dynamic> json) {
    return ApiResults(
      results: json,
    );
  }
}
