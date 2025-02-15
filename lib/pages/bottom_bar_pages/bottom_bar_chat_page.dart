// ignore_for_file: prefer_const_constructors

import 'dart:async';
import 'dart:developer';
import 'package:amacle_studio_app/pages/bottom_bar_pages/chat.dart';
import 'package:amacle_studio_app/pages/each_chat.dart';
import 'package:amacle_studio_app/utils/constant.dart';
import 'package:amacle_studio_app/utils/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../global/globals.dart';

class BottomBarCharPage extends StatefulWidget {
  const BottomBarCharPage({super.key});

  @override
  State<BottomBarCharPage> createState() => _BottomBarCharPageState();
}

class _BottomBarCharPageState extends State<BottomBarCharPage> {
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
                enabled: true,
                readOnly: true,
                onTap: () {
                  nextScreen(context, ChatsPage());
                },
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.transparent,
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
              child: StreamBuilder<QuerySnapshot>(
                  stream: null,
                  builder: (context, snapshot) {
                    return Padding(
                      padding: const EdgeInsets.all(10),
                      child: StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection("users")
                            .doc(Global.id.toString())
                            .collection("my_chats")
                            .orderBy("last_time", descending: true)
                            .snapshots(),
                        // stream: (Global.role == "developer")
                        //     ? FirebaseFirestore.instance
                        //         .collection("users")
                        //         .where("id",
                        //             isNotEqualTo: Global.mainMap[0]["id"])
                        //         .where("role", whereIn: [
                        //         "manager",
                        //         "developer"
                        //       ]).snapshots()
                        //     : FirebaseFirestore.instance
                        //         .collection("users")
                        //         .where("id",
                        //             isNotEqualTo: Global.mainMap[0]["id"])
                        //         .snapshots(),
                        builder:
                            (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                          if (snapshot.hasData) {
                            List<DocumentSnapshot> documents =
                                snapshot.data!.docs;

                            findUsersToShow(documents);

                            return FutureBuilder(
                                future: findUsersToShow(documents),
                                builder: (context, snapfinal) {
                                  if (snapfinal.hasData) {
                                    log(snapfinal.data.toString());

                                    return ListView.builder(
                                        itemCount: documents.length,
                                        itemBuilder: (context, index) {
                                          print(snapfinal.data);

                                          return StreamBuilder<QuerySnapshot>(
                                              stream: FirebaseFirestore.instance
                                                  .collection('users')
                                                  .where("id",
                                                      isEqualTo: snapfinal
                                                          .data![index])
                                                  .snapshots(),
                                              builder: (context,
                                                  AsyncSnapshot snaps) {
                                                if (snaps.hasData) {
                                                  List<DocumentSnapshot> docs =
                                                      snaps.data!.docs;
                                                  return Visibility(
                                                    // visible: visibleUsers.contains(),
                                                    child: Column(
                                                      children: [
                                                        ListTile(
                                                          title: Text(
                                                            docs[0]["name"]!,
                                                            style: const TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          ),
                                                          trailing: Visibility(
                                                            visible: documents[
                                                                        index]
                                                                    ["seen"] ==
                                                                "no",
                                                            child: Container(
                                                              width: 10,
                                                              height: 10,
                                                              decoration: BoxDecoration(
                                                                  shape: BoxShape
                                                                      .circle,
                                                                  color:
                                                                      btnColor),
                                                            ),
                                                          ),
                                                          leading: CircleAvatar(
                                                            maxRadius:
                                                                width(context) *
                                                                    0.065,
                                                            backgroundColor:
                                                                Color(
                                                                    0xFFB4DBFF),
                                                            // backgroundColor: Colors.transparent,
                                                            child: Center(
                                                              child: Icon(
                                                                Icons.person,
                                                                size: width(
                                                                        context) *
                                                                    0.11,
                                                                color: Color(
                                                                    0xFFEAF2FF),
                                                              ),
                                                            ),
                                                          ),
                                                          onTap: () {
                                                            String roomId =
                                                                chatRoomId(
                                                                    Global.id,
                                                                    docs[0]
                                                                        ["id"]);
                                                            print(roomId);
                                                            nextScreen(
                                                                context,
                                                                ChatPage(
                                                                  chatRoomId:
                                                                      roomId,
                                                                  doc: docs[0],
                                                                ));
                                                          },
                                                        ),
                                                        Visibility(
                                                          visible: index !=
                                                              documents.length -
                                                                  1,
                                                          child: Container(
                                                            margin:
                                                                const EdgeInsets
                                                                        .only(
                                                                    left: 8,
                                                                    right: 8),
                                                            child: Divider(
                                                              color: Colors
                                                                  .black26,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  );
                                                } else {
                                                  return SizedBox(
                                                      width: 0.01,
                                                      height: 0.01);
                                                }
                                              });
                                        });
                                  } else {
                                    return nullWidget();
                                  }
                                });
                          } else {
                            return Container();
                          }
                        },
                      ),
                    );
                  }),
            ),
          ],
        ),
      ),
    );
  }

  Future<List<dynamic>> findUsersToShow(
      List<DocumentSnapshot> documents) async {
    List<dynamic> visibleUsers = [];

    for (DocumentSnapshot<Object?> document in documents) {
      int searchId = document['search_id'] as int;
      visibleUsers.add(searchId);
    }

    return visibleUsers;
  }
}

