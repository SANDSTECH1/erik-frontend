import 'dart:convert';

import 'package:erick/features/onboarding/model/user.dart';
import 'package:erick/features/onboarding/view/Confirmpass.dart';
import 'package:erick/features/onboarding/view/OTP.dart';
import 'package:erick/features/onboarding/view/login.dart';
import 'package:erick/features/tasks/view/calender_screen.dart';
import 'package:erick/helper/loader/loader.dart';
import 'package:erick/helper/logger/logger.dart';
import 'package:erick/helper/network/network.dart';
import 'package:erick/helper/toast/toast.dart';
import 'package:flutter/material.dart';

String userToken = "";

class LoginViewModel with ChangeNotifier {
  final TextEditingController useremailcontroller = TextEditingController();
  final TextEditingController userpasswordcontroller = TextEditingController();
  final TextEditingController userforgotemailcontroller =
      TextEditingController();
  final TextEditingController otpcontroller = TextEditingController();
  final TextEditingController passwordcontroller = TextEditingController();
  final TextEditingController confirmpasswordcontroller =
      TextEditingController();
  late userModel _user;
  userModel get userdata => _user;

  Future<void> hideLoader(BuildContext context) async {
    Navigator.of(context).pop();
  }

  Future<void> login(BuildContext context) async {
    try {
      showLoader(context);

      final response = await NetworkHelper().postApi(ApiUrls().login, {
        "email": useremailcontroller.text,
        "password": userpasswordcontroller.text,
      });

      hideLoader(context);

      logger.d(response.body);
      final body = response.body;
      final jsonBody = json.decode(body);
      if (response.statusCode == 200) {
        _user = userModel.fromJson(jsonBody['data']);
        userToken = jsonBody['data']['userToken'];
        useremailcontroller.clear();
        userpasswordcontroller.clear();
        showtoast(jsonBody['message']);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const calender_screen()),
        );
      } else if (response.statusCode == 400) {
        showtoast(jsonBody['message']);
      } else {
        throw Exception(
            'Failed to make the API request. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error occurred: $e');
      showtoast('An error occurred. Please try again.');
    }
  }

  forgetpass(context) async {
    showLoader(context);
    final response = await NetworkHelper().postApi(ApiUrls().forgetpass, {
      "email": userforgotemailcontroller.text,
    });
    hideLoader(context);
    logger.d(response.body);
    final body = response.body;
    final jsonBody = json.decode(body);
    if (response.statusCode == 200) {
      showtoast(jsonBody['message']);

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const otp()),
      );
    } else if (response.statusCode == 400) {
      print("sad");
      showtoast(jsonBody['message']);
    } else {
      throw Exception(
          'Failed to make the API request. Status code: ${response.statusCode}');
    }
  }

  Future<void> verify(otp, context) async {
    print(otp);
    showLoader(context);

    try {
      final response = await NetworkHelper().postApi(ApiUrls().otp, {
        "email": userforgotemailcontroller.text,
        "otp": otp,
      });

      hideLoader(context);
      logger.d(response.body);
      final body = response.body;
      final jsonBody = json.decode(body);

      if (response.statusCode == 200) {
        userToken = jsonBody['data']['userToken'];
        showtoast(jsonBody['message']);
        userforgotemailcontroller.clear();
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  Confirmpass(token: jsonBody['data']['userToken'])),
        );
      } else if (response.statusCode == 401) {
        showtoast(jsonBody['message']);
      } else {
        showtoast('Invalid OTP. Please try again.');
      }
    } catch (e) {
      hideLoader(context);
      showtoast('An error occurred. Please try again later.');
      print('Error verifying OTP: $e');
    }
  }

  resetpass(context) async {
    print(passwordcontroller.text);
    print(confirmpasswordcontroller.text);

    // Validate password length
    if (passwordcontroller.text.length < 5) {
      showtoast('Password must be at least 5 characters long.');
      return;
    }

    // Validate password match
    if (passwordcontroller.text != confirmpasswordcontroller.text) {
      showtoast("Passwords don't match.");
      return;
    }
    showLoader(context);
    final response = await NetworkHelper().postApi(ApiUrls().resetpass, {
      "password": passwordcontroller.text,
      "confirmPassword": confirmpasswordcontroller.text,
    });

    hideLoader(context);
    final body = response.body;
    final jsonBody = json.decode(body);
    if (response.statusCode == 200) {
      passwordcontroller.clear();
      confirmpasswordcontroller.clear();
      showtoast(jsonBody['message']);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    } else if (response.statusCode == 401) {
      showtoast(jsonBody['message']);
    } else {
      throw Exception(
          'Failed to make the API request. Status code: ${response.statusCode}');
    }
  }
}
