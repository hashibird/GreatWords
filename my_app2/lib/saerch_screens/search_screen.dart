import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:my_app2/ui/shared/colors.dart';

import 'package:http/http.dart' as http;

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  Future getData() async {
    Uri url = Uri.parse("http://192.168.0.45:8000/get/categories/");
    http.Response response = await http.get(url);
    if (response.statusCode == 200) {
      // print(response.body);
      print('succece');
      print(utf8.decode(response.bodyBytes));
      return json.decode(utf8.decode(response.bodyBytes));
    } else {
      throw Exception('Failed to load API params');
    }
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: AppColor.firstColor,
          title: Text("Search"),
        ),
        body: Container(
          padding: EdgeInsets.all(15),
          child: Column(
            children: [
              Container(
                height: 100,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    color: AppColor.secondColor,
                    borderRadius: BorderRadius.circular(40)),
                child: Center(child: Text("偉人")),
              )
            ],
          ),
        ));
  }
}
