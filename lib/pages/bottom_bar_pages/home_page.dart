// ignore_for_file: prefer__ructors, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:amacle_studio_app/pages/project_detail_screen.dart';
import 'package:amacle_studio_app/utils/app_text.dart';
import 'package:amacle_studio_app/utils/styles.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../utils/constant.dart';

class HomePageScreen extends StatefulWidget {
  HomePageScreen({Key? key}) : super(key: key);

  @override
  _HomePageScreenState createState() => _HomePageScreenState();
}

class _HomePageScreenState extends State<HomePageScreen>
    with SingleTickerProviderStateMixin {
  late bool isShowingMainData;

  late TabController _tabController;

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    isShowingMainData = true;
  }

  Column inProgress() {
    int percent = 100;
    return Column(
      children: List.generate(6, (index) {
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
              padding: EdgeInsets.fromLTRB(8, 4, 1, 3),
              child: InkWell(
                onTap: () {
                  nextScreen(context, ProjectDetailScreen());
                },
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: width(context) * 0.25,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          addVerticalSpace(height(context) * 0.01),
                          Container(
                            height: width(context) * 0.17,
                            width: width(context) * 0.17,
                            // maxRadius: width(context) * 0.1,
                            // backgroundColor: themeColor.withOpacity(0.12),
                            decoration: BoxDecoration(shape: BoxShape.circle),
                            child: ClipRRect(
                              borderRadius:
                                  BorderRadius.circular(width(context) * 0.1),
                              child: Image.network(
                                "https://picsum.photos/200/300",
                                fit: BoxFit.cover,
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
                            text: "Poultry App",
                            color: black,
                            size: width(context) * 0.047,
                            fontWeight: FontWeight.bold,
                          ),
                          addVerticalSpace(height(context) * 0.01),
                          AppText(
                            text: "$percent%",
                            size: width(context) * 0.037,
                            color:
                                percent == 100 ? Colors.blue : Colors.black54,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            addVerticalSpace(height(context) * 0.005),
          ],
        );
      }),
    );
  }

  Column maintainence() {
    return Column(
      children: List.generate(6, (index) {
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
                      children: [
                        addVerticalSpace(height(context) * 0.01),
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
                    width: width(context) * 0.62,
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
                            addHorizontalySpace(width(context) * 0.025),
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
                ],
              ),
            ),
            addVerticalSpace(height(context) * 0.005),
          ],
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.withOpacity(0.05),
      body: Column(
        children: [
          Container(
            height: 0.53 * height(context),
            child: Stack(
              children: [
                Column(
                  children: [
                    Stack(
                      children: [
                        Container(
                          color: themeColor,
                          width: width(context),
                          height: height(context) * 0.45,
                        ),
                        Positioned(
                          top: 0.04 * width(context),
                          left: 0.04 * width(context),
                          child: Icon(
                            CupertinoIcons.profile_circled,
                            size: width(context) * 0.17,
                            color: white,
                          ),
                        ),
                        Positioned(
                          top: 0.04 * width(context),
                          right: 0.04 * width(context),
                          child: Icon(
                            CupertinoIcons.bell_circle,
                            size: width(context) * 0.19,
                            color: white,
                          ),
                        ),
                      ],
                    ),
                    addVerticalSpace(20),
                    // IconButton(
                    //   icon: Icon(
                    //     Icons.refresh,
                    //     color: themeColor
                    //         .withOpacity(isShowingMainData ? 1.0 : 0.5),
                    //   ),
                    //   onPressed: () {
                    //     setState(() {
                    //       isShowingMainData = !isShowingMainData;
                    //     });
                    //   },
                    // )
                  ],
                ),
                Positioned(
                  top: height(context) * 0.15,
                  right: 20,
                  left: 20,
                  child: Padding(
                    padding: EdgeInsets.only(right: 6, left: 6),
                    child: ExpenseGraphDesign(),
                  ),
                ),
              ],
            ),
          ),
          Row(
            children: [
              addHorizontalySpace(width(context) * 0.34),
              AppText(
                text: "Projects",
                color: black,
                size: width(context) * 0.046,
                fontWeight: FontWeight.bold,
              ),
              addHorizontalySpace(width(context) * 0.29),
              Icon(
                Icons.search,
                size: width(context) * 0.08,
                color: themeColor,
              ),
            ],
          ),
          addVerticalSpace(height(context) * 0.01),
          TabBar(
            labelColor: black,
            labelStyle: TextStyle(fontWeight: FontWeight.bold),
            unselectedLabelColor: Colors.grey.withOpacity(0.7),
            controller: _tabController,
            tabs: [
              Tab(text: "Maintainence"),
              Tab(text: 'In Progress'),
              Tab(text: 'Finished'),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                SingleChildScrollView(child: maintainence()),
                SingleChildScrollView(child: inProgress()),
                SingleChildScrollView(child: inProgress()),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ExpenseGraphDesign extends StatefulWidget {
  const ExpenseGraphDesign({Key? key}) : super(key: key);

  @override
  State<ExpenseGraphDesign> createState() => _ExpenseGraphDesignState();
}

class _ExpenseGraphDesignState extends State<ExpenseGraphDesign> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        // height: height(context) * 0.36,
        width: width(context) * 0.90,
        decoration: BoxDecoration(
          color: white,
          // boxShadow: [
          //   BoxShadow(
          //     color: black.withOpacity(0.4),
          //     blurRadius: 3,
          //     spreadRadius: 3,
          //     offset: Offset(1, 2),
          //   ),
          // ],
          borderRadius: BorderRadius.circular(15),
        ),
        padding: EdgeInsets.fromLTRB(7.0, 12.0, 8.0, 4.0),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              addVerticalSpace(1),
              AppText(
                text: "This week's progress",
                fontWeight: FontWeight.bold,
                size: width(context) * 0.06,
                color: black,
              ),
              Container(
                margin: EdgeInsets.only(top: 10),
                height: height(context) * 0.30,
                width: width(context) * 0.79,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: LineChart(
                    LineChartData(
                      minX: 0,
                      maxX: 10,
                      minY: 0,
                      maxY: 10,
                      borderData: FlBorderData(border: Border()),
                      backgroundColor: Colors.white,
                      baselineY: 10,
                      baselineX: 10,
                      lineBarsData: [
                        LineChartBarData(
                          spots: [
                            const FlSpot(0, 4),
                            const FlSpot(1, 6),
                            const FlSpot(2, 8),
                            const FlSpot(3, 6.2),
                            const FlSpot(4, 6),
                            const FlSpot(5, 8),
                            const FlSpot(6, 9),
                            const FlSpot(7, 7),
                            const FlSpot(8, 6),
                            const FlSpot(9, 7.8),
                            const FlSpot(10, 8),
                          ],
                          isCurved: true,
                          gradient: LinearGradient(
                            colors: [
                              Colors.blue.shade600,
                              Colors.blue.shade400,
                            ],
                          ),
                          barWidth: 3,
                          belowBarData: BarAreaData(
                            show: true,
                            gradient: LinearGradient(
                              colors: [
                                Colors.blue.shade900,
                                Colors.blue.shade400,
                              ],
                            ),
                          ),
                          dotData: FlDotData(show: false),
                        ),
                      ],
                      gridData: FlGridData(
                          show: true,
                          drawHorizontalLine: false,
                          drawVerticalLine: true,
                          getDrawingVerticalLine: (value) {
                            return FlLine(
                              color: Colors.grey.shade800.withOpacity(0.3),
                              strokeWidth: 0.8,
                            );
                          }),
                      titlesData: FlTitlesData(
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        rightTitles: AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        topTitles: AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                              showTitles: true,
                              reservedSize: 12,
                              getTitlesWidget: (value, meta) {
                                String text = 'ddddm';
                                switch (value.toInt()) {
                                  case 1:
                                    text = "1";
                                    break;
                                  case 2:
                                    text = "2";
                                    break;
                                  case 3:
                                    text = "3";
                                    break;
                                  case 4:
                                    text = "4";
                                    break;
                                  case 5:
                                    text = "5";
                                    break;
                                  case 6:
                                    text = "6";
                                    break;
                                  case 7:
                                    text = "7";
                                    break;
                                  case 8:
                                    text = "8";
                                    break;
                                  case 9:
                                    text = "9";
                                    break;
                                  case 10:
                                    text = "10";
                                    break;
                                  default:
                                    return Container();
                                }
                                return Text(
                                  text,
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 10,
                                  ),
                                );
                              }),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
