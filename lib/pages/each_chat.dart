// ignore_for_file: prefer_const_constructors

import 'package:amacle_studio_app/pages/bottom_bar_pages/chat.dart';
import 'package:amacle_studio_app/utils/constant.dart';
import 'package:flutter/material.dart';

class Each_Chat extends StatefulWidget {
  const Each_Chat({super.key});

  @override
  State<Each_Chat> createState() => _Each_ChatState();
}

class _Each_ChatState extends State<Each_Chat> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          addVerticalSpace(height(context) * 0.0428),
          Row(
            // crossAxisAlignment: CrossAxisAlignment.center,
            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 7),
                child: GestureDetector(
                  onTap: () {
                    goBack(context);
                  },
                  child: Icon(
                    Icons.arrow_back_ios_new,
                    color: Colors.lightBlue,
                    size: width(context) * 0.065,
                  ),
                ),
              ),
              const Spacer(),
              Text(
                "Haley James",
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: width(context) * 0.05),
              ),
              const Spacer(),
              CircleAvatar(
                maxRadius: width(context) * 0.055,
                backgroundColor: Color(0xFFB4DBFF),
                // backgroundColor: Colors.transparent,
                child: Center(
                  child: Icon(
                    Icons.person,
                    size: width(context) * 0.09,
                    color: Color(0xFFEAF2FF),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
