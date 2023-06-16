import 'package:amacle_studio_app/pages/signup_page.dart';
import 'package:amacle_studio_app/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sign_button/sign_button.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailcontroller = TextEditingController();
  TextEditingController passwordcontroller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 86, left: 23),
            child: Text(
              "Welcome Back !",
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20, left: 23),
            child: Text(
              "Please enter your details",
              style: GoogleFonts.poppins(fontSize: 15, color: Colors.black),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 23, top: 30, right: 23),
            child: TextField(
              controller: emailcontroller,
              decoration: const InputDecoration(
                labelText: 'Email',
                suffixText: '@',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(5),
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20, top: 30, right: 23),
            child: TextField(
              controller: passwordcontroller,
              decoration: const InputDecoration(
                labelText: 'Password',
                suffixIcon: Icon(Icons.lock),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(5),
                  ),
                ),
              ),
              obscureText: true,
              obscuringCharacter: '*',
              textAlign: TextAlign.start,
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(left: 250, top: 10),
            child: Text(
              "Forgot Password",
              style: TextStyle(
                color: Color(0xFF355BC0),
                fontSize: 15,
              ),
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: TextButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  primary: const Color(0xFF355BC0),
                ),
                child: const Padding(
                  padding:
                      EdgeInsets.only(left: 150, right: 150, top: 9, bottom: 9),
                  child: Text(
                    "Login",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.only(top: 15.0),
              child: SignInButton(
                buttonType: ButtonType.google,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
                buttonSize: ButtonSize.large,
                onPressed: () {
                  print('click');
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 5),
            child: Padding(
              padding: const EdgeInsets.only(left: 15, right: 8, top: 190),
              child: Row(
                children: [
                  Container(
                    height: 2,
                    width: 170,
                    decoration: const BoxDecoration(color: Colors.grey),
                  ),
                  const Text(
                    "  or  ",
                    style: TextStyle(fontSize: 20),
                  ),
                  Container(
                    height: 2,
                    width: 150,
                    decoration: const BoxDecoration(color: Colors.grey),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10, right: 8),
            child: Container(
              height: 56,
              decoration: BoxDecoration(
                border: Border.all(
                  color: const Color(0xFF355BC0),
                ),
              ),
              child: Center(
                child: TextButton(
                  onPressed: () {
                    Navigator.pop(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SignupPage()),
                    );
                  },
                  child: const Text(
                    "Create a new account",
                    style: TextStyle(
                      color: Color(0xFF355BC0),
                      fontSize: 15,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
