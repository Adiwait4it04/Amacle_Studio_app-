// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:amacle_studio_app/utils/app_text.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

import '../utils/constant.dart';
import '../utils/styles.dart';

class ProjectDetailScreen extends StatefulWidget {
  const ProjectDetailScreen({Key? key}) : super(key: key);

  @override
  _ProjectDetailScreenState createState() => _ProjectDetailScreenState();
}

class _ProjectDetailScreenState extends State<ProjectDetailScreen> {
  int todoLength = 8;

  List<bool> check = List.generate(8, (index) => false);

  @override
  initState() {
    check.fillRange(0, check.length, false);
    print(check);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.grey.withOpacity(0.1),
      body: Container(
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
                  size: width(context) * 0.098,
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
                            backgroundColor: Colors.white12.withOpacity(0.25),
                            circularStrokeCap: CircularStrokeCap.round,
                            center: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
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
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                children: [
                                  AppText(
                                    text: "₹1000",
                                    size: width(context) * 0.1,
                                    color: white,
                                  ),
                                  addHorizontalySpace(8),
                                  AppText(
                                    text: "+1000",
                                    size: width(context) * 0.03,
                                    color: Color.fromARGB(255, 120, 227, 124),
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
                                        fontSize: width(context) * 0.035,
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
                                        fontSize: width(context) * 0.035,
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
                                  borderRadius: BorderRadius.circular(13),
                                  color: Colors.red,
                                ),
                                child: Center(
                                  child: RichText(
                                    text: TextSpan(
                                      text: "Delay  ",
                                      style: TextStyle(
                                        color: white,
                                        fontSize: width(context) * 0.045,
                                      ),
                                      children: [
                                        TextSpan(
                                          text: "  2 Days",
                                          style: TextStyle(
                                            color: Colors.white70,
                                            fontSize: width(context) * 0.045,
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
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                addVerticalSpace(height(context) * 0.029),
                                CircleAvatar(
                                  maxRadius: width(context) * 0.06,
                                  backgroundColor: themeColor.withOpacity(0.12),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(200),
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
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                addHorizontalySpace(width(context) * 0.025),
                                AppText(
                                  text: "Google Meet: New Update",
                                  color: black,
                                  size: width(context) * 0.043,
                                  fontWeight: FontWeight.bold,
                                ),
                                addVerticalSpace(height(context) * 0.005),
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
                                        padding: EdgeInsets.only(left: 2.0),
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
                                        fontSize: width(context) * 0.037,
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
              addVerticalSpace(height(context) * 0.014),
              AppText(
                text: "To-Do's",
                color: black,
                fontWeight: FontWeight.bold,
              ),
              addVerticalSpace(height(context) * 0.014),
              SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  children: List.generate(todoLength, (index) {
                    return Column(
                      children: [
                        addVerticalSpace(height(context) * 0.01),
                        Container(
                          width: 0.9 * width(context),
                          // height: 0.11 * height(context),
                          decoration: BoxDecoration(
                            color: white,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          padding: EdgeInsets.fromLTRB(8, 8, 1, 3),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: width(context) * 0.25,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    addVerticalSpace(height(context) * 0.023),
                                    AppText(
                                      text: "6:00 PM",
                                      size: width(context) * 0.04,
                                      fontWeight: FontWeight.bold,
                                      color: themeColor,
                                    ),
                                    addVerticalSpace(height(context) * 0.01),
                                    AppText(
                                      text: "May 21",
                                      size: width(context) * 0.035,
                                      fontWeight: FontWeight.normal,
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          width: 11.5,
                                          height: 11.5,
                                          decoration: BoxDecoration(
                                            color: themeColor,
                                            shape: BoxShape.circle,
                                          ),
                                        ),
                                        addHorizontalySpace(
                                            width(context) * 0.025),
                                        AppText(
                                          text: "Your Task",
                                          color: black,
                                          size: width(context) * 0.043,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ],
                                    ),
                                    addVerticalSpace(height(context) * 0.01),
                                    AppText(
                                      text:
                                          "Allow users to sign in or sign up using Firebase Authentication",
                                      size: width(context) * 0.033,
                                      color: Colors.black54,
                                    ),
                                  ],
                                ),
                              ),
                              addHorizontalySpace(2),
                              Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  addVerticalSpace(height(context) * 0.02),
                                  InkWell(
                                    onTap: () {
                                      check[index] = !check[index];
                                      setState(() {});
                                    },
                                    child: Container(
                                      width: 60,
                                      height: 60,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(12),
                                        color: check[index]
                                            ? themeColor
                                            : grey.withOpacity(0.5),
                                      ),
                                      child: Center(
                                        child: Icon(
                                          Icons.check,
                                          color: check[index] ? white : null,
                                        ),
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
                ),
              ),
              addVerticalSpace(15),
            ],
          ),
        ),
      ),
    );
  }
}
