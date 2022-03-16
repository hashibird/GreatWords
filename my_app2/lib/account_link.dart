import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:my_app2/speakers.dart';
// import 'package:my_app2/speakers.dart';
import 'package:my_app2/ui/shared/colors.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';

import 'auth_page.dart';
import 'bottom_bar.dart';

class AccountLink extends StatefulWidget {
  const AccountLink({Key? key}) : super(key: key);

  @override
  _AccountLinkState createState() => _AccountLinkState();
}

class _AccountLinkState extends State<AccountLink> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String user_name = "";
  String email = "";
  String password = "";
  String infoText = "";

  _check() async {
    print(_auth.currentUser);
  }

  _signout() async {
    await _auth.signOut();
    Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      return const Auth_page();
    }));
    //
  }

  // _signInWithAnonymous() async {
  //   await FirebaseAuth.instance.signInAnonymously();
  // }

  // _signin() async {
  //   await FirebaseAuth.instance.signInAnonymously();
  //   print("success");
  // }

  signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    print(googleUser);
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );
    try {
      if (_auth.currentUser!.isAnonymous) {
        final userInfo = await FirebaseAuth.instance.currentUser!
            .linkWithCredential(credential);
        await FirebaseAuth.instance.signInWithCredential(credential);
        await Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) {
            return Bottombar();
          }),
        );
      }
    } on Exception catch (e) {
      print("a");
      // print(_auth.currentUser);
      setState(() {
        infoText =
            "このアカウントはすでに紐づけられています。作成済みのアカウントを使用するにはサインアウトしてからもう一度お願いします！";
      });
      ;
      // await FirebaseAuth.instance.signOut();
      // await FirebaseAuth.instance.signInWithCredential(credential);
    }

    // print(userInfo);
    // Once signed in, return the UserCredential
    // return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  @override
  void initState() {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        print('User is currently signed out!');
      } else {
        print('User is signed in!');
      }
    });
    // _authCheck();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      padding: EdgeInsets.all(15),
      width: MediaQuery.of(context).size.width,
      color: AppColor.secondColor,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        // crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          SizedBox(height: 10),
          Row(
            children: [
              IconButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: Icon(Icons.clear))
            ],
          ),
          Expanded(
            child: Container(),
            flex: 1,
          ),
          Text(
            "現在、匿名ユーザーです",
            style: TextStyle(
                fontSize: 25, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          SizedBox(height: 10),
          // Text(
          //   "",
          //   style: TextStyle(
          //       fontSize: 16, fontWeight: FontWeight.bold, color: Colors.red),
          // ),
          Expanded(child: Container(), flex: 1),
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
          // SizedBox(height: 20),
          // MaterialButton(
          //   onPressed: () async {
          //     try {
          //       // メール/パスワードでユーザー登録
          //       // final FirebaseAuth auth = FirebaseAuth.instance;
          //       // await auth.createUserWithEmailAndPassword(
          //       //   email: email,
          //       //   password: password,
          //       // );
          //       final AuthCredential credential = EmailAuthProvider.credential(
          //           email: email, password: password);
          //       await _auth.currentUser!.linkWithCredential(credential);
          //       // ユーザー登録に成功した場合
          //       // チャット画面に遷移＋ログイン画面を破棄
          //       await Navigator.of(context).pushReplacement(
          //         MaterialPageRoute(builder: (context) {
          //           return Speakers();
          //         }),
          //       );
          //     } catch (e) {
          //       // ユーザー登録に失敗した場合
          //       setState(() {
          //         infoText = "登録に失敗しました：${e.toString()}";
          //       });
          //     }
          //   },
          //   shape:
          //       RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          //   color: AppColor.secondColor,
          //   child: const Text(
          //     "ユーザーを引き継ぐ",
          //     style: TextStyle(
          //         color: Colors.white,
          //         fontSize: 20,
          //         fontWeight: FontWeight.bold),
          //   ),
          // ),
          Text(infoText, style: TextStyle(color: Colors.white)),
          SizedBox(height: 20),
          // Text("OR", style: TextStyle(fontSize: 20)),
          SignInButton(
            Buttons.Google,
            text: "Sign up with Google",
            onPressed: () async {
              signInWithGoogle();
            },
          ),
          Expanded(
            child: Container(),
            flex: 2,
          ),
          MaterialButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (_) {
                  return AlertDialog(
                    title: Text("サインアウトします"),
                    content: Text("アカウントを紐付けしていない場合データが保存されません"),
                    actions: [
                      TextButton(
                        child: Text("OK"),
                        onPressed: () => _signout(),
                      ),
                      TextButton(
                        child: Text("Cancel"),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  );
                },
              );
            },
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
            color: Colors.white,
            child: Container(
              width: 200,
              // color: Colors.grey,
              child: Center(
                child: Text(
                  "サインアウト",
                  style: TextStyle(
                      color: Colors.red,
                      fontSize: 23,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
          SizedBox(height: 20)
        ],
      ),
    ));
  }
}
