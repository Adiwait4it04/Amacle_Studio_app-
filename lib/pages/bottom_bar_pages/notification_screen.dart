import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../global/globals.dart';
import '../../utils/app_text.dart';
import '../../utils/constant.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.only(left: 10, right: 10),
          width: width(context),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              addVerticalSpace(60),
              Container(
                child: AppText(
                  text: "Notifications",
                  color: black,
                  fontWeight: FontWeight.bold,
                  size: 22,
                ),
              ),
              addVerticalSpace(20),
              StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection("notifications")
                      .where("to", arrayContains: Global.mainMap[0]["id"])
                      .orderBy("timestamp", descending: true)
                      .snapshots(),
                  builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasData) {
                      List<DocumentSnapshot> documents = snapshot.data!.docs;
                      return Column(
                        children: List.generate(documents.length, (index) {
                          return Column(
                            children: [
                              ListTile(
                                title: Text(
                                  documents[index]["heading"]!,
                                  style: const TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold),
                                ),
                                subtitle: Text(
                                  documents[index]["text"]!,
                                  style: const TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w400),
                                ),
                                leading: CircleAvatar(
                                  maxRadius: width(context) * 0.065,
                                  backgroundColor: Color(0xFFB4DBFF),
                                  // backgroundColor: Colors.transparent,
                                  child: Center(
                                    child: Icon(
                                      Icons.notification_important,
                                      size: width(context) * 0.11,
                                      color: Color(0xFFEAF2FF),
                                    ),
                                  ),
                                ),
                              ),
                              Visibility(
                                visible: index != documents.length - 1,
                                child: Container(
                                  margin:
                                      const EdgeInsets.only(left: 8, right: 8),
                                  child: Divider(
                                    color: Colors.black26,
                                  ),
                                ),
                              ),
                            ],
                          );
                        }),
                      );
                    } else {
                      return Container();
                    }
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
