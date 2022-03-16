// import 'package:flutter/material.dart';
// import 'package:my_app2/ui/shared/colors.dart';

// import '../contents_page.dart';

// Widget homePage(List speaker_json, BuildContext context, bool show_detail) {
//   return Stack(children: [
//     Container(
//       // decoration: const BoxDecoration(

//       // image: DecorationImage(
//       //     image: NetworkImage(
//       //         "https://cdn.pixabay.com/photo/2015/04/23/22/00/tree-736885_1280.jpg"),
//       //     fit: BoxFit.cover)
//       // ),
//       color: Colors.white,
//       child: SingleChildScrollView(
//         child: Column(
//           children: [
//             const SizedBox(
//               height: 80,
//               child: Center(
//                 child: Text(
//                   "〜偉人から学ぶ〜",
//                   style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
//                 ),
//               ),
//             ),
//             for (int i = 0; i < speaker_json.length; i++)
//               GestureDetector(
//                 onLongPress: () {
//                   print('a');
//                   HomePage._change_show_detail();
//                 },
//                 onTap: () {
//                   // print(imagePath[i]["urlJson"]);
//                   Navigator.of(context).push(
//                     MaterialPageRoute(
//                       builder: (context) {
//                         return CntentsPage(
//                           speaker_json[i]["id"],
//                           speaker_json[i]["speaker_name"],
//                           speaker_json[i]["speaker_name_eng"],
//                           speaker_json[i]["img_url_path"],
//                         );
//                       },
//                     ),
//                   );
//                 },
//                 child: Container(
//                   height: 150,
//                   width: MediaQuery.of(context).size.width,
//                   padding: const EdgeInsets.only(left: 20),
//                   margin: const EdgeInsets.only(left: 5, right: 5, top: 30),
//                   decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(30),
//                       // color: AppColor.fouthColor,
//                       color: Colors.white,
//                       boxShadow: [
//                         BoxShadow(
//                             color: AppColor.thirdColor,
//                             offset: Offset(2, 2),
//                             blurRadius: 10)
//                       ],
//                       image: DecorationImage(
//                           image: AssetImage(speaker_json[i]["img_url_path"]),
//                           alignment: Alignment.bottomRight)),
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(speaker_json[i]["speaker_name"],
//                           style: const TextStyle(
//                               fontSize: 20, fontWeight: FontWeight.bold)),
//                       const SizedBox(height: 10),
//                       Text("-" + speaker_json[i]["speaker_name_eng"] + "-",
//                           style: const TextStyle(fontSize: 20)),
//                       Text(speaker_json[i]["category_name"])
//                     ],
//                   ),
//                 ),
//               ),
//             // const Text('dataa', style: TextStyle(fontSize: 30)),
//           ],
//         ),
//       ),
//     ),
//     show_detail
//         ? Center(
//             child: Container(
//               height: 300,
//               width: MediaQuery.of(context).size.width,
//             ),
//           )
//         : Container()
//   ]);
// }
