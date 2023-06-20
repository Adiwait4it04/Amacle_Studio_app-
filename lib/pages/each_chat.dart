// ignore_for_file: prefer_const_constructors, sized_box_for_whitespace, prefer_const_literals_to_create_immutables

import 'dart:io';
import 'dart:developer';
import 'package:amacle_studio_app/pages/chat_profile_list.dart';
import 'package:dio/dio.dart';
import 'package:open_file/open_file.dart';

import 'package:audioplayers/audioplayers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:fluttericon/typicons_icons.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:record_mp3/record_mp3.dart';
import 'package:uuid/uuid.dart';
import '../comps/styles.dart';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import '../comps/widgets.dart';
import '../global/globals.dart';
import '../utils/constant.dart';
import 'audio_controller.dart';
import 'bottom_bar_pages/chat_profile_details.dart';

class ChatPage extends StatefulWidget {
  ChatPage({
    super.key,
    required this.doc,
    required this.chatRoomId,
  });

  final DocumentSnapshot doc;
  final String chatRoomId;

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  GlobalKey _popupMenuKey = GlobalKey();

  Future getImage(bool gallery) async {
    ImagePicker _picker = ImagePicker();

    await _picker
        .pickImage(source: gallery ? ImageSource.gallery : ImageSource.camera)
        .then((xFile) {
      if (xFile != null) {
        imageFile = File(xFile.path);
        uploadImage();
      }
    });
  }

  AudioController audioController = Get.put(AudioController());

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
      "sender_id": Global.mainMap[0]["id"],
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

  AudioPlayer audioPlayer = AudioPlayer();

  String audioURL = "";

  Future<bool> checkPermission() async {
    if (!await Permission.microphone.isGranted) {
      PermissionStatus status = await Permission.microphone.request();
      if (status != PermissionStatus.granted) {
        return false;
      }
    }
    return true;
  }

  void startRecord() async {
    setState(() {
      recording = true;
      print("doing");
    });
    bool hasPermission = await checkPermission();
    if (hasPermission) {
      recordFilePath = await getFilePath();
      RecordMp3.instance.start(recordFilePath, (type) {
        setState(() {
          recording = true;
        });
      });
    } else {}
    setState(() {
      print("what");
    });
  }

  bool recording = false;

  late String recordFilePath;

  Future<String> getFilePath() async {
    Directory storageDirectory = await getApplicationDocumentsDirectory();
    String sdPath =
        "${storageDirectory.path}/record${DateTime.now().microsecondsSinceEpoch}.acc";
    var d = Directory(sdPath);
    if (!d.existsSync()) {
      d.createSync(recursive: true);
    }
    return "$sdPath/test_${i++}.mp3";
  }

  int i = 0;

  void stopRecord() async {
    setState(() {
      recording = false;
      print("sdjkdjkdj");
    });
    bool stop = RecordMp3.instance.stop();
    audioController.end.value = DateTime.now();
    audioController.calcDuration();
    var ap = AudioPlayer();
    // await ap.play(AssetSource("Notification.mp3"));
    // ap.onPlayerComplete.listen((a) {});

    if (stop) {
      log("stopped");
      log("stopped");
      log("stopped");
      log("stopped");
      log("stopped");
      audioController.isRecording.value = false;
      audioController.isSending.value = true;
      await uploadAudio(File(recordFilePath));
    }
  }

  uploadAudio(File audioFile) async {
    String fileName = Uuid().v1();
    int status = 1;

    await FirebaseFirestore.instance
        .collection('chatroom')
        .doc(widget.chatRoomId)
        .collection('chats')
        .doc(fileName)
        .set({
      "sendby": Global.mainMap[0]["name"],
      "message": "",
      "type": "audio",
      "sender_id": Global.mainMap[0]["id"],
      "time": FieldValue.serverTimestamp(),
    });

    var ref = FirebaseStorage.instance
        .ref()
        .child('chataudios')
        .child("$fileName.wav");

    var uploadTask = await ref.putFile(audioFile).catchError((error) async {
      await FirebaseFirestore.instance
          .collection('chatroom')
          .doc(widget.chatRoomId)
          .collection('chats')
          .doc(fileName)
          .delete();

      status = 0;
    });

    if (status == 1) {
      String audioUrl = await uploadTask.ref.getDownloadURL();

      await FirebaseFirestore.instance
          .collection('chatroom')
          .doc(widget.chatRoomId)
          .collection('chats')
          .doc(fileName)
          .update({"message": audioUrl});

      log(audioUrl.toString());
    }
  }

