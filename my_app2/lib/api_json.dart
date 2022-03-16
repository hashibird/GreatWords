// import 'dart:async';
// import 'dart:convert';

// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;

// class Apiapp extends StatefulWidget {
//   const Apiapp({Key? key}) : super(key: key);

//   // const MyApp({required Key key}) : super(key: key);

//   @override
//   _ApiappState createState() => _ApiappState();
// }

// class _ApiappState extends State<Apiapp> {
//   late Future<ApiResults> futureApiResults;
//   @override
//   void initState() {
//     super.initState();
//     futureApiResults = fetchApiResults();
//     print(futureApiResults);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'APIから返ってきたJSONレスポンスをページに表示する',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: Scaffold(
//         appBar: AppBar(
//           actions: [
//             IconButton(
//                 onPressed: () {
//                   Navigator.of(context).pop();
//                 },
//                 icon: Icon(Icons.arrow_back))
//           ],
//           title: const Text('Api JSON Response Sample'),
//         ),
//         body: Center(
//           child: FutureBuilder<ApiResults>(
//             future: futureApiResults,
//             builder: (context, snapshot) {
//               //
//               if (snapshot.hasData) {
//                 print(snapshot.data!.results.toString());
//                 return Column(
//                   children: [
//                     Text(snapshot.data!.results[0]["speaker_name"]),
//                     Text(snapshot.data!.results[0]["speaker_name_eng"]),
//                     Text(snapshot.data!.results[0]["speaker_detail"]),
//                     Text(snapshot.data!.results[0]["category_name"]),
//                     Text(snapshot.data!.results[0]["img_url_path"])
//                   ],
//                 );
//                 // Text(snapshot.data!.status.toString() +
//                 //     " : " +
//                 //     snapshot.data!.results[0]['address1'] +
//                 //     snapshot.data!.results[0]['address2'] +
//                 //     snapshot.data!.results[0]['address3']);
//               } else if (snapshot.hasError) {
//                 return Text("${snapshot.error}aaaaaa");
//               }
//               return const CircularProgressIndicator();
//             },
//           ),
//         ),
//       ),
//     );
//   }
// }

// class ApiResults {
//   final results;

//   ApiResults({this.results});

//   factory ApiResults.fromJson(List<dynamic> json) {
//     return ApiResults(
//       results: json,
//     );
//   }
// }

// Future<ApiResults> fetchApiResults() async {
//   var url = Uri.parse('http://192.168.0.45:8000/check/${_auth}');
//   print('a');

//   final response = await http.get(url);
//   print("response.statusCode");
//   if (response.statusCode == 200) {
//     // print(response.body);
//     print('succece');
//     print(utf8.decode(response.bodyBytes));
//     return ApiResults.fromJson(json.decode(utf8.decode(response.bodyBytes)));
//   } else {
//     throw Exception('Failed to load API params');
//   }
// }
