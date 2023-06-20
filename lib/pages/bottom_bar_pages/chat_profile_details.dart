import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttericon/typicons_icons.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../global/globals.dart';
import '../../utils/app_text.dart';
import '../../utils/constant.dart';
import '../../utils/expandable_text.dart';
import '../each_chat.dart';

class ChatProfileDetails extends StatefulWidget {
  ChatProfileDetails({
    Key? key,
    required this.doc,
    required this.view,
    required this.chattingWithUser,
    this.share = true,
  }) : super(key: key);

  final DocumentSnapshot doc;
  final bool view;
  bool share;
  DocumentSnapshot? chattingWithUser;

  @override
  _ChatProfileDetailsState createState() => _ChatProfileDetailsState();
}

class _ChatProfileDetailsState extends State<ChatProfileDetails> {
  void _launchPhone(String phoneNumber) async {
    final Uri phoneUri = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(phoneUri)) {
      await launchUrl(phoneUri);
    } else {
      Fluttertoast.showToast(
        msg: "Could not make a call",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
      );
    }
  }

  String chatRoomId(int userId1, int userId2) {
    if (userId1 > userId2) {
      return "${userId1}chat${userId2}";
    } else {
      return "${userId2}chat${userId1}";
    }
  }

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    print(widget.doc.data().toString());
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.only(left: 15, right: 15),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                addVerticalSpace(25),
                SizedBox(
                  // height: width(context),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            maxRadius: width(context) * 0.065,
                            backgroundColor: Color(0xFFB4DBFF),
                            // backgroundColor: Colors.transparent,
                            child: Center(
                              child: Icon(
                                Icons.person,
                                size: width(context) * 0.12,
                                color: Color(0xFFEAF2FF),
                              ),
                            ),
                          ),
                          addHorizontalySpace(10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              AppText(
                                text: widget.doc["name"],
                                color: black,
                                size: width(context) * 0.05,
                                fontWeight: FontWeight.w800,
                              ),
                              AppText(
                                text: widget.doc["phno"],
                                color: Colors.black38,
                                size: width(context) * 0.035,
                              ),
                            ],
                          )
                        ],
                      ),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: SizedBox(
                          width: width(context) * 0.28,
                          height: height(context) * 0.065,
                          child: TextButton(
                            onPressed: () {
                              _launchPhone(widget.doc["phno"]);
                            },
                            style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all(btnColor)),
                            child: Center(
                                child: Row(
                              children: [
                                addHorizontalySpace(10),
                                Icon(
                                  Icons.call,
                                  color: white,
                                ),
                                addHorizontalySpace(5),
                                AppText(
                                  text: "Call",
                                  size: 16,
                                  fontWeight: FontWeight.w700,
                                ),
                                addHorizontalySpace(10),
                              ],
                            )),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                addVerticalSpace(15),
                Visibility(
                  visible: !widget.view && widget.share,
                  child: IconButton(
                    icon: Icon(Icons.share),
                    onPressed: () async {
                      Map<String, dynamic> messages = {
                        "sendby": Global.mainMap[0]["name"],
                        "message": "",
                        "id": widget.doc["id"],
                        "type": "contact",
                        "time": FieldValue.serverTimestamp(),
                      };

                      String roomId =
                          chatRoomId(Global.id, widget.chattingWithUser!["id"]);

                      await FirebaseFirestore.instance
                          .collection('chatroom')
                          .doc(roomId)
                          .collection('chats')
                          .add(messages)
                          .then((value) {
                        Fluttertoast.showToast(
                          msg: "Profile Shared",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          timeInSecForIosWeb: 1,
                        );
                      }).catchError((err) {
                        Fluttertoast.showToast(
                          msg: "Could not share Profile",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          timeInSecForIosWeb: 1,
                        );
                      });
                    },
                  ),
                ),
                AppText(
                  text: "Bio",
                  color: Colors.black45,
                  size: 17,
                  fontWeight: FontWeight.w700,
                ),
                ExpandableText(
                  text: widget.doc["bio"],
                  textHeight: 300,
                  color: Colors.black54,
                  size: 16,
                ),
                addVerticalSpace(20),
                Row(
                  children: [
                    AppText(
                      text: "Links",
                      color: Colors.black87,
                      size: 19,
                    ),
                    addHorizontalySpace(6),
                    Icon(
                      Icons.link,
                      size: 26,
                    ),
                  ],
                ),
                addVerticalSpace(20),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      Icon(
                        Typicons.github,
                        size: 28,
                      ),
                      addHorizontalySpace(5),
                      AppText(
                        text: widget.doc["github"],
                        color: themeColor,
                        size: 14.5,
                      ),
                      addHorizontalySpace(6),
                    ],
                  ),
                ),
                addVerticalSpace(20),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      Icon(
                        Typicons.mail,
                        size: 26,
                      ),
                      addHorizontalySpace(5),
                      AppText(
                        text: widget.doc["email"],
                        color: themeColor,
                        size: 14.5,
                      ),
                      addHorizontalySpace(6),
                    ],
                  ),
                ),
                addVerticalSpace(20),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      Icon(
                        Typicons.linkedin,
                        size: 26,
                      ),
                      addHorizontalySpace(5),
                      AppText(
                        text: widget.doc["linkedin"],
                        color: themeColor,
                        size: 14.5,
                      ),
                      addHorizontalySpace(6),
                    ],
                  ),
                ),
                addVerticalSpace(height(context) * 0.2),
                Visibility(
                  visible: !widget.view,
                  child: Center(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: SizedBox(
                          width: width(context) * 0.9,
                          height: width(context) * 0.2,
                          child: TextButton(
                              onPressed: () {
                                String roomId =
                                    chatRoomId(Global.id, widget.doc["id"]);
                                print(roomId);
                                nextScreen(
                                    context,
                                    ChatPage(
                                      chatRoomId: roomId,
                                      doc: widget.doc,
                                    ));
                              },
                              style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all(btnColor)),
                              child: AppText(
                                text: "Start Chat",
                                fontWeight: FontWeight.bold,
                                size: 18,
                              ))),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