  void onSendMessage() async {
    if (_message.text.isNotEmpty) {
      Map<String, dynamic> messages = {
        "sendby": Global.mainMap[0]["name"],
        "message": _message.text,
        "type": "text",
        "sender_id": Global.mainMap[0]["id"],
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

  getDocument() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: [
        'pdf',
        'doc',
        'docx'
      ], // Add more file extensions as needed
    );

    if (result != null) {
      PlatformFile file = result.files.first;

      uploadDocument(file);
    } else {
      Fluttertoast.showToast(
        msg: "Document not selected",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
      );
    }
  }

  Future uploadDocument(PlatformFile documentFile) async {
    String fileName = Uuid().v1();
    int status = 1;

    await FirebaseFirestore.instance
        .collection('chatroom')
        .doc(widget.chatRoomId)
        .collection('chats')
        .doc(fileName)
        .set({
      "sendby": Global.mainMap[0]["name"],
      "message": "",
      "type": "document",
      "sender_id": Global.mainMap[0]["id"],
      "time": FieldValue.serverTimestamp(),
    });

    var ref = FirebaseStorage.instance
        .ref()
        .child('chatdocuments')
        .child("$fileName.${documentFile.extension}");

    var uploadTask =
        await ref.putFile(File(documentFile.path!)).catchError((error) async {
      await FirebaseFirestore.instance
          .collection('chatroom')
          .doc(widget.chatRoomId)
          .collection('chats')
          .doc(fileName)
          .delete();

      status = 0;
    });

    if (status == 1) {
      String documentUrl = await uploadTask.ref.getDownloadURL();

      await FirebaseFirestore.instance
          .collection('chatroom')
          .doc(widget.chatRoomId)
          .collection('chats')
          .doc(fileName)
          .update({"message": documentUrl});

      print(documentUrl);
    }
  }

  openFile(String url, String? fileName) async {
    File file = await downloadFile(url, fileName!);

    if (file == null) return;

    print("Path: ${file.path}");

    print("Nsjs");
    OpenFile.open(file.path);
  }

  downloadFile(String url, String name) async {
    final appStorage = await getApplicationDocumentsDirectory();
    final file = File('${appStorage.path}/$name');

    try {
      final response = await Dio().get(url,
          options: Options(
            responseType: ResponseType.bytes,
            followRedirects: false,
            receiveTimeout: Duration(seconds: 3),
          ));

      final raf = file.openSync(mode: FileMode.write);
      raf.writeFromSync(response.data);
      await raf.close();
      return file;
    } catch (e) {
      return null;
    }
  }

  @override
  final TextEditingController _message = TextEditingController();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Color.fromARGB(255, 243, 242, 242),
      appBar: AppBar(
        actions: [
          Container(
            padding: EdgeInsets.only(right: 7),
            child: CircleAvatar(
              maxRadius: width(context) * 0.055,
              backgroundColor: Color(0xFFB4DBFF),
              // backgroundColor: Colors.transparent,
              child: Center(
                child: InkWell(
                  onTap: () {
                    nextScreen(
                      context,
                      ChatProfileDetails(
                        doc: widget.doc,
                        view: true,
                        share: false,
                        chattingWithUser: null,
                      ),
                    );
                  },
                  child: Icon(
                    Icons.person,
                    size: width(context) * 0.11,
                    color: Color(0xFFEAF2FF),
                  ),
                ),
              ),
            ),
          )
        ],
        backgroundColor: btnColor,
        title: Center(
          child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(widget.doc['name'] + ""),
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
        child: Column(
          children: [
            addVerticalSpace(10),
            Container(
              padding: EdgeInsets.only(left: 2),
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
                        try {
                          return messages(size, map, context, index,
                              snapshot.data!.docs[index].id);
                        } on Exception catch (e) {
                          // Handling the specific exception type
                          print('Caught exception: $e');
                        } catch (e) {
                          // Handling any other exception type
                          print('Caught unknown exception: $e');
                        }
                      },
                    );
                  } else {
                    return Container();
                  }
                },
              ),
            ),
            Container(
              height: size.height / 10,
              width: size.width,
              alignment: Alignment.centerLeft,
              child: Container(
                height: size.height / 12,
                width: size.width / 1.0,
                child: Row(
                  // mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    addHorizontalySpace(width(context) * 0.03),
                    Column(
                      // mainAxisAlignment: MainAxisAlignment.start,
                      // mainAxisSize: MainAxisSize.max,
                      children: [
                        addVerticalSpace(height(context) * 0.014),
                        GestureDetector(
                          onTap: () {
                            final RenderBox popupMenuButtonRenderBox =
                                _popupMenuKey.currentContext!.findRenderObject()
                                    as RenderBox;
                            final popupMenuButtonSize =
                                popupMenuButtonRenderBox.size;
                            final popupMenuButtonPosition =
                                popupMenuButtonRenderBox
                                    .localToGlobal(Offset.zero);
                            final overlay = Overlay.of(context)
                                .context
                                .findRenderObject() as RenderBox;
                            final overlaySize = overlay.size;
                            final overlayPosition =
                                overlay.localToGlobal(Offset.zero);

                            showMenu(
                              context: context,
                              position: RelativeRect.fromLTRB(
                                popupMenuButtonPosition.dx,
                                popupMenuButtonPosition.dy -
                                    overlayPosition.dy +
                                    popupMenuButtonSize.height,
                                overlaySize.width -
                                    popupMenuButtonPosition.dx -
                                    popupMenuButtonSize.width,
                                overlaySize.height -
                                    (popupMenuButtonPosition.dy -
                                        overlayPosition.dy),
                              ),
                              items: [
                                PopupMenuItem<IconData>(
                                  value: Typicons.doc,
                                  onTap: () {
                                    getDocument();
                                  },
                                  child: Icon(
                                    Typicons.doc,
                                    color: btnColor,
                                  ),
                                ),
                                PopupMenuItem<IconData>(
                                  value: CupertinoIcons.person_solid,
                                  onTap: () {
                                    print("jmdd");
                                    // goBack(context);
                                    Future.delayed(Duration(seconds: 1), () {
                                      Get.to(() => ChatProfileList(
                                          currentlyChattingWith: widget.doc));
                                    });
                                  },
                                  child: Icon(
                                    CupertinoIcons.person_solid,
                                    color: btnColor,
                                  ),
                                ),
                                PopupMenuItem<IconData>(
                                  value: Icons.camera,
                                  child: Icon(
                                    Icons.camera,
                                    color: btnColor,
                                  ),
                                ),
                              ],
                              elevation: 8,
                            ).then((selectedValue) {
                              if (selectedValue == Icons.camera) {
                                // Handle icon selection
                                getImage(false);
                              }
                            });
                          },
                          key: _popupMenuKey,
                          child: Icon(Icons.add),
                        ),
                      ],
                    ),
                    addHorizontalySpace(width(context) * 0.02),
                    Container(
                      height: size.height / 17,
                      width: size.width / 1.58,
                      child: TextField(
                        textAlign: TextAlign.left,
                        controller: _message,
                        decoration: InputDecoration(
                            suffixIcon: IconButton(
                              onPressed: () => getImage(true),
                              icon: Icon(
                                Icons.photo,
                                color: btnColor,
                              ),
                            ),
                            // suffix: Row(
                            //   crossAxisAlignment: CrossAxisAlignment.end,
                            //   mainAxisAlignment: MainAxisAlignment.end,
                            //   children: [
                            //     IconButton(
                            //       onPressed: () => getImage(),
                            //       icon: Icon(
                            //         Icons.photo,
                            //         color: btnColor,
                            //       ),
                            //     ),
                            //     IconButton(
                            //       onPressed: () => getImage(),
                            //       icon: Icon(Icons.mic),
                            //     ),
                            //   ],
                            // ),
                            hintText: "Send Message",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            )),
                      ),
                    ),
                    IconButton(
                      onPressed: () => recording ? stopRecord() : startRecord(),
                      icon: Icon(
                        Icons.mic,
                        color: !recording ? btnColor : Colors.red,
                      ),
                    ),
                    IconButton(
                        icon: Icon(
                          Icons.send,
                          size: 19,
                        ),
                        onPressed: onSendMessage),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget messages(Size size, Map<String, dynamic> map, BuildContext context,
      int index, String docId) {
    return GestureDetector(
        onLongPress: () {
          if (true) {
            final RenderBox popupMenuButtonRenderBox =
                _popupMenuKey.currentContext!.findRenderObject() as RenderBox;
            final popupMenuButtonSize = popupMenuButtonRenderBox.size;
            final popupMenuButtonPosition =
                popupMenuButtonRenderBox.localToGlobal(Offset.zero);
            final overlay =
                Overlay.of(context).context.findRenderObject() as RenderBox;
            final overlaySize = overlay.size;
            final overlayPosition = overlay.localToGlobal(Offset.zero);

            showMenu(
              context: context,
              position: RelativeRect.fromLTRB(
                popupMenuButtonPosition.dx,
                popupMenuButtonPosition.dy -
                    overlayPosition.dy +
                    popupMenuButtonSize.height,
                overlaySize.width -
                    popupMenuButtonPosition.dx -
                    popupMenuButtonSize.width,
                overlaySize.height -
                    (popupMenuButtonPosition.dy - overlayPosition.dy),
              ),
              items: [
                PopupMenuItem(
                    value: Icons.delete,
                    child: InkWell(
                      child: ListTile(
                        leading: Icon(
                          CupertinoIcons.delete,
                          color: btnColor,
                        ),
                        title: Text("Delete"),
                      ),
                    )),
              ],
              elevation: 8,
            ).then((selectedValue) async {
              if (selectedValue == Icons.delete) {
                await FirebaseFirestore.instance
                    .collection('chatroom')
                    .doc(widget.chatRoomId)
                    .collection('chats')
                    .doc(docId)
                    .delete()
                    .then((value) {
                  print("Message deleted");
                }).catchError((err) {
                  Fluttertoast.showToast(
                    msg: "Message already deleted",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    timeInSecForIosWeb: 1,
                  );
                });
              }
            });
          }
        },
        child: Container(child: messagesNext(size, map, context, index)));
  }

  Widget messagesNext(
      Size size, Map<String, dynamic> map, BuildContext context, int index) {
    Timestamp firestoreTimestamp = map["time"];
    DateTime dateTime = firestoreTimestamp.toDate();
    String formattedTime = DateFormat('h:mm a').format(dateTime);

    if (map['type'] == "text") {
      return Container(
        width: size.width,
        alignment: map['sendby'] == Global.mainMap[0]["name"]
            ? Alignment.centerRight
            : Alignment.centerLeft,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 14),
          margin: EdgeInsets.symmetric(vertical: 5, horizontal: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color:
                map['sendby'] == Global.mainMap[0]["name"] ? btnColor : white,
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
      );
    } else {
      if (map['type'] == "img") {
        return Container(
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
                      alignment: map['message'] != "" ? null : Alignment.center,
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
      } else if (map['type'] == "document") {
        return Container(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            // height: size.height / 2.21,
            width: size.width,
            padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
            alignment: map['sendby'] == Global.mainMap[0]["name"]
                ? Alignment.centerRight
                : Alignment.centerLeft,
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
              child: GestureDetector(
                onTap: () async {
                  openFile(map["message"], "jdjd");

                  // nextScreen(context, ShowDoc(url: map["message"]));
                },
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
                      // height: size.height / 2.67,
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
                      alignment: map['message'] != "" ? null : Alignment.center,
                      child: map['message'] != ""
                          ? Image.asset("assets/document.png",
                              fit: BoxFit.cover)
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
      } else if (map['type'] == "contact") {
        return Container(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            // height: size.height / 2.21,
            width: size.width * 0.6,
            padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
            alignment: map['sendby'] == Global.mainMap[0]["name"]
                ? Alignment.centerRight
                : Alignment.centerLeft,
            child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection("users")
                    .where("id", isEqualTo: map["id"])
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    List<DocumentSnapshot> documents = snapshot.data!.docs;
                    return Container(
                      width: width(context) * 0.6,
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
                      child: GestureDetector(
                        onTap: () async {
                          log(documents[0].data().toString());

                          nextScreen(
                              context,
                              ChatProfileDetails(
                                doc: documents[0],
                                view: false,
                                share: false,
                                chattingWithUser: null,
                              ));
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              DateFormat('d MMMM y').format(DateTime.parse(
                                  map['time']
                                      .toDate()
                                      .toString()
                                      .split(' ')[0])),
                              style: TextStyle(
                                fontSize: 8.5,
                                fontWeight: FontWeight.w800,
                                color:
                                    map['sendby'] == Global.mainMap[0]["name"]
                                        ? white
                                        : black,
                              ),
                            ),
                            addVerticalSpace(height(context) * 0.004),
                            Container(
                              // height: size.height / 2.67,
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
                              alignment: map['message'] != ""
                                  ? null
                                  : Alignment.center,
                              child: map['id'] > 0
                                  ? Container(
                                      width: width(context) * 0.5,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          CircleAvatar(
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
                                          addHorizontalySpace(8),
                                          Text(
                                            documents[0]["name"]!,
                                            style: TextStyle(
                                                color: map['sendby'] ==
                                                        Global.mainMap[0]
                                                            ["name"]
                                                    ? white
                                                    : black,
                                                fontWeight: FontWeight.bold),
                                          )
                                        ],
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
                                color:
                                    map['sendby'] == Global.mainMap[0]["name"]
                                        ? white
                                        : black,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  } else {
                    return Container(
                      width: 20,
                      height: 20,
                      color: Colors.transparent,
                    );
                  }
                }),
          ),
        );
      } else {
        return Container(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            // height: size.height / 2.21,
            width: size.width,
            padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
            alignment: map['sendby'] == Global.mainMap[0]["name"]
                ? Alignment.centerRight
                : Alignment.centerLeft,
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
                    // height: size.height / 2.67,
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
                    alignment: map['message'] != "" ? null : Alignment.center,
                    child: map['message'] != ""
                        ? _audio(
                            message: map["message"],
                            index: index,
                            isCurrentUser:
                                map['sendby'] == Global.mainMap[0]["name"])
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
        );
      }
    }
  }

  Widget _audio({
    required String message,
    required bool isCurrentUser,
    required int index,
  }) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.5,
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: isCurrentUser ? btnColor : btnColor.withOpacity(0.18),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              audioController.onPressedPlayButton(index, message);
              // changeProg(duration: duration);
            },
            onSecondaryTap: () {
              audioPlayer.stop();
              //   audioController.completedPercentage.value = 0.0;
            },
            child: Obx(
              () => (audioController.isRecordPlaying &&
                      audioController.currentId == index)
                  ? Icon(
                      Icons.cancel,
                      color: isCurrentUser ? Colors.white : btnColor,
                    )
                  : Icon(
                      Icons.play_arrow,
                      color: isCurrentUser ? Colors.white : btnColor,
                    ),
            ),
          ),
          Obx(
            () => Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 0),
                child: Stack(
                  clipBehavior: Clip.none,
                  alignment: Alignment.center,
                  children: [
                    // Text(audioController.completedPercentage.value.toString(),style: TextStyle(color: Colors.white),),
                    LinearProgressIndicator(
                      minHeight: 5,
                      backgroundColor: Colors.grey,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        isCurrentUser ? Colors.white : btnColor,
                      ),
                      value: (audioController.isRecordPlaying &&
                              audioController.currentId == index)
                          ? audioController.completedPercentage.value
                          : audioController.totalDuration.value.toDouble(),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(
            width: 10,
          ),
        ],
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

class ShowDoc extends StatelessWidget {
  final String url;

  const ShowDoc({required this.url, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    late WebViewController webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {},
          onPageStarted: (String url) {},
          onPageFinished: (String url) {},
          onWebResourceError: (WebResourceError error) {},
          onNavigationRequest: (NavigationRequest request) {
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(url));

    return Scaffold(
      body: Center(
        child: WebViewWidget(
          controller: webViewController,
        ),
      ),
    );
  }
}
