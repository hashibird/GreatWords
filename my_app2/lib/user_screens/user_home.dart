import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:my_app2/api_json.dart';
import 'package:my_app2/comments.dart';
import 'package:my_app2/great_word.dart';
import 'package:my_app2/ui/shared/colors.dart';
import 'package:my_app2/user_screens/create_word.dart';

class UserHome extends StatefulWidget {
  const UserHome({Key? key}) : super(key: key);

  @override
  _UserHomeState createState() => _UserHomeState();
}

class _UserHomeState extends State<UserHome> {
  FirebaseAuth _user = FirebaseAuth.instance;
  late Future<ApiResults> futureApiResults;
  bool showFlg = true;
  bool showProfile = true;
  bool showDetail = false;
  String _word = "";
  String _name = "";
  String _detail = "";
  bool jsonInit = true;
  var _controller = TextEditingController();
  var _controllerName = TextEditingController();
  var _controllerDetail = TextEditingController();
  Map<String, dynamic> userJson = {};

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    futureApiResults = _fetchApiResults(_user);
  }

  _showChange(bool flg) {
    setState(() {
      showFlg = flg;
    });
  }

  _createfetchApiResults(int id, String uid) async {
    var url = Uri.parse("http://192.168.0.45:8000/create/user/great_word/");
    var request = Request(word: _word, speaker_id: id, uuid: uid);
    final response = await http.post(url,
        body: json.encode(request.toJson()),
        headers: {"Content-Type": "application/json"});
    if (response.statusCode == 200) {
      userJson = await json.decode(utf8.decode(response.bodyBytes));
      setState(() {});
    } else {
      throw Exception('Failed');
    }
  }

  _updatefetchApiResults(int id, String uid) async {
    var url = Uri.parse("http://0.0.0.0:8000/update/user/name_detail/");
    var request =
        Update(speaker_id: id, name: _name, detail: _detail, uuid: uid);
    final response = await http.post(url,
        body: json.encode(request.toJson()),
        headers: {"Content-Type": "application/json"});
    if (response.statusCode == 200) {
      userJson = await json.decode(utf8.decode(response.bodyBytes));
      setState(() {});
    } else {
      throw Exception('Failed');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<ApiResults>(
      future: futureApiResults,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          // print(snapshot.data!.results);
          if (jsonInit) {
            userJson = snapshot.data?.results;
            jsonInit = false;
          }

          return userHome();
        } else if (snapshot.hasError) {
          return Text("${snapshot.error}");
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }

  Scaffold userHome() {
    return Scaffold(
      floatingActionButton: showDetail
          ? FloatingActionButton(
              backgroundColor: Colors.orange,
              onPressed: () {
                _controllerName.clear();
                _controllerDetail.clear();
                _updatefetchApiResults(userJson["id"], userJson["uuid"]);
                setState(() {
                  showDetail = false;
                });
              },
              child: Icon(Icons.send),
            )
          : FloatingActionButton(
              onPressed: () {
                setState(() {
                  showProfile = !showProfile;
                });
              },
              child:
                  showProfile ? Icon(Icons.create_rounded) : Icon(Icons.face),
            ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        color: AppColor.secondColor,
        child: Stack(children: [
          Column(
            children: [
              SizedBox(height: 50),
              Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                IconButton(
                    onPressed: () {
                      setState(() {
                        showDetail = !showDetail;
                      });
                    },
                    icon: showDetail
                        ? Icon(Icons.clear)
                        : Icon(Icons.description_outlined))
              ]),
              showProfile
                  ? Container(
                      height: 200,
                      width: MediaQuery.of(context).size.width,
                      // decoration: BoxDecoration(color: AppColor.secondColor),
                      child: Column(
                        // mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(flex: 2, child: Container()),
                          Container(
                            height: 100,
                            width: 100,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(50),
                                image: DecorationImage(
                                    image:
                                        AssetImage("assets/images/cloud.png"))),
                          ),
                          SizedBox(height: 20),
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) {
                                    return CntentsPage(userJson["id"],
                                        userJson["speaker_name"], "");
                                  },
                                ),
                              );
                            },
                            child: Container(
                              padding: EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                  color: AppColor.secondColor,
                                  boxShadow: [
                                    BoxShadow(
                                        offset: Offset(4, 4),
                                        blurRadius: 10,
                                        color: AppColor.firstColor)
                                  ]),
                              child: Text(
                                userJson["speaker_name"],
                                style: TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 5),
                          Expanded(flex: 1, child: Container()),
                        ],
                      ))
                  : Column(
                      children: [
                        Container(
                          height: 140,
                          padding: EdgeInsets.all(10),
                          child: TextField(
                            maxLines: 3,
                            style: TextStyle(color: Colors.black),
                            controller: _controller,
                            decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.white,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                icon: Icon(
                                  Icons.mark_chat_read_outlined,
                                  color: Colors.white,
                                ),
                                hintText: "好きな名言を投稿..."),
                            onChanged: (String value) {
                              setState(() {
                                _word = value;
                              });
                            },
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            MaterialButton(
                              color: Colors.white,
                              onPressed: () {
                                if (_word == "") {
                                } else {
                                  _createfetchApiResults(
                                      userJson["id"], userJson["uuid"]);
                                  _word = "";
                                  _controller.clear();
                                }
                              },
                              child: Text("送信"),
                            ),
                            SizedBox(width: 20)
                          ],
                        )
                      ],
                    ),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(50),
                          topRight: Radius.circular(50))),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                              child: GestureDetector(
                            onTap: () {
                              _showChange(true);
                            },
                            child: Container(
                              height: 60,
                              decoration: BoxDecoration(
                                  color: showFlg
                                      ? Colors.grey
                                      : Colors.grey.withOpacity(0.5),
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(50))),
                              child: Center(
                                child: Icon(Icons.create_outlined),
                              ),
                            ),
                          )),
                          Expanded(
                              child: GestureDetector(
                            onTap: () {
                              _showChange(false);
                            },
                            child: Container(
                              height: 60,
                              decoration: BoxDecoration(
                                  color: showFlg
                                      ? Colors.grey.withOpacity(0.5)
                                      : Colors.grey,
                                  borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(50))),
                              child: Center(
                                child: Icon(Icons.comment),
                              ),
                            ),
                          )),
                        ],
                      ),
                      Expanded(
                        child: SingleChildScrollView(
                          child: showFlg
                              ? Column(
                                  children: [
                                    Row(
                                      children: const [
                                        SizedBox(width: 20),
                                        Text("自分の名言"),
                                      ],
                                    ),
                                    for (int i = userJson["word"].length - 1;
                                        i >= 0;
                                        i--)
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.of(context).push(
                                            MaterialPageRoute(
                                              builder: (context) {
                                                return CommentPage(
                                                    name: userJson[
                                                        "speaker_name"],
                                                    word: userJson["word"][i]
                                                        ["great_word"],
                                                    word_id: userJson["word"][i]
                                                        ["id"],
                                                    comments: userJson["word"]
                                                        [i]["comments"]);
                                              },
                                            ),
                                          );
                                        },
                                        child: Container(
                                          padding: EdgeInsets.only(
                                              left: 10, right: 10, bottom: 20),
                                          margin: EdgeInsets.only(top: 10),
                                          width:
                                              MediaQuery.of(context).size.width,
                                          decoration: const BoxDecoration(
                                              border: Border(
                                                  bottom: BorderSide(
                                                      color: Colors.black,
                                                      width: 0.5))),
                                          // color: Colors.black,
                                          child: Column(
                                            children: [
                                              Text(
                                                "「${userJson["word"][i]["great_word"]}」",
                                                style: TextStyle(fontSize: 25),
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                children: [
                                                  Text(userJson["word"][i]
                                                          ["comments"]
                                                      .length
                                                      .toString()),
                                                  SizedBox(width: 5),
                                                  Icon(Icons.comment_outlined),
                                                ],
                                              )
                                            ],
                                          ),
                                        ),
                                      )
                                  ],
                                )
                              : Column(
                                  children: [
                                    Row(
                                      children: [
                                        SizedBox(width: 20),
                                        Text("自分のコメント"),
                                      ],
                                    ),
                                    for (int i =
                                            userJson["comments"].length - 1;
                                        i >= 0;
                                        i--)
                                      Column(
                                        children: [
                                          Container(
                                            margin: EdgeInsets.all(8),
                                            // color: Colors.black,
                                            child: Row(
                                              children: [
                                                GestureDetector(
                                                  onTap: () {
                                                    Navigator.of(context).push(
                                                      MaterialPageRoute(
                                                        builder: (context) {
                                                          return CntentsPage(
                                                            userJson["comments"]
                                                                    [i]
                                                                ["speaker_id"],
                                                            userJson["comments"]
                                                                    [i]
                                                                ["user_name"],
                                                            "",
                                                          );
                                                        },
                                                      ),
                                                    );
                                                  },
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                        border: Border(
                                                            bottom: BorderSide(
                                                                color: Colors
                                                                    .black))),
                                                    child: Text(
                                                      userJson["comments"][i]
                                                          ["user_name"],
                                                      style: TextStyle(
                                                          fontSize: 25,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Colors
                                                              .blueAccent),
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(width: 15),
                                                Text("さんの名言へ")
                                              ],
                                            ),
                                          ),
                                          Text(
                                            userJson["comments"][i]["comment"],
                                            style: TextStyle(fontSize: 18),
                                          ),
                                          SizedBox(height: 10),
                                          Divider(
                                              height: 5, color: Colors.black),
                                          SizedBox(height: 20)
                                        ],
                                      )
                                  ],
                                ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
          showDetail
              ? Container(
                  width: MediaQuery.of(context).size.width,
                  margin: EdgeInsets.only(top: 100, bottom: 50),
                  padding: EdgeInsets.all(30),
                  color: Colors.white.withOpacity(0.93),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "名前",
                        style: TextStyle(fontSize: 20),
                      ),
                      TextField(
                        maxLines: 2,
                        style: TextStyle(color: Colors.black),
                        controller: _controllerName,
                        decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            icon: Icon(
                              Icons.mark_chat_read_outlined,
                              color: Colors.white,
                            ),
                            hintText: "名前を変更...${userJson["speaker_name"]}"),
                        onChanged: (String value) {
                          setState(() {
                            _name = value;
                          });
                        },
                      ),
                      SizedBox(height: 50),
                      Text(
                        "紹介文",
                        style: TextStyle(fontSize: 20),
                      ),
                      TextField(
                        maxLines: 10,
                        style: TextStyle(color: Colors.black),
                        controller: _controllerDetail,
                        decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            icon: Icon(
                              Icons.mark_chat_read_outlined,
                              color: Colors.white,
                            ),
                            hintText: "紹介文を変更...${userJson["speaker_detail"]}"),
                        onChanged: (String value) {
                          setState(() {
                            _detail = value;
                          });
                        },
                      ),
                    ],
                  ),
                )
              : Container()
        ]),
      ),
    );
  }
}

Future<ApiResults> _fetchApiResults(FirebaseAuth user) async {
  var url = Uri.parse(
      "http://192.168.0.45:8000/get/speaker/uuid/${user.currentUser!.uid}/");

  final response = await http.get(url);
  if (response.statusCode == 200) {
    return ApiResults.fromJson(json.decode(utf8.decode(response.bodyBytes)));
  } else {
    throw Exception('Failed to load API params');
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

class Request {
  final String word;
  final int speaker_id;
  final String uuid;
  Request({required this.word, required this.speaker_id, required this.uuid});
  Map<String, dynamic> toJson() =>
      {"great_word": word, "speaker_id": speaker_id, "uuid": uuid};
}

class Update {
  final int speaker_id;
  final String name;
  final String detail;
  final String uuid;
  Update(
      {required this.speaker_id,
      required this.name,
      required this.detail,
      required this.uuid});
  Map<String, dynamic> toJson() =>
      {"speaker_id": speaker_id, "name": name, "detail": detail, "uuid": uuid};
}