/*
log(snapfinal.data.toString());
                                  
                                  return ListView.builder(
                                      itemCount: documents.length,
                                      itemBuilder: (context, index) {
                                        return StreamBuilder<QuerySnapshot>(
                                            stream: FirebaseFirestore.instance
                                                .collection('chatroom')
                                                .doc(chatRoomId(Global.id,
                                                    documents[index]["id"]))
                                                .collection('chats')
                                                .snapshots(),
                                            builder:
                                                (context, AsyncSnapshot snaps) {
                                              if (snapshot.hasData) {
                                                print(snaps.data?.docs.length ??
                                                    0);
                                                return Visibility(
                                                  visible: (snaps.data?.docs
                                                              .length ??
                                                          0) !=
                                                      0,
                                                  child: Column(
                                                    children: [
                                                      ListTile(
                                                        title: Text(
                                                          documents[index]
                                                              ["name"]!,
                                                          style: const TextStyle(
                                                              color:
                                                                  Colors.black,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                        // subtitle: Text(
                                                        //   display_list[index].last_chat!,
                                                        //   style: const TextStyle(
                                                        //       color: Colors.black),
                                                        // ),
                                                        leading: CircleAvatar(
                                                          maxRadius:
                                                              width(context) *
                                                                  0.065,
                                                          backgroundColor:
                                                              Color(0xFFB4DBFF),
                                                          // backgroundColor: Colors.transparent,
                                                          child: Center(
                                                            child: Icon(
                                                              Icons.person,
                                                              size: width(
                                                                      context) *
                                                                  0.11,
                                                              color: Color(
                                                                  0xFFEAF2FF),
                                                            ),
                                                          ),
                                                        ),
                                                        onTap: () {
                                                          String roomId =
                                                              chatRoomId(
                                                                  Global.id,
                                                                  documents[
                                                                          index]
                                                                      ["id"]);
                                                          print(roomId);
                                                          nextScreen(
                                                              context,
                                                              ChatPage(
                                                                chatRoomId:
                                                                    roomId,
                                                                doc: documents[
                                                                    index],
                                                              ));
                                                        },
                                                      ),
                                                      Visibility(
                                                        visible: index !=
                                                            documents.length -
                                                                1,
                                                        child: Container(
                                                          margin:
                                                              const EdgeInsets
                                                                      .only(
                                                                  left: 8,
                                                                  right: 8),
                                                          child: Divider(
                                                            color:
                                                                Colors.black26,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                );
                                              } else {
                                                return SizedBox(
                                                    width: 0.01, height: 0.01);
                                              }
                                            });
                                      });
 */
