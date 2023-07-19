import 'dart:convert';

import 'package:erick/features/onboarding/model/user.dart';
import 'package:erick/helper/logger/logger.dart';
import 'package:erick/helper/network/network.dart';
import 'package:erick/helper/toast/toast.dart';
import 'package:flutter/material.dart';

class OtpViewModel with ChangeNotifier {
  final TextEditingController otpcontroller = TextEditingController();
  final TextEditingController useremailcontroller = TextEditingController();
  late userModel _user;
  userModel get userdata => _user;
  String _otpValue = ""; // Initialize OTP value with an empty string

  // Getter to access the OTP value
  String get otpValue => _otpValue;

  // Method to set the OTP value
  void setOtpValue(String otpValue) {
    _otpValue = otpValue;
    notifyListeners(); // Notify listeners about the change in OTP value
  }

  Future<void> otp() async {
    final response = await NetworkHelper().postApi(ApiUrls().otp, {
      "email": useremailcontroller.text,
      "otp": otpValue,
    });

    logger.d(response.body);
    final body = response.body;
    final jsonBody = json.decode(body);
    if (response.statusCode == 200) {
      _user = userModel.fromJson(jsonBody['data']);
    } else if (response.statusCode == 401) {
      showtoast(jsonBody['message']);
    } else {
      throw Exception(
          'Failed to make the API request. Status code: ${response.statusCode}');
    }
  }
}

class AuthManager {
  static String? _userToken;

  static String? getToken() {
    logger.d(
        'Token retrieved: $_userToken'); // Add this line to verify if the token is retrieved correctly.
    return _userToken;
  }

  static void setToken(String? token) {
    _userToken = token;
    logger.d(
        'Token set: $_userToken'); // Add this line to verify if the token is set correctly.
  }

  // Add any other methods for handling authentication, such as logout or token expiration checks.
}
