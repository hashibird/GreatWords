import 'dart:convert';
import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_app2/account_link.dart';
import 'package:my_app2/ui/shared/colors.dart';
import 'package:my_app2/great_word.dart';
import 'package:my_app2/widgets/select_content.dart';

import 'package:http/http.dart' as http;

import 'auth_page.dart';

class Speakers extends StatefulWidget {
  final String title;
  final String url;
  final bool home;
  Speakers(
      {this.title = "名言・格言",
      this.url = "http://192.168.0.45:8000/get/speakers/",
      this.home = true,
      Key? key})
      : super(key: key);

  @override
  _SpeakersState createState() => _SpeakersState();
}

class _SpeakersState extends State<Speakers> {
  // int _selectedIndex = 0;
  late Future<ApiResults> futureApiResults;
  Map<String, dynamic> _details = {};
  List _categories = [];
  bool _show_detail = false;

  final FirebaseAuth _user = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    getCategoryData();
    futureApiResults = _fetchApiResults();
  }

  getCategoryData() async {
    Uri url = Uri.parse("http://192.168.0.45:8000/get/categories/");
    http.Response response = await http.get(url);
    if (response.statusCode == 200) {
      // print(response.body);
      _categories = json.decode(utf8.decode(response.bodyBytes));
    } else {}
  }

  void _change_show_detail(bool b) {
    setState(() {
      _show_detail = b;
    });
  }

  void _signout() async {
    await _user.signOut();
    Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      return const Auth_page();
    }));
  }

  Widget build(BuildContext context) {
    return _user != null
        ? WillPopScope(
            onWillPop: _willPopCallback,
            child: Scaffold(
                drawer: widget.home
                    ? Drawer(
                        child: drawer(context),
                        // elevation: 1,
                      )
                    : null,
                // appBar: widget.home
                //     ? AppBar(
                //         backgroundColor: AppColor.firstColor,
                //         // automaticallyImplyLeading: false,
                //       )
                //     : null,
                backgroundColor: Colors.white,
                body: FutureBuilder<ApiResults>(
                  future: futureApiResults,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      // print(snapshot.data!.results);
                      List speakerJson = snapshot.data?.results;
                      print(speakerJson);
                      return speakers(speakerJson, context, _categories);
                    } else if (snapshot.hasError) {
                      return Text("${snapshot.error}");
                    }
                    return const Center(child: CircularProgressIndicator());
                  },
                )),
          )
        : Container();
  }

  Container drawer(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Your User ID",
            style: TextStyle(fontSize: 25),
          ),
          SizedBox(height: 10),
          Container(
              height: 30,
              width: MediaQuery.of(context).size.width / 1.3,
              decoration: BoxDecoration(
                  border: Border.all(color: AppColor.firstColor, width: 2.5)),
              child: Center(
                  child: Text(
                "${_user.currentUser?.uid ?? "なし"}",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ))),
          SizedBox(height: 25),
          MaterialButton(
            onPressed: () {
              showDialog(
                context: context,
                // barrierDismissible: false,
                builder: (_) {
                  return AlertDialog(
                    title: Text("サインアウトします"),
                    content: _user.currentUser!.isAnonymous
                        ? Text("アカウントを紐付けしていない場合データが保存されません")
                        : Text("OKを押してサインアウトします。"),
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
              // _signout();
            },
            child: Text("サインアウト",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            color: Colors.red,
          ),
          _user.currentUser!.isAnonymous
              ? MaterialButton(
                  onPressed: () {
                    Navigator.of(context)
                        .push(MaterialPageRoute(builder: (context) {
                      return const AccountLink();
                    }));
                  },
                  child: Text("正式なアカウントへリンクする",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.bold)),
                  color: AppColor.secondColor,
                )
              : Container(),
        ],
      ),
    );
  }

  Scaffold speakers(
      List<dynamic> speakerJson, BuildContext context, List categories) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            speakerJson = _shuffle(speakerJson);
          });
        },
        backgroundColor: Color(0xFFF99F48),
        child: const Icon(
          Icons.shuffle,
          color: Colors.white,
          size: 30,
        ),
      ),
      body: Container(
        padding:
            widget.home ? EdgeInsets.only(top: 100) : EdgeInsets.only(top: 50),
        child: Stack(children: [
          Container(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  widget.home
                      ? Container()
                      : Row(
                          children: [
                            IconButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                icon: Icon(Icons.arrow_back_ios_new))
                          ],
                        ),
                  SizedBox(
                    height: 80,
                    child: Center(
                      child: Text(
                        "〜${widget.title}〜",
                        style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            color: AppColor.fifthColor),
                      ),
                    ),
                  ),
                  Divider(
                    height: 5,
                    color: AppColor.fifthColor,
                  ),

                  Container(
                    height: 80,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) {
                                    return Speakers(
                                      title: "ユーザー制作",
                                      url: "http://192.168.0.45:8000/get/users",
                                      home: false,
                                    );
                                  },
                                ),
                              );
                            },
                            child: Container(
                              margin: EdgeInsets.only(left: 20),
                              height: 50,
                              width: 150,
                              decoration: BoxDecoration(
                                  color: Colors.black,
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: [
                                    BoxShadow(
                                        offset: Offset(1, 1), blurRadius: 5)
                                  ]),
                              child: Center(
                                child: Text("ユーザー制作",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold)),
                              ),
                            ),
                          ),
                          for (int i = 0; i < categories.length; i++)
                            GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) {
                                      return Speakers(
                                        title: categories[i]["category_name"],
                                        url:
                                            "http://192.168.0.45:8000/get/speaker/category_id/${categories[i]["id"]}",
                                        home: false,
                                      );
                                    },
                                  ),
                                );
                              },
                              child: Container(
                                margin: EdgeInsets.only(left: 40),
                                height: 50,
                                width: 150,
                                decoration: BoxDecoration(
                                    color: Colors.black,
                                    borderRadius: BorderRadius.circular(20),
                                    boxShadow: [
                                      BoxShadow(
                                          offset: Offset(1, 1), blurRadius: 5)
                                    ]),
                                child: Center(
                                  child: Text(categories[i]["category_name"],
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold)),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                  Row(
                    // crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      SizedBox(width: 8),
                      const Text(
                        "※人物コンテンツ長押しで詳細表示",
                        style: TextStyle(
                            color: Colors.grey,
                            // fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                      Expanded(child: Container())
                    ],
                  ),
                  SizedBox(height: 20),
                  for (int i = 0; i < speakerJson.length; i++)
                    GestureDetector(
                      onLongPress: () {
                        _details = speakerJson[i];
                        _change_show_detail(true);
                      },
                      onTap: () {
                        // print(imagePath[i]["urlJson"]);
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) {
                              return CntentsPage(
                                speakerJson[i]["id"],
                                speakerJson[i]["speaker_name"],
                                speakerJson[i]["speaker_name_eng"],
                              );
                            },
                          ),
                        );
                      },
                      child: Container(
                        height: 120,
                        width: MediaQuery.of(context).size.width,
                        padding: const EdgeInsets.only(left: 10, right: 10),
                        margin: const EdgeInsets.only(
                            bottom: 30, right: 10, left: 10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          // color: AppColor.fouthColor,
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                                color: AppColor.fifthColor.withOpacity(0.8),
                                offset: const Offset(3, 3),
                                blurRadius: 10)
                          ],
                          // image: DecorationImage(
                          //     image: AssetImage(speakerJson[i]["img_url_path"]),
                          //     alignment: Alignment.bottomRight),
                        ),
                        child: Column(
                          // mainAxisAlignment: MainAxisAlignment.center,
                          // crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 20),
                            Container(
                              // color: AppColor.firstColor,
                              child: Text(
                                speakerJson[i]["speaker_name"],
                                style: const TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text("-" + speakerJson[i]["speaker_name_eng"] + "-",
                                style: const TextStyle(fontSize: 20)),
                            Expanded(child: Container()),
                            // Align(
                            //   alignment: Alignment.bottomLeft,
                            //   child: GestureDetector(
                            //     onTap: () {
                            //       Navigator.of(context)
                            //           .push(MaterialPageRoute(builder: (context) {
                            //         return HomePage(
                            //             title: speakerJson[i]["category_name"],
                            //             url:
                            //                 "http://192.168.0.45:8000/get/speaker/category_id/" +
                            //                     speakerJson[i]["category_id"]
                            //                         .toString(),
                            //             home: false);
                            //       }));
                            //     },
                            //     child: Container(
                            //       height: 28,
                            //       width: 140,
                            //       decoration: BoxDecoration(
                            //           color: AppColor.secondColor,
                            //           borderRadius: BorderRadius.circular(10)),
                            //       child: Center(
                            //         child: Text(
                            //           speakerJson[i]["category_name"],
                            //           style: const TextStyle(
                            //               fontSize: 20,
                            //               color: Colors.white,
                            //               fontWeight: FontWeight.bold),
                            //         ),
                            //       ),
                            //     ),
                            //   ),
                            // ),
                            const SizedBox(
                              height: 20,
                            ),
                          ],
                        ),
                      ),
                    ),
                  // const Text('dataa', style: TextStyle(fontSize: 30)),
                ],
              ),
            ),
          ),
          _show_detail ? detailContent(context) : Container()
        ]),
      ),
    );
  }

  Widget detailContent(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
              color: AppColor.fifthColor.withOpacity(0.7),
              offset: const Offset(3, 3),
              blurRadius: 50),
          BoxShadow(
              color: AppColor.fifthColor.withOpacity(0.7),
              offset: const Offset(-3, -3),
              blurRadius: 50)
        ],
      ),
      child: Container(
        padding: EdgeInsets.all(8),
        child: Column(
          children: [
            Container(
              height: 140,
              width: MediaQuery.of(context).size.width,
              // padding: const EdgeInsets.only(left: 10),
              margin: const EdgeInsets.only(top: 25),
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30)),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                      color: AppColor.thirdColor,
                      offset: const Offset(3, 3),
                      blurRadius: 30)
                ],
                image: DecorationImage(
                    image: AssetImage("assets/images/anonymous.png"),
                    alignment: Alignment.bottomRight),
              ),
              child: Column(
                // mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  IconButton(
                      onPressed: () {
                        _change_show_detail(false);
                      },
                      icon: Icon(
                        Icons.clear,
                        size: 40,
                        color: AppColor.fifthColor,
                      )),
                  // const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Column(
                      children: [
                        Text(_details["speaker_name"],
                            style: const TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 5),
                        Text("-" + _details["speaker_name_eng"] + "-",
                            style: const TextStyle(fontSize: 20)),
                        // Text(_details["category_name"])
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.all(18),
                // height: 400,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    color: AppColor.fifthColor.withOpacity(0.95),
                    borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(30),
                        bottomRight: Radius.circular(30))),
                child: SingleChildScrollView(
                  child: Column(
                    // crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "カテゴリ：${_details["category_name"]}",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 30,
                            fontWeight: FontWeight.bold),
                      ),
                      const Divider(height: 10, color: Colors.white),
                      const SizedBox(height: 10),
                      Text(
                        _details['speaker_detail'],
                        style:
                            const TextStyle(color: Colors.white, fontSize: 25),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<bool> _willPopCallback() async {
    return true;
  }

  List _shuffle(List items) {
    var random = new Random();
    for (var i = items.length - 1; i > 0; i--) {
      var n = random.nextInt(i + 1);
      var temp = items[i];
      items[i] = items[n];
      items[n] = temp;
    }
    return items;
  }

  Future<ApiResults> _fetchApiResults() async {
    var url = Uri.parse(widget.url);

    final response = await http.get(url);
    print(response);
    if (response.statusCode == 200) {
      print(ApiResults.fromJson(json.decode(utf8.decode(response.bodyBytes))));
      print("a");
      return ApiResults.fromJson(json.decode(utf8.decode(response.bodyBytes)));
    } else {
      throw Exception('Failed to load API params');
    }
  }
}

class ApiResults {
  final results;

  ApiResults({this.results});

  factory ApiResults.fromJson(List<dynamic> json) {
    return ApiResults(
      results: json,
    );
  }
}
