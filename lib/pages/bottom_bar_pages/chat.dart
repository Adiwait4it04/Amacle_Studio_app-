import 'package:amacle_studio_app/pages/each_chat.dart';
import 'package:amacle_studio_app/utils/search_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class ChatsPage extends StatefulWidget {
  const ChatsPage({super.key});

  @override
  State<ChatsPage> createState() => _ChatsPageState();
}

class _ChatsPageState extends State<ChatsPage> {
  static List<SearchModel> chat_list = [
    SearchModel("Haley James", "Stand up for what you believe in"),
    SearchModel("Haley James", "Stand up for what you believe in"),
    SearchModel("Haley James", "Stand up for what you believe in"),
    SearchModel("Haley James", "Stand up for what you believe in"),
    SearchModel("Haley James", "Stand up for what you believe in"),
    SearchModel("Haley James", "Stand up for what you believe in"),
    SearchModel("Haley James", "Stand up for what you believe in"),
    SearchModel("Aditya James", "Stand up for what you believe in"),
    SearchModel("Aditya James", "Stand up for what you believe in"),
    SearchModel("Aditya James", "Stand up for what you believe in"),
    SearchModel("Aditya James", "Stand up for what you believe in"),
  ];
  List<SearchModel> display_list = List.from(chat_list);

  void updateList(String value) {
    setState(
      () {
        display_list = chat_list
            .where(
              (element) => element.name!.toLowerCase().contains(
                    value.toLowerCase(),
                  ),
            )
            .toList();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 10),
              child: Center(
                child: Text(
                  "Chats",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    fontSize: 30,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
              child: TextField(
                onChanged: (value) => updateList(value),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
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
              child: display_list.isEmpty
                  ? const Center(
                      child: Text(
                        "No Result Found",
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.bold),
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.all(10),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (context) => const Each_Chat(),
                            ),
                          );
                        },
                        child: ListView.builder(
                          itemCount: display_list.length,
                          itemBuilder: (context, index) => ListTile(
                            title: Text(
                              display_list[index].name!,
                              style: const TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text(
                              display_list[index].last_chat!,
                              style: const TextStyle(color: Colors.black),
                            ),
                            leading: const Icon(
                              CupertinoIcons.profile_circled,
                              color: Colors.lightBlue,
                              size: 50,
                            ),
                          ),
                        ),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
