import 'dart:convert';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:my_app2/main.dart';
import 'package:my_app2/ui/shared/colors.dart';

import 'package:http/http.dart' as http;

import 'comments.dart';

class CntentsPage extends StatefulWidget {
  int speaker_id;
  String name;
  String engName;
  CntentsPage(this.speaker_id, this.name, this.engName, {Key? key})
      : super(key: key);

  @override
  _CntentsPageState createState() => _CntentsPageState();
}

class _CntentsPageState extends State<CntentsPage> {
  late Future<ApiResults> futureApiResults;

  @override
  void initState() {
    super.initState();
    futureApiResults = fetchApiResults(widget.speaker_id.toString());
    // print(futureApiResults);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // drawer: Drawer(),
        // appBar: AppBar(
        //   backgroundColor: AppColor.firstColor,
        //   title: Text(widget.name,
        //       style: const TextStyle(
        //           fontSize: 20,
        //           fontWeight: FontWeight.bold,
        //           color: Colors.white)),
        // ),
        body: FutureBuilder<ApiResults>(
            future: futureApiResults,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                // print(snapshot.data!.results);
                return contentsPage(snapshot.data?.results, context);
              } else if (snapshot.hasError) {
                return Text("${snapshot.error}");
              }
              return const Center(child: CircularProgressIndicator());
            }));
  }

  Widget contentsPage(List great_words, BuildContext context) {
    return Container(
      // color: Colors.black.withOpacity(0.1),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 20),
          IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: Icon(Icons.arrow_back_ios_rounded)),
          Expanded(
            child: Stack(
              children: [
                Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            height: 150,
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: AssetImage(
                                        "assets/images/anonymous.png"),
                                    alignment: Alignment.centerRight)),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                SingleChildScrollView(
                  // color: AppColor.fouthColor,
                  child: Container(
                    child: Column(
                      children: [
                        Container(
                          height: 150,
                          width: MediaQuery.of(context).size.width,
                          color: Colors.white.withOpacity(0),
                        ),
                        Container(
                          padding: const EdgeInsets.only(left: 20, top: 10),
                          height: 130,
                          width: MediaQuery.of(context).size.width,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              AnimatedTextKit(
                                // totalRepeatCount: 2,
                                isRepeatingAnimation: false,
                                animatedTexts: [
                                  TypewriterAnimatedText(
                                    widget.name,
                                    curve: Curves.easeIn,
                                    speed: const Duration(milliseconds: 200),
                                    textStyle: const TextStyle(
                                        color: Colors.black54,
                                        fontSize: 35,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),

                              // SizedBox(),
                              Text(
                                "-${widget.engName}-",
                                style: const TextStyle(
                                    fontSize: 20, color: Colors.black54),
                              ),
                            ],
                          ),
                        ),
                        Divider(
                          color: AppColor.secondColor,
                          height: 10,
                        ),
                        const SizedBox(height: 10),
                        Column(
                          children: [
                            for (int i = 0; i < great_words.length; i++)
                              GestureDetector(
                                onTap: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) {
                                        return CommentPage(
                                          name: widget.name,
                                          word: great_words[i]["great_word"],
                                          word_id: great_words[i]["id"],
                                          comments: great_words[i]["comments"],
                                        );
                                      },
                                    ),
                                  );
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: AppColor.fouthColor,
                                      borderRadius: BorderRadius.circular(50),
                                      boxShadow: [
                                        BoxShadow(
                                            offset: const Offset(5, 5),
                                            color:
                                                Colors.black.withOpacity(0.4),
                                            blurRadius: 5)
                                      ]),
                                  padding: const EdgeInsets.all(20),
                                  margin: const EdgeInsets.only(
                                      right: 5, left: 5, bottom: 60),
                                  height: 220,
                                  width: MediaQuery.of(context).size.width,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Expanded(
                                        child: SingleChildScrollView(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                "「${great_words[i]["great_word"]}」",
                                                style: const TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 19,
                                                    fontWeight:
                                                        FontWeight.bold),
                                                overflow: TextOverflow.fade,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 15),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          Text("-${widget.name}-"),
                                          Expanded(child: Container()),
                                          Icon(Icons.comment_outlined),
                                          SizedBox(width: 5),
                                          Text(great_words[i]["comments"]
                                              .length
                                              .toString()),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            // SizedBox(height: 20),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
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

Future<ApiResults> fetchApiResults(String speakerId) async {
  var url = Uri.parse(
      'http://192.168.0.45:8000/get/speaker/id/$speakerId/great_words/');
  print(url);

  final response = await http.get(url);
  print("response.statusCode");
  if (response.statusCode == 200) {
    // print(response.body);
    print('succece');
    print(utf8.decode(response.bodyBytes));
    return ApiResults.fromJson(json.decode(utf8.decode(response.bodyBytes)));
  } else {
    throw Exception('Failed to load API params');
  }
}
