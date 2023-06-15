// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, dead_code

import 'dart:developer';
import 'dart:io';

import 'package:amacle_studio_app/utils/app_text.dart';
import 'package:amacle_studio_app/utils/widgets.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../utils/constant.dart';
import '../utils/styles.dart';

class ProjectDetailScreen extends StatefulWidget {
  const ProjectDetailScreen({Key? key}) : super(key: key);

  @override
  _ProjectDetailScreenState createState() => _ProjectDetailScreenState();
}

class _ProjectDetailScreenState extends State<ProjectDetailScreen> {
  ImagePicker picker = ImagePicker();
  List<File?> imageList = [];

  final TextEditingController title = TextEditingController();
  final TextEditingController body = TextEditingController();

  bool justEntered = true;

  @override
  initState() {
    super.initState();
  }

  aletDialog(BuildContext context) {
    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Add a todo'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: title,
              decoration: InputDecoration(labelText: 'Enter title'),
            ),
            TextField(
              controller: body,
              decoration: InputDecoration(labelText: 'Enter content'),
            ),
          ],
        ),
        actions: [
          TextButton(
            child: Text('Cancel'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: Text('Submit'),
            onPressed: () {
              if (title.text.isNotEmpty && body.text.isNotEmpty) {
                createIssue(username, repoName, title.text.trim(),
                    body.text.trim(), personalAccessToken);
                Fluttertoast.showToast(
                  msg: "Todo added",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 1,
                );
                setState(() {});
                Navigator.of(context).pop();
              } else if (title.text.isEmpty && body.text.isEmpty) {
                Fluttertoast.showToast(
                  msg: "Please enter the required fields",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 1,
                );
              } else if (title.text.isEmpty) {
                Fluttertoast.showToast(
                  msg: "Please enter the title",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 1,
                );
              } else {
                Fluttertoast.showToast(
                  msg: "Please enter the content",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 1,
                );
              }
            },
          ),
        ],
        backgroundColor: Colors.white,
        elevation: 2,
      ),
    );
    setState(() {});
  }

  Future<void> createIssue(String repoOwner, String repoName, String issueTitle,
      String issueBody, String authToken) async {
    String apiUrls =
        'https://api.github.com/' + 'repos/$repoOwner/$repoName/issues';

    Map<String, String> headers = {
      'Authorization': 'token $authToken',
      'Content-Type': 'application/json',
    };

    Map<String, dynamic> requestBody = {
      'title': issueTitle,
      'body': issueBody,
    };

    http.Response response = await http.post(Uri.parse(apiUrls),
        headers: headers, body: json.encode(requestBody));

    if (response.statusCode == 201) {
      // Issue created successfully
      print('Issue created successfully');
      setState(() {});
    } else {
      print('API request failed: ${response.statusCode}');
    }
  }

  resolveIssue(String repoOwner, String repoName, String issueNumber,
      String authToken, int index, List<bool> check) async {
    String apiUrl =
        "https://api.github.com/repos/$repoOwner/$repoName/issues/$issueNumber";
    String authHeaderValue = "token $authToken";

    try {
      http.Response response = await http.patch(
        Uri.parse(apiUrl),
        headers: {
          'Authorization': authHeaderValue,
          'Content-Type': 'application/json'
        },
        body: jsonEncode(
            {'state': 'closed'}), // Update the issue state to 'closed'
      );

      print(response.statusCode);
      print(response.body);
      print(response.statusCode);

      if (response.statusCode == 200) {
        dynamic resolvedIssue = jsonDecode(response.body);
        print('Issue resolved successfully');
        check[index] = true;
        print(response.body);
      } else {
        check[index] = false;
        print('Failed to resolve issue');
      }
    } catch (e) {
      check[index] = false;
      print('Failed to connect to the server');
    }
  }

  fetchIssues(String repoOwner, String repoName, String authToken) async {
    String apiUrl = "https://api.github.com/repos/$repoOwner/$repoName/issues";
    String authHeaderValue = "token $authToken";

    try {
      http.Response response = await http
          .get(Uri.parse(apiUrl), headers: {'Authorization': authHeaderValue});

      if (response.statusCode == 200) {
        List<dynamic> issues = jsonDecode(response.body);
        // map = jsonDecode(response.body)[0];
        // print(response.body);
        mapResponse = {
          "message": "success",
          "data": response.body,
        };
        list = await jsonDecode(response.body);
        return mapResponse;
      } else {
        mapResponse = {
          "message": "failure",
        };
        return mapResponse;
      }
    } catch (e) {
      mapResponse = {
        "message": "failure",
      };
    }
  }

  Map<String, dynamic> mapResponse = {};
  List list = [];

  final String personalAccessToken = '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';
  final String username = 'Manvendra-Singh-SMCIC';
  final String apiUrl = 'https://api.github.com';
  final String repoName = 'Bubble-Trouble';

  @override
  Widget build(BuildContext context) {
    try {
      return Scaffold(
        body: FutureBuilder(
          // future: fetchIssues(username, repoName, personalAccessToken),
          builder: (context, snapshot) {
            if (false) {
              return Center(child: CircularProgressIndicator());
            } else if (true) {
              // log(mapResponse);
              log(list.length.toString());
              return Container(
                height: height(context),
                color: Colors.grey.withOpacity(0.18),
                padding: EdgeInsets.fromLTRB(15, 20, 15, 0),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      addVerticalSpace(height(context) * 0.03),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: AppText(
                          text: "Poultry App",
                          size: width(context) * 0.078,
                          color: black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          addVerticalSpace(height(context) * 0.03),
                          Container(
                            width: width(context) * 0.9,
                            height: height(context) * 0.23,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              color: themeColor,
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 0.45 * width(context),
                                  child: CircularPercentIndicator(
                                    radius: width(context) * 0.18,
                                    lineWidth: 12,
                                    percent: 0.54,
                                    progressColor: white,
                                    backgroundColor:
                                        Colors.white12.withOpacity(0.25),
                                    circularStrokeCap: CircularStrokeCap.round,
                                    center: Center(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          AppText(
                                            text: "54%",
                                            size: width(context) * 0.1,
                                            color: white,
                                          ),
                                          AppText(
                                            text: "Completed",
                                            size: width(context) * 0.04,
                                            color: white,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  width: 0.45 * width(context),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Row(
                                        children: [
                                          AppText(
                                            text: "₹1000",
                                            size: width(context) * 0.088,
                                            color: white,
                                          ),
                                          addHorizontalySpace(8),
                                          AppText(
                                            text: "+1000",
                                            size: width(context) * 0.03,
                                            color: Color.fromARGB(
                                                255, 120, 227, 124),
                                          ),
                                        ],
                                      ),
                                      RichText(
                                        text: TextSpan(
                                          text: "Deadline: ",
                                          style: TextStyle(
                                            color: white,
                                            fontSize: width(context) * 0.045,
                                          ),
                                          children: [
                                            TextSpan(
                                              text: "21 May 2023",
                                              style: TextStyle(
                                                color: Colors.white70,
                                                fontSize:
                                                    width(context) * 0.035,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      RichText(
                                        text: TextSpan(
                                          text: "Expected: ",
                                          style: TextStyle(
                                            color: white,
                                            fontSize: width(context) * 0.045,
                                          ),
                                          children: [
                                            TextSpan(
                                              text: "23 May 2023",
                                              style: TextStyle(
                                                color: Colors.white70,
                                                fontSize:
                                                    width(context) * 0.035,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      addVerticalSpace(height(context) * 0.009),
                                      Container(
                                        width: width(context) * 0.4,
                                        height: 30,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(13),
                                          color: Colors.red,
                                        ),
                                        child: Center(
                                          child: RichText(
                                            text: TextSpan(
                                              text: "Delay  ",
                                              style: TextStyle(
                                                color: white,
                                                fontSize:
                                                    width(context) * 0.045,
                                              ),
                                              children: [
                                                TextSpan(
                                                  text: "  2 Days",
                                                  style: TextStyle(
                                                    color: Colors.white70,
                                                    fontSize:
                                                        width(context) * 0.045,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          addVerticalSpace(20),
                          Container(
                            width: 0.9 * width(context),
                            // height: 0.11 * height(context),
                            decoration: BoxDecoration(
                              color: white,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            padding: EdgeInsets.fromLTRB(8, 4, 1, 3),
                            child: InkWell(
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: width(context) * 0.25,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        addVerticalSpace(
                                            height(context) * 0.029),
                                        CircleAvatar(
                                          maxRadius: width(context) * 0.06,
                                          backgroundColor:
                                              themeColor.withOpacity(0.12),
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(200),
                                            child: Icon(
                                              Icons.call,
                                              color: themeColor,
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(top: 5),
                                    width: 1.5,
                                  ),
                                  Container(
                                    padding: EdgeInsets.fromLTRB(
                                      width(context) * 0.02,
                                      width(context) * 0.05,
                                      width(context) * 0.01,
                                      width(context) * 0.02,
                                    ),
                                    width: width(context) * 0.62,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        addHorizontalySpace(
                                            width(context) * 0.025),
                                        AppText(
                                          text: "Google Meet: New Update",
                                          color: black,
                                          size: width(context) * 0.043,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        addVerticalSpace(
                                            height(context) * 0.005),
                                        AppText(
                                          text: "4:00 PM > 5:30 PM",
                                          color: grey.withOpacity(0.5),
                                          size: width(context) * 0.037,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        RichText(
                                          text: TextSpan(children: [
                                            WidgetSpan(
                                              child: Padding(
                                                padding:
                                                    EdgeInsets.only(left: 2.0),
                                                child: Icon(
                                                  Icons.copy,
                                                  size: width(context) * 0.06,
                                                  color: Colors.black54,
                                                ),
                                              ),
                                            ),
                                            TextSpan(
                                              text: "  Copy Link",
                                              style: TextStyle(
                                                color: Colors.black54,
                                                fontSize:
                                                    width(context) * 0.037,
                                              ),
                                            )
                                          ]),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      addVerticalSpace(height(context) * 0.017),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          AppText(
                            text: "To-Do's",
                            color: black,
                            size: width(context) * 0.05,
                            fontWeight: FontWeight.bold,
                          ),
                          InkWell(
                            onTap: () async {
                              return await showDialog(
                                barrierDismissible: false,
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: Text('Add a todo'),
                                  content: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      TextField(
                                        controller: title,
                                        decoration: InputDecoration(
                                            labelText: 'Enter title'),
                                      ),
                                      TextField(
                                        controller: body,
                                        decoration: InputDecoration(
                                            labelText: 'Enter content'),
                                      ),
                                    ],
                                  ),
                                  actions: [
                                    TextButton(
                                      child: Text('Cancel'),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                    TextButton(
                                      child: Text('Submit'),
                                      onPressed: () {
                                        if (title.text.isNotEmpty &&
                                            body.text.isNotEmpty) {
                                          createIssue(
                                              username,
                                              repoName,
                                              title.text.trim(),
                                              body.text.trim(),
                                              personalAccessToken);
                                          title.text = "";
                                          body.text = "";
                                          imageList.insert(0, null);
                                          Fluttertoast.showToast(
                                            msg: "Todo added",
                                            toastLength: Toast.LENGTH_SHORT,
                                            gravity: ToastGravity.BOTTOM,
                                            timeInSecForIosWeb: 1,
                                          );
                                          Navigator.of(context).pop();
                                        } else if (title.text.isEmpty &&
                                            body.text.isEmpty) {
                                          Fluttertoast.showToast(
                                            msg:
                                                "Please enter the required fields",
                                            toastLength: Toast.LENGTH_SHORT,
                                            gravity: ToastGravity.BOTTOM,
                                            timeInSecForIosWeb: 1,
                                          );
                                        } else if (title.text.isEmpty) {
                                          Fluttertoast.showToast(
                                            msg: "Please enter the title",
                                            toastLength: Toast.LENGTH_SHORT,
                                            gravity: ToastGravity.BOTTOM,
                                            timeInSecForIosWeb: 1,
                                          );
                                        } else {
                                          Fluttertoast.showToast(
                                            msg: "Please enter the content",
                                            toastLength: Toast.LENGTH_SHORT,
                                            gravity: ToastGravity.BOTTOM,
                                            timeInSecForIosWeb: 1,
                                          );
                                        }
                                      },
                                    ),
                                  ],
                                  backgroundColor: Colors.white,
                                  elevation: 2,
                                ),
                              );
                              Future.delayed(Duration(milliseconds: 500), () {
                                setState(() {});
                              });
                            },
                            child: Icon(
                              Icons.add,
                              color: themeColor,
                              size: width(context) * 0.065,
                            ),
                          )
                        ],
                      ),
                      addVerticalSpace(height(context) * 0.014),
                      SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: FutureBuilder(
                          future: fetchIssues(
                              username, repoName, personalAccessToken),
                          builder: (context, snapshot) {
                            if (mapResponse["message"] == "success" &&
                                list.isNotEmpty) {
                              return Column(
                                children: List.generate(list.length, (index) {
                                  List<bool> check = List.generate(
                                      list.length, (index) => false);
                                  check.fillRange(0, check.length, false);
                                  if (justEntered) {
                                    justEntered = false;
                                    imageList = List.generate(
                                        list.length, (index) => null);
                                  }
                                  return Column(
                                    children: [
                                      addVerticalSpace(height(context) * 0.01),
                                      Container(
                                        width: 0.9 * width(context),
                                        // height: 0.11 * height(context),
                                        decoration: BoxDecoration(
                                          color: white,
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                        padding:
                                            EdgeInsets.fromLTRB(8, 8, 1, 3),
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              width: width(context) * 0.25,
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  addVerticalSpace(
                                                      height(context) * 0.023),
                                                  AppText(
                                                    text: "6:00 PM",
                                                    size: width(context) * 0.04,
                                                    fontWeight: FontWeight.bold,
                                                    color: themeColor,
                                                  ),
                                                  addVerticalSpace(
                                                      height(context) * 0.01),
                                                  AppText(
                                                    text: "May 21",
                                                    size:
                                                        width(context) * 0.035,
                                                    fontWeight:
                                                        FontWeight.normal,
                                                    color: Colors.black38,
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Container(
                                              margin: EdgeInsets.only(top: 5),
                                              width: 1.5,
                                              color: Colors.black54,
                                            ),
                                            Container(
                                              padding: EdgeInsets.fromLTRB(
                                                width(context) * 0.02,
                                                width(context) * 0.02,
                                                width(context) * 0.01,
                                                width(context) * 0.02,
                                              ),
                                              width: width(context) * 0.42,
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    children: [
                                                      Container(
                                                        width: 11.5,
                                                        height: 11.5,
                                                        decoration:
                                                            BoxDecoration(
                                                          color: themeColor,
                                                          shape:
                                                              BoxShape.circle,
                                                        ),
                                                      ),
                                                      addHorizontalySpace(
                                                          width(context) *
                                                              0.025),
                                                      AppText(
                                                        text: "Your Task",
                                                        color: black,
                                                        size: width(context) *
                                                            0.043,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ],
                                                  ),
                                                  addVerticalSpace(
                                                      height(context) * 0.01),
                                                  AppText(
                                                    text: list[index]["title"],
                                                    size:
                                                        width(context) * 0.036,
                                                    color: Colors.black54,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                  AppText(
                                                    text: list[index]["body"],
                                                    size:
                                                        width(context) * 0.033,
                                                    color: Colors.black54,
                                                  ),
                                                  InkWell(
                                                    onTap: () async {
                                                      final pickedFile =
                                                          await picker
                                                              .pickImage(
                                                        source:
                                                            ImageSource.gallery,
                                                        imageQuality: 80,
                                                      );

                                                      if (pickedFile != null) {
                                                        imageList[index] = File(
                                                            pickedFile.path);
                                                        log(imageList
                                                            .toString());
                                                        setState(() {});
                                                      } else {
                                                        setState(() {});
                                                        print(
                                                            "No image selected");
                                                      }
                                                    },
                                                    child: AppText(
                                                      text: imageList[index] ==
                                                              null
                                                          ? "Add image"
                                                          : "Change Image",
                                                      size: width(context) *
                                                          0.033,
                                                      color: themeColor,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            // addHorizontalySpace(2),
                                            Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceAround,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                addVerticalSpace(
                                                    height(context) * 0.02),
                                                InkWell(
                                                  onTap: () async {
                                                    bool done = false;
                                                    check[index] =
                                                        !check[index];
                                                    setState(() {});
                                                    return await showDialog(
                                                      barrierDismissible: false,
                                                      context: context,
                                                      builder: (context) =>
                                                          AlertDialog(
                                                        title: Text(
                                                            'Submit a to do'),
                                                        content: Column(
                                                          mainAxisSize:
                                                              MainAxisSize.min,
                                                          children: [],
                                                        ),
                                                        actions: [
                                                          TextButton(
                                                            child:
                                                                Text('Cancel'),
                                                            onPressed: () {
                                                              Navigator.of(
                                                                      context)
                                                                  .pop();
                                                            },
                                                          ),
                                                          TextButton(
                                                            child:
                                                                Text('Resolve'),
                                                            onPressed: () {
                                                              resolveIssue(
                                                                username,
                                                                repoName,
                                                                list[index][
                                                                        "number"]
                                                                    .toString(),
                                                                personalAccessToken,
                                                                index,
                                                                check,
                                                              );
                                                              Fluttertoast
                                                                  .showToast(
                                                                msg:
                                                                    "Todo resolved",
                                                                toastLength: Toast
                                                                    .LENGTH_SHORT,
                                                                gravity:
                                                                    ToastGravity
                                                                        .BOTTOM,
                                                                timeInSecForIosWeb:
                                                                    1,
                                                              );
                                                              Future.delayed(
                                                                  Duration(
                                                                      milliseconds:
                                                                          2000),
                                                                  () {
                                                                imageList
                                                                    .removeAt(
                                                                        index);
                                                                setState(() {});
                                                              });
                                                              Navigator.of(
                                                                      context)
                                                                  .pop();
                                                            },
                                                          ),
                                                        ],
                                                        backgroundColor:
                                                            Colors.white,
                                                        elevation: 2,
                                                      ),
                                                    );
                                                  },
                                                  child: Container(
                                                    width: 60,
                                                    height: 60,
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              12),
                                                      color: check[index]
                                                          ? themeColor
                                                          : grey
                                                              .withOpacity(0.5),
                                                    ),
                                                    child: Center(
                                                      child: Icon(
                                                        Icons.check,
                                                        color: check[index]
                                                            ? white
                                                            : null,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                addVerticalSpace(
                                                    height(context) * 0.007),
                                                Visibility(
                                                  visible:
                                                      imageList[index] != null,
                                                  child: InkWell(
                                                    onTap: () {
                                                      nextScreen(
                                                        context,
                                                        ImageOpener(
                                                          imageFile:
                                                              imageList[index],
                                                        ),
                                                      );
                                                    },
                                                    child: AppText(
                                                      text: "Preview",
                                                      color: themeColor,
                                                      size: width(context) *
                                                          0.033,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                      addVerticalSpace(height(context) * 0.005),
                                    ],
                                  );
                                }),
                              );
                            } else {
                              return Column(
                                children: [
                                  addVerticalSpace(height(context) * 0.182),
                                  Center(
                                    child: AppText(
                                      text: "No To-Dos added yet.",
                                      size: width(context) * 0.056,
                                      color: black,
                                    ),
                                  )
                                ],
                              );
                            }
                          },
                        ),
                      ),
                      addVerticalSpace(15),
                    ],
                  ),
                ),
              );
            } else {
              return Center(child: CircularProgressIndicator());
            }
          },
        ),
      );
    } catch (e) {
      setState(() {});
      return build(context);
    }
  }
}
