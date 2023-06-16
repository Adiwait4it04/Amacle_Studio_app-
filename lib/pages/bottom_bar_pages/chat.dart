import 'package:amacle_studio_app/pages/each_chat.dart';
import 'package:amacle_studio_app/utils/constant.dart';
import 'package:amacle_studio_app/utils/search_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class ChatsPage extends StatefulWidget {
  const ChatsPage({super.key});

  @override
  State<ChatsPage> createState() => _ChatsPageState();
}

class _ChatsPageState extends State<ChatsPage> {
  static List<SearchModel> chat_list = [
    SearchModel("Haley James", "Stand up for what you believe in"),
    SearchModel("Haley James", "Stand up for what you believe in"),
    SearchModel("Haley James", "Stand up for what you believe in"),
    SearchModel("Haley James", "Stand up for what you believe in"),
    SearchModel("Haley James", "Stand up for what you believe in"),
    SearchModel("Haley James", "Stand up for what you believe in"),
    SearchModel("Haley James", "Stand up for what you believe in"),
    SearchModel("Aditya James", "Stand up for what you believe in"),
    SearchModel("Aditya James", "Stand up for what you believe in"),
    SearchModel("Aditya James", "Stand up for what you believe in"),
    SearchModel("Aditya James", "Stand up for what you believe in"),
  ];
  List<SearchModel> display_list = List.from(chat_list);

  void updateList(String value) {
    setState(
      () {
        display_list = chat_list
            .where(
              (element) => element.name!.toLowerCase().contains(
                    value.toLowerCase(),
                  ),
            )
            .toList();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(top: 10),
              child: Center(
                child: Text(
                  "Chats",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    fontSize: width(context) * 0.055,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
              child: TextField(
                onChanged: (value) => updateList(value),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide.none,
                  ),
                  hintText: "   Search",
                  prefixIcon: const Icon(
                    Icons.search,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Expanded(
              child: display_list.isEmpty
                  ? const Center(
                      child: Text(
                        "No Result Found",
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.bold),
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.all(10),
                      child: GestureDetector(
                        onTap: () {
                          // Get.to(() => Each_Chat());
                          nextScreen(context, Each_Chat());
                        },
                        child: ListView.builder(
                            itemCount: display_list.length,
                            itemBuilder: (context, index) {
                              return Column(
                                children: [
                                  ListTile(
                                    title: Text(
                                      display_list[index].name!,
                                      style: const TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    subtitle: Text(
                                      display_list[index].last_chat!,
                                      style:
                                          const TextStyle(color: Colors.black),
                                    ),
                                    leading: CircleAvatar(
                                      maxRadius: width(context) * 0.065,
                                      backgroundColor: Color(0xFFB4DBFF),
                                      // backgroundColor: Colors.transparent,
                                      child: Center(
                                        child: Icon(
                                          Icons.person,
                                          size: width(context) * 0.11,
                                          color: Color(0xFFEAF2FF),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Visibility(
                                    visible: index != display_list.length - 1,
                                    child: Container(
                                      margin: const EdgeInsets.only(
                                          left: 8, right: 8),
                                      child: Divider(
                                        color: Colors.black26,
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            }),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
