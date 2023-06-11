// ignore_for_file: unused_local_variable, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:amacle_studio_app/pages/bottom_bar_pages/chat.dart';
import 'package:amacle_studio_app/pages/bottom_bar_pages/home_page.dart';
import 'package:amacle_studio_app/pages/bottom_bar_pages/project_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

import 'utils/icons.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentIndex = 0;

  List pages = [
    HomePageScreen(),
    ChatsPage(),
    Container(),
  ];

  @override
  Widget build(BuildContext context) {
    BarIcons icons = BarIcons();
    var size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        body: pages[currentIndex],
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Colors.white,
          selectedFontSize: 15,
          unselectedFontSize: 15,
          selectedIconTheme: null,
          type: BottomNavigationBarType.fixed,
          currentIndex: currentIndex,
          onTap: (int index) {
            setState(
              () {
                currentIndex = index;
              },
            );
          },
          items: [
            icons.item(
              70,
              40,
              "Home",
              22,
              currentIndex == 0,
              CupertinoIcons.home,
            ),
            icons.item(
              70,
              40,
              "Chats",
              22,
              currentIndex == 1,
              CupertinoIcons.chat_bubble,
            ),
            icons.item(
              70,
              40,
              "Projects",
              22,
              currentIndex == 2,
              CupertinoIcons.pencil,
            ),
          ],
        ),
      ),
    );
  }
}
