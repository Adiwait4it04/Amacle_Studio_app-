// ignore_for_file: prefer_const_constructors

import 'package:amacle_studio_app/pages/each_chat.dart';
import 'package:amacle_studio_app/utils/constant.dart';
import 'package:amacle_studio_app/utils/search_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../global/globals.dart';

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

  String chatRoomId(int userId1, int userId2) {
    if (userId1 > userId2) {
      return "${userId1}chat${userId2}";
    } else {
      return "${userId2}chat${userId1}";
    }
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
                      child: StreamBuilder<QuerySnapshot>(
                          stream: (Global.role == "developer")
                              ? FirebaseFirestore.instance
                                  .collection("users")
                                  .where("id",
                                      isNotEqualTo: Global.mainMap[0]["id"])
                                  .where("role", whereIn: [
                                  "manager",
                                  "developer"
                                ]).snapshots()
                              : FirebaseFirestore.instance
                                  .collection("users")
                                  .where("id",
                                      isNotEqualTo: Global.mainMap[0]["id"])
                                  .snapshots(),
                          builder:
                              (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                            if (snapshot.hasData) {
                              List<DocumentSnapshot> documents =
                                  snapshot.data!.docs;
                              return ListView.builder(
                                  itemCount: documents.length,
                                  itemBuilder: (context, index) {
                                    return Column(
                                      children: [
                                        ListTile(
                                          title: Text(
                                            documents[index]["name"]!,
                                            style: const TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          // subtitle: Text(
                                          //   display_list[index].last_chat!,
                                          //   style: const TextStyle(
                                          //       color: Colors.black),
                                          // ),
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
                                          onTap: () {
                                            String roomId = chatRoomId(
                                                Global.id,
                                                documents[index]["id"]);
                                            print(roomId);
                                            nextScreen(
                                                context,
                                                ChatPage(
                                                  chatRoomId: roomId,
                                                  doc: documents[index],
                                                ));
                                          },
                                        ),
                                        Visibility(
                                          visible:
                                              index != documents.length - 1,
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
                                  });
                            } else {
                              return Container();
                            }
                          }),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
