import 'package:flutter/material.dart';

class BarIcons {
  BottomNavigationBarItem item(double sizew, double sizeh, String label,
      double ic, bool sel, IconData icon) {
    return BottomNavigationBarItem(
      label: label,
      icon: Container(
        height: sizeh,
        width: sizew,
        child: Icon(
          icon,
          size: ic,
          fill: 0.7,
          color: sel ? const Color.fromARGB(255, 53, 131, 192) : Colors.grey,
        ),
      ),
    );
  }
}
