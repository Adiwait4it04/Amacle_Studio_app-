// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class GithubPageScreen extends StatefulWidget {
  @override
  _GithubPageScreenState createState() => _GithubPageScreenState();
}

class _GithubPageScreenState extends State<GithubPageScreen> {
  final TextEditingController _repositoryNameController =
      TextEditingController();
  final TextEditingController _repositoryDescriptionController =
      TextEditingController();
  final TextEditingController _AddCollaboratorController =
      TextEditingController();

  Future<void> addCollaborator() async {
    const String username = 'Adiwait4it04';
    const String token = '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';
    String repoName = _repositoryNameController.text;
    String collab = _AddCollaboratorController.text;

    String apiUrl =
        "https://api.github.com/repos/$username/$repoName/collaborators/$collab";
    String authHeaderValue = "token $token";

    try {
      http.Response response = await http.put(
        Uri.parse(apiUrl),
        headers: {
          'Authorization': authHeaderValue,
        },
      );

      print(response.statusCode);
      print(response.body);
      if (response.statusCode == 201) {
        print('Collaborator added successfully');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Collaborator invitation sent successfully"),
          ),
        );
      } else {
        print('Failed to add collaborator');
        print(response.body);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Collaborator invitation failed"),
          ),
        );
      }
    } catch (e) {
      print('Failed to connect to the server');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Failed to connect to the server"),
        ),
      );
    }
  }

  Future<void> _createRepository() async {
    const String username = 'Adiwait4it04';
    const String token = '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';

    const String apiUrl = 'https://api.github.com/user/repos';

    final Map<String, dynamic> repositoryData = {
      'name': _repositoryNameController.text,
      'description': _repositoryDescriptionController.text,
      'private': false,
    };

    final String jsonData = json.encode(repositoryData);

    final http.Response response = await http.post(
      Uri.parse(apiUrl),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonData,
    );

    if (response.statusCode == 201) {
      print(response.body);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Created a new repository"),
        ),
      );
    } else if (response.statusCode != 201) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Failed to create a new repository"),
        ),
      );
    } else {
      // Failed to create repository
      print('Failed to create repository. Error: ${response.body}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Project Settings'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            children: [
              TextField(
                controller: _repositoryNameController,
                decoration: const InputDecoration(
                  labelText: 'Repository Name',
                ),
              ),
              TextField(
                controller: _repositoryDescriptionController,
                decoration: const InputDecoration(
                  labelText: 'Repository Description',
                ),
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: _createRepository,
                child: const Text('Create Repository'),
              ),
              const SizedBox(height: 16.0),
              TextField(
                controller: _AddCollaboratorController,
                decoration: const InputDecoration(
                  labelText: 'Add Collaborator',
                ),
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: addCollaborator,
                child: const Text('Add Collaborator'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
