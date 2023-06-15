import 'package:shared_preferences/shared_preferences.dart';

class Global {
  static String phone = "";
  static String email = "";
  static String role = "developer";
  static int id = -1;
  static String isLoggedin = "no";

  destroy() {
    phone = "";
    email = "";
    id = -1;
    isLoggedin = "no";

    removePhoneNumber();
    removeEmail();
    removeLogin();

    print("destroyed");
  }

  fetchData() {
    getPhoneNumber().then((phoneNumber) async {
      print('Phone Number: $phoneNumber');
      Global.phone = phoneNumber;
    });
    getEmail().then((email) async {
      print('Email: $email');
      Global.email = email;
    });
    getLogin().then((log) async {
      print('Login: $log');
      Global.isLoggedin = log;
    });
  }

  void savePhoneNumber(String phoneNumber) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('AmcPhoneNumber', phoneNumber);
  }

  Future<String> getPhoneNumber() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('AmcPhoneNumber') ?? "";
  }

  void removePhoneNumber() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('AmcPhoneNumber');
  }

  void saveEmail(String email) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('AmcEmail', email);
  }

  Future<String> getEmail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('AmcEmail') ?? "";
    ;
  }

  void removeEmail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('AmcEmail');
  }

  void saveLogin(String log) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('AmcLogin', log);
  }

  Future<String> getLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('AmcLogin') ?? "";
    ;
  }

  void removeLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('AmcLogin');
  }
}
