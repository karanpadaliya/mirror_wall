import 'package:flutter/material.dart';

class LoginProvider extends ChangeNotifier {
  String? userName;
  String? userMobileNo;
  String? userPin;

  void setUserDetails(String name, String mobile, String pin) {
    userName = name;
    userMobileNo = mobile;
    userPin = pin;
    notifyListeners(); // Notify listeners of the change
  }
  void setUserName(String name) {
    userName = name;
    notifyListeners(); // Notify listeners of the change
  }
  void setMobileNo(String mobileNo) {
    userMobileNo = mobileNo;
    notifyListeners(); // Notify listeners of the change
  }
  void setPin(String pin) {
    userPin = pin;
    notifyListeners(); // Notify listeners of the change
  }
}