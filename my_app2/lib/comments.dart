import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:my_app2/ui/shared/colors.dart';

import 'package:http/http.dart' as http;

class CommentPage extends StatefulWidget {
  final String name;
  final String word;
  final int word_id;
  List comments;
  CommentPage({
    required this.name,
    required this.word,
    required this.word_id,
    required this.comments,
    Key? key,
  }) : super(key: key);

  @override
  _CommentPageState createState() => _CommentPageState();
}

class _CommentPageState extends State<CommentPage> {
  FirebaseAuth _user = FirebaseAuth.instance;
  String comment = "";
  var _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(height: 30),
          Row(
            children: [
              IconButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: Icon(Icons.arrow_back_ios_new))
            ],
          ),
          Text(
            "~${widget.name}~",
            style: TextStyle(fontSize: 30),
          ),
          Expanded(
              flex: 3,
              child: SingleChildScrollView(
                child: Container(
                  padding: EdgeInsets.all(20),
                  child: Center(
                    child:
                        Text("${widget.word}", style: TextStyle(fontSize: 30)),
                  ),
                ),
              )),
          Container(
            padding: EdgeInsets.only(left: 20, right: 20),
            child: TextField(
              maxLength: 100,
              minLines: 1,
              maxLines: 5,
              controller: _controller,
              onChanged: (value) => setState(() {
                comment = value;
              }),
              decoration: InputDecoration(hintText: "コメントを入力..."),
            ),
          ),
          Row(mainAxisAlignment: MainAxisAlignment.end, children: [
            MaterialButton(
              onPressed: () {
                if (comment == "") {
                } else {
                  _controller.clear();
                  fetchApiResults();
                }
              },
              color: Colors.lightBlueAccent,
              child: Text("送信"),
            ),
            SizedBox(width: 40)
          ]),
          Expanded(
            flex: 3,
            child: Container(
              child: ListView.builder(
                  itemCount: widget.comments.length,
                  itemBuilder: (BuildContext context, int idx) {
                    return Container(
                      child: Container(
                          margin: EdgeInsets.all(8),
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              color: AppColor.thirdColor,
                              borderRadius: BorderRadius.circular(10)),
                          child: Column(
                            children: [
                              Row(children: [
                                SizedBox(width: 20),
                                Text("コメント")
                              ]),
                              Text(widget.comments[idx]["comment"],
                                  style: TextStyle(fontSize: 25)),
                            ],
                          )),
                    );
                  }),
            ),
          ),
        ],
      ),
    );
  }

  fetchApiResults() async {
    var url = Uri.parse("http://192.168.0.45:8000/create/comment/");
    var request = Request(
        comment: comment,
        uuid: _user.currentUser!.uid,
        great_word_id: widget.word_id);
    final response = await http.post(url,
        body: json.encode(request.toJson()),
        headers: {"Content-Type": "application/json"});
    if (response.statusCode == 200) {
      widget.comments = await json.decode(utf8.decode(response.bodyBytes));
      setState(() {});
    } else {
      throw Exception('Failed');
    }
  }
}

class Request {
  final String comment;
  final String uuid;
  final int great_word_id;
  Request(
      {required this.comment, required this.uuid, required this.great_word_id});
  Map<String, dynamic> toJson() => {
        "comment": comment,
        "great_words_id": great_word_id,
        "uuid": uuid,
      };
}
