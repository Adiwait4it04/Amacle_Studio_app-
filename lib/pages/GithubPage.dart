import 'package:amacle_studio_app/github/github2.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Githubpage extends StatefulWidget {
  const Githubpage({super.key});

  @override
  State<Githubpage> createState() => _GithubpageState();
}

class _GithubpageState extends State<Githubpage> {
  TextEditingController Reponame = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Column(
            children: [
              Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: TextField(
                    style: const TextStyle(color: Colors.black),
                    controller: Reponame,
                    decoration: const InputDecoration(
                      labelStyle: TextStyle(color: Colors.black, fontSize: 15),
                    ),
                    textAlign: TextAlign.start),
              ),
              const SizedBox(
                height: 10,
              ),
              TextButton(
                onPressed: Github2().createRepository(Reponame.text,
                    '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', context),
                child: const Text("Enter"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
