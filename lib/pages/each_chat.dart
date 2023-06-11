import 'package:amacle_studio_app/pages/bottom_bar_pages/chat.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Each_Chat extends StatefulWidget {
  const Each_Chat({super.key});

  @override
  State<Each_Chat> createState() => _Each_ChatState();
}

class _Each_ChatState extends State<Each_Chat> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          shadowColor: Colors.white,
          surfaceTintColor: Colors.white,
          title: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 7),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (context) => const ChatsPage(),
                          ),
                        );
                      },
                      child: const Icon(
                        Icons.arrow_back,
                        color: Colors.lightBlue,
                        size: 50,
                      ),
                    ),
                  ),
                  const Spacer(),
                  const Padding(
                    padding: EdgeInsets.only(top: 18),
                    child: Padding(
                      padding: EdgeInsets.only(right: 18),
                      child: Text(
                        "Haley James",
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 20),
                      ),
                    ),
                  ),
                  const Spacer(),
                  const Icon(
                    CupertinoIcons.profile_circled,
                    color: Colors.lightBlue,
                    size: 50,
                  ),
                ],
              ),
            ],
          ),
        ),
        body: const Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [],
        ),
      ),
    );
  }
}
