import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:my_app2/bottom_bar.dart';
import 'package:my_app2/speakers.dart';
import 'package:my_app2/ui/shared/colors.dart';

class UserCreate extends StatefulWidget {
  final uuid;
  UserCreate(this.uuid, {Key? key}) : super(key: key);

  @override
  _UserCreateState createState() => _UserCreateState();
}

class _UserCreateState extends State<UserCreate> {
  String name = "";
  int category = 0;

  Future<ApiResults> fetchApiResults() async {
    var url = Uri.parse("http://192.168.0.45:8000/create/speaker/");
    var request = new Request(name: name, uuid: widget.uuid);
    final response = await http.post(url,
        body: json.encode(request.toJson()),
        headers: {"Content-Type": "application/json"});
    if (response.statusCode == 200) {
      return ApiResults.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              maxLength: 10,
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  icon: Icon(Icons.face),
                  hintText: "ユーザ名"),
              onChanged: (String value) {
                setState(() {
                  name = value;
                });
              },
            ),
            SizedBox(height: 20),
            SizedBox(height: 20),
            MaterialButton(
                onPressed: () async {
                  fetchApiResults();
                  await Navigator.of(context)
                      .pushReplacement(MaterialPageRoute(builder: (context) {
                    return Bottombar();
                  }));
                },
                color: AppColor.fouthColor,
                child: Text(
                  "はじめる",
                  style: TextStyle(
                      fontSize: 20,
                      color: Colors.black,
                      fontWeight: FontWeight.bold),
                ))
          ],
        ),
      ),
    );
  }
}

class Request {
  final String name;
  final String uuid;
  Request({
    required this.name,
    required this.uuid,
  });
  Map<String, dynamic> toJson() => {
        "speaker_name": name,
        "speaker_name_eng": "",
        "speaker_detail": "",
        "uuid": uuid,
        "category_id": 4,
        "is_active": false,
      };
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
