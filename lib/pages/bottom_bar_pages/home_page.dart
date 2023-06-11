// ignore_for_file: prefer__ructors

import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../utils/constant.dart';

class HomePageScreen extends StatefulWidget {
  HomePageScreen({Key? key}) : super(key: key);

  @override
  _HomePageScreenState createState() => _HomePageScreenState();
}

class _HomePageScreenState extends State<HomePageScreen> {
  late bool isShowingMainData;

  @override
  void initState() {
    super.initState();
    isShowingMainData = true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            color: Color(0xff006FFD),
            width: width(context),
            height: height(context) * 0.45,
          ),
          addVerticalSpace(20),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(right: 16, left: 6),
              child: ExpenseGraphDesign(),
            ),
          ),
          addVerticalSpace(20),
          IconButton(
            icon: Icon(
              Icons.refresh,
              color: Colors.white.withOpacity(isShowingMainData ? 1.0 : 0.5),
            ),
            onPressed: () {
              setState(() {
                isShowingMainData = !isShowingMainData;
              });
            },
          )
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
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: black, width: 2),
      ),
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: height(context) * 0.45,
        width: width(context) * 0.9,
        child: LineChart(
          LineChartData(
            minX: 0,
            maxX: 10,
            minY: 0,
            maxY: 10,
            backgroundColor: Colors.transparent,
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
                    Colors.blue.shade900,
                    Colors.blue.shade400,
                  ],
                ),
                barWidth: 3,
                belowBarData: BarAreaData(
                  show: true,
                  gradient: LinearGradient(
                    colors: [
                      Colors.blue.shade900.withOpacity(0.5),
                      Colors.blue.shade400.withOpacity(0.5),
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
                      String text = '';
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
                          color: Colors.white,
                          fontSize: 10,
                        ),
                      );
                    }),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
