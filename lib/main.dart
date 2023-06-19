// ignore_for_file: unused_local_variable, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:developer';

import 'package:amacle_studio_app/global/globals.dart';
import 'package:amacle_studio_app/pages/bottom_bar_pages/manager_project_screen.dart';
import 'package:amacle_studio_app/pages/bottom_bar_pages/chat.dart';
import 'package:amacle_studio_app/pages/bottom_bar_pages/home_page.dart';
import 'package:amacle_studio_app/pages/bottom_bar_pages/project_screen.dart';
import 'package:amacle_studio_app/pages/loginpage.dart';
import 'package:amacle_studio_app/utils/app_text.dart';
import 'package:amacle_studio_app/utils/constant.dart';
import 'package:amacle_studio_app/utils/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'authentication/auth_controller.dart';
import 'firebase_options.dart';
import 'utils/icons.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform)
      .then((value) => Get.put(AuthController()));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  Future<void> doit() async {
    await Global().fetchData();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    doit();
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: GoogleFonts.poppins().fontFamily,
      ),
      home: LoginPage(),
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
    dontKnowPage(),
  ];

  DateTime? currentBackPressTime;

  Future<bool> _onWillPop() async {
    DateTime now = DateTime.now();
    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime!) > Duration(seconds: 2)) {
      currentBackPressTime = now;
      Fluttertoast.showToast(
        msg: "Press again to exit",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
      );
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    BarIcons icons = BarIcons();
    var size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection("users")
              .where("email", isEqualTo: Global.email)
              .snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return WillPopScope(
                onWillPop: _onWillPop,
                child: loadingState(),
              );
            }
            if (snapshot.hasData) {
              List<DocumentSnapshot> documents = snapshot.data!.docs;
              Global.mainMap = documents;
              Global.role = Global.mainMap[0]["role"];
              Global.id = Global.mainMap[0]["id"];
              return WillPopScope(
                onWillPop: _onWillPop,
                child: pages[currentIndex],
              );
            } else {
              return WillPopScope(
                onWillPop: _onWillPop,
                child: Center(
                  child: AppText(
                    text: "An error ocured",
                    color: black,
                  ),
                ),
              );
            }
          },
        ),
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

class dontKnowPage extends StatefulWidget {
  const dontKnowPage({Key? key}) : super(key: key);

  @override
  _dontKnowPageState createState() => _dontKnowPageState();
}

class _dontKnowPageState extends State<dontKnowPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Global.role == "developer"
        ? ProjectScreen()
        : ManagerProjectScreen();
  }
}
