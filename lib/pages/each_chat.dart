// ignore_for_file: prefer_const_constructors, sized_box_for_whitespace, prefer_const_literals_to_create_immutables

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
import '../comps/styles.dart';
import '../comps/widgets.dart';
import '../global/globals.dart';
import '../utils/constant.dart';

class ChatPage extends StatefulWidget {
  ChatPage({super.key, required this.doc, required this.chatRoomId});

  final DocumentSnapshot doc;
  final String chatRoomId;

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.addListener(() {
        if (_scrollController.position.maxScrollExtent ==
            _scrollController.offset) {
          // Scroll controller is at the bottom
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        }
      });

      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future getImage() async {
    ImagePicker _picker = ImagePicker();

    await _picker.pickImage(source: ImageSource.gallery).then((xFile) {
      if (xFile != null) {
        imageFile = File(xFile.path);
        uploadImage();
      }
    });
  }

  Future uploadImage() async {
    String fileName = Uuid().v1();
    int status = 1;

    await _firestore
        .collection('chatroom')
        .doc(widget.chatRoomId)
        .collection('chats')
        .doc(fileName)
        .set({
      "sendby": Global.mainMap[0]["name"],
      "message": "",
      "type": "img",
      "time": FieldValue.serverTimestamp(),
    });

    var ref = FirebaseStorage.instance
        .ref()
        .child('chatimages')
        .child("$fileName.jpg");

    var uploadTask = await ref.putFile(imageFile!).catchError((error) async {
      await _firestore
          .collection('chatroom')
          .doc(widget.chatRoomId)
          .collection('chats')
          .doc(fileName)
          .delete();

      status = 0;
    });

    if (status == 1) {
      String imageUrl = await uploadTask.ref.getDownloadURL();

      await _firestore
          .collection('chatroom')
          .doc(widget.chatRoomId)
          .collection('chats')
          .doc(fileName)
          .update({"message": imageUrl});

      print(imageUrl);
    }
  }

  void onSendMessage() async {
    if (_message.text.isNotEmpty) {
      Map<String, dynamic> messages = {
        "sendby": Global.mainMap[0]["name"],
        "message": _message.text,
        "type": "text",
        "time": FieldValue.serverTimestamp(),
      };

      _message.clear();
      await _firestore
          .collection('chatroom')
          .doc(widget.chatRoomId)
          .collection('chats')
          .add(messages);
      _message.clear();
    } else {
      print("Enter Some Text");
    }
  }

  File? imageFile;

