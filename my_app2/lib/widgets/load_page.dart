import 'package:flutter/material.dart';
import 'package:my_app2/ui/shared/colors.dart';

Scaffold load_page(String dev, BuildContext context) {
  return Scaffold(
    body: Container(
      decoration: BoxDecoration(color: AppColor.firstColor),
      child: Center(
        child: Column(
          children: [
            Expanded(child: Container(), flex: 6),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  'developer',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
                const SizedBox(width: 10),
                Text(
                  dev,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
            Expanded(child: Container(), flex: 1),
          ],
        ),
      ),
    ),
  );
}
