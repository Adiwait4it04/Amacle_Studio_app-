// ignore_for_file: prefer_const_constructors, prefer_final_fields

import 'dart:math';

import 'package:amacle_studio_app/pages/GithubPage.dart';
import 'package:amacle_studio_app/pages/Indivisual_page.dart';
import 'package:amacle_studio_app/utils/app_text.dart';
import 'package:amacle_studio_app/utils/constant.dart';
import 'package:amacle_studio_app/utils/styles.dart';
import 'package:flutter/material.dart';

class ProjectScreen extends StatefulWidget {
  const ProjectScreen({Key? key}) : super(key: key);

  @override
  _ProjectScreenState createState() => _ProjectScreenState();
}

class _ProjectScreenState extends State<ProjectScreen> {
  List<String> _sortingOptions = [
    'Option 1',
    'Option 2',
    'Option 3',
    'Option 4',
  ];

  List<String> _filterOptions = [
    'Option 1',
    'Option 2',
    'Option 3',
    'Option 4',
  ];

  late String _selectedOption;
  late String _selectedOptionFilter;

  @override
  void initState() {
    super.initState();
    _selectedOption = _sortingOptions[0];
    _selectedOptionFilter = _filterOptions[0];
  }

  TextEditingController searchBarController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.withOpacity(0.05),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.only(left: 17, right: 17),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            // mainAxisAlignment: MainAxisAlignment.center,
            children: [
              addVerticalSpace(height(context) * 0.05),
              Center(
                child: Container(
                  width: width(context) * 0.9,
                  height: 50,
                  decoration: BoxDecoration(
                    color: white,
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: TextField(
                    controller: searchBarController,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.search),
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
              addVerticalSpace(height(context) * 0.018),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: width(context) * 0.35,
                    height: 60,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                          border: Border.all(
                            color: Colors.grey.withOpacity(0.4),
                            width: 1,
                          )),
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: DropdownButtonHideUnderline(
                        child: InputDecorator(
                          decoration: InputDecoration(
                            label: Text("Sort"),
                            prefix: Icon(Icons.sort),
                          ),
                          child: DropdownButton<String>(
                            value: _selectedOption,
                            icon: Icon(
                              Icons.keyboard_arrow_down,
                              color: Colors.grey.withOpacity(0.4),
                            ),
                            iconSize: 24,
                            elevation: 16,
                            style: TextStyle(
                              color: Colors.black87,
                              fontSize: 14,
                            ),
                            dropdownColor: Colors.white,
                            onChanged: (String? newValue) {
                              setState(() {
                                _selectedOption = newValue!;
                                print('Selected option: $_selectedOption');
                              });
                            },
                            items: _sortingOptions
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Visibility(
                                  visible: true,
                                  child: Text(
                                    value,
                                    style: TextStyle(
                                      color: Colors.black87,
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    width: width(context) * 0.35,
                    height: 60,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                          border: Border.all(
                            color: Colors.grey.withOpacity(0.4),
                            width: 1,
                          )),
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: DropdownButtonHideUnderline(
                        child: InputDecorator(
                          decoration: InputDecoration(
                            prefix: Icon(Icons.filter_list),
                          ),
                          child: DropdownButton<String>(
                            hint: Text("Filter"),
                            value: _selectedOptionFilter,
                            icon: Icon(
                              Icons.keyboard_arrow_down,
                              color: Colors.grey.withOpacity(0.4),
                            ),
                            iconSize: 24,
                            elevation: 16,
                            style: TextStyle(
                              color: Colors.black87,
                              fontSize: 14,
                            ),
                            dropdownColor: Colors.white,
                            onChanged: (String? newValue) {
                              setState(() {
                                _selectedOptionFilter = newValue!;
                                print('Selected option: $_selectedOption');
                              });
                            },
                            items: _filterOptions
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Visibility(
                                  visible: value != "Filter",
                                  child: Text(
                                    value,
                                    style: TextStyle(
                                      color: Colors.black87,
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              addVerticalSpace(height(context) * 0.018),
              GridView.count(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                childAspectRatio: (0.4 / 0.47),
                crossAxisSpacing: 10.0,
                mainAxisSpacing: 10.0,
                children: List.generate(
                  9,
                  (index) {
                    return Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: white,
                      ),
                      child: Column(
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => indivisual_page(),
                                ),
                              );
                            },
                            child: Container(
                              height: height(context) * 0.161,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: NetworkImage(
                                    "https://picsum.photos/200/300",
                                  ),
                                  fit: BoxFit.cover,
                                ),
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(20),
                                  topRight: Radius.circular(20),
                                ),
                                color: white,
                              ),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.only(left: 10, top: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    AppText(
                                      text: "Hotel App",
                                      size: width(context) * 0.05,
                                      color: black,
                                    ),
                                    addVerticalSpace(height(context) * 0.001),
                                    AppText(
                                      text: "₹6000",
                                      color: black,
                                      fontWeight: FontWeight.bold,
                                    )
                                  ],
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