  @override
  final TextEditingController _message = TextEditingController();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Color.fromARGB(255, 243, 242, 242),
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: btnColor,
        title: Center(
          child: Container(
            color: btnColor,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(widget.doc['name']),
              ],
            ),
          ),
        ),
        // leading: IconButton(
        //   icon: Icon(Icons.arrow_back),
        //   onPressed: () {
        //     goBack(context);
        //   },
        // ),
      ),
      body: SingleChildScrollView(
        controller: _scrollController,
        reverse: true,
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.only(left: 7),
              height: size.height / 1.25,
              width: size.width,
              child: StreamBuilder<QuerySnapshot>(
                stream: _firestore
                    .collection('chatroom')
                    .doc(widget.chatRoomId)
                    .collection('chats')
                    .orderBy("time", descending: false)
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.data != null) {
                    return ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        Map<String, dynamic> map = snapshot.data!.docs[index]
                            .data() as Map<String, dynamic>;
                        return messages(size, map, context);
                      },
                    );
                  } else {
                    return Container();
                  }
                },
              ),
            ),
            Container(
              // height: size.height / 10,
              width: size.width,
              alignment: Alignment.center,
              child: Container(
                // height: size.height / 12,
                width: size.width / 1.1,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: size.height / 17,
                      width: size.width / 1.3,
                      child: TextField(
                        controller: _message,
                        decoration: InputDecoration(
                            suffixIcon: IconButton(
                              onPressed: () => getImage(),
                              icon: Icon(Icons.photo),
                            ),
                            hintText: "Send Message",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            )),
                      ),
                    ),
                    IconButton(
                        icon: Icon(Icons.send), onPressed: onSendMessage),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget messages(Size size, Map<String, dynamic> map, BuildContext context) {
    Timestamp firestoreTimestamp = map["time"];
    DateTime dateTime = firestoreTimestamp.toDate();
    String formattedTime = DateFormat('h:mm a').format(dateTime);

    return map['type'] == "text"
        ? Container(
            width: size.width,
            alignment: map['sendby'] == Global.mainMap[0]["name"]
                ? Alignment.centerRight
                : Alignment.centerLeft,
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 14),
              margin: EdgeInsets.symmetric(vertical: 5, horizontal: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: map['sendby'] == Global.mainMap[0]["name"]
                    ? btnColor
                    : white,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    DateFormat('d MMMM y').format(DateTime.parse(
                        map['time'].toDate().toString().split(' ')[0])),
                    style: TextStyle(
                      fontSize: 8.5,
                      fontWeight: FontWeight.w800,
                      color: map['sendby'] == Global.mainMap[0]["name"]
                          ? white
                          : black,
                    ),
                  ),
                  Text(
                    map['message'],
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: !(map['sendby'] == Global.mainMap[0]["name"])
                          ? black
                          : Colors.white,
                    ),
                  ),
                  Text(
                    formattedTime,
                    style: TextStyle(
                      fontSize: 8.5,
                      fontWeight: FontWeight.w800,
                      color: map['sendby'] == Global.mainMap[0]["name"]
                          ? white
                          : black,
                    ),
                  ),
                ],
              ),
            ),
          )
        : Container(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              // height: size.height / 2.21,
              width: size.width,
              padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
              alignment: map['sendby'] == Global.mainMap[0]["name"]
                  ? Alignment.centerRight
                  : Alignment.centerLeft,
              child: InkWell(
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => ShowImage(
                      imageUrl: map['message'],
                    ),
                  ),
                ),
                child: Container(
                  padding: EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    color: map['sendby'] == Global.mainMap[0]["name"]
                        ? btnColor
                        : white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(),
                    // boxShadow: [
                    //   BoxShadow(
                    //     blurRadius: 2,
                    //     color: Colors.black38,
                    //     offset: Offset(1, 2),
                    //   ),
                    // ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        DateFormat('d MMMM y').format(DateTime.parse(
                            map['time'].toDate().toString().split(' ')[0])),
                        style: TextStyle(
                          fontSize: 8.5,
                          fontWeight: FontWeight.w800,
                          color: map['sendby'] == Global.mainMap[0]["name"]
                              ? white
                              : black,
                        ),
                      ),
                      addVerticalSpace(height(context) * 0.004),
                      Container(
                        height: size.height / 2.67,
                        // width: size.width / 2,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          // border: Border.all(),
                          //   boxShadow: [
                          //     BoxShadow(
                          //       blurRadius: 2,
                          //       color: Colors.black38,
                          //       offset: Offset(1, 2),
                          //     ),
                          //   ],
                        ),
                        alignment:
                            map['message'] != "" ? null : Alignment.center,
                        child: map['message'] != ""
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.network(
                                  map['message'],
                                  fit: BoxFit.cover,
                                ),
                              )
                            : CircularProgressIndicator(),
                      ),
                      addVerticalSpace(height(context) * 0.004),
                      Text(
                        formattedTime,
                        style: TextStyle(
                          fontSize: 8.5,
                          fontWeight: FontWeight.w800,
                          color: map['sendby'] == Global.mainMap[0]["name"]
                              ? white
                              : black,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
  }
}

class ShowImage extends StatelessWidget {
  final String imageUrl;

  const ShowImage({required this.imageUrl, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        height: size.height,
        width: size.width,
        color: Colors.black,
        child: Image.network(imageUrl),
      ),
    );
  }
}

Widget messages(Size size, Map<String, dynamic> map, BuildContext context) {
  return map['type'] == "text"
      ? Container(
          width: size.width,
          alignment: map['sendby'] == ""
              ? Alignment.centerRight
              : Alignment.centerLeft,
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 14),
            margin: EdgeInsets.symmetric(vertical: 5, horizontal: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: btnColor,
            ),
            child: Text(
              map['message'],
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
          ),
        )
      : Container(
          height: size.height / 2.5,
          width: size.width,
          padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
          alignment: map['sendby'] == ""
              ? Alignment.centerRight
              : Alignment.centerLeft,
          child: InkWell(
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => ShowImage(
                  imageUrl: map['message'],
                ),
              ),
            ),
            child: Container(
              height: size.height / 2.5,
              width: size.width / 2,
              decoration: BoxDecoration(border: Border.all()),
              alignment: map['message'] != "" ? null : Alignment.center,
              child: map['message'] != ""
                  ? Image.network(
                      map['message'],
                      fit: BoxFit.cover,
                    )
                  : CircularProgressIndicator(),
            ),
          ),
        );
}
