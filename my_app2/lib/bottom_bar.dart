import 'package:flutter/material.dart';
import 'package:my_app2/saerch_screens/search_screen.dart';
import 'package:my_app2/speakers.dart';
import 'package:my_app2/ui/shared/colors.dart';
import 'package:my_app2/user_screens/user_home.dart';

class Bottombar extends StatefulWidget {
  @override
  _BottombarState createState() => _BottombarState();
}

class _BottombarState extends State<Bottombar> {
  // 表示中の Widget を取り出すための index としての int 型の mutable な stored property
  int _selectedIndex = 0;

  // 表示する Widget の一覧
  static List<Widget> _pageList = [Speakers(), UserHome()];

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        return _willPopCallback();
      },
      child: Scaffold(
        body: _pageList[_selectedIndex],
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: AppColor.firstColor,
          unselectedItemColor: Colors.white,
          selectedItemColor: AppColor.secondColor,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.account_circle),
              label: 'You',
            ),
          ],
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
        ),
      ),
    );
  }

  Future<bool> _willPopCallback() async {
    return true;
  }

// タップ時の処理
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}
// ナビゲーションバーをタップした時に切り替わるWidgetの定義
