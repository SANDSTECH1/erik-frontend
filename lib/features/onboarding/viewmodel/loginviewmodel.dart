import 'dart:convert';

import 'package:erick/features/onboarding/model/user.dart';
import 'package:erick/features/onboarding/view/Confirmpass.dart';
import 'package:erick/features/onboarding/view/OTP.dart';
import 'package:erick/features/onboarding/view/login.dart';
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
  // String userToken = '';
  // String get usertoken => userToken;

  login() async {
    final response = await NetworkHelper().postApi(ApiUrls().login, {
      "email": useremailcontroller.text,
      "password": userpasswordcontroller.text
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

  forgetpass(context) async {
    final response = await NetworkHelper().postApi(ApiUrls().forgetpass, {
      "email": userforgotemailcontroller.text,
    });
    logger.d(response.body);
    final body = response.body;
    final jsonBody = json.decode(body);
    if (response.statusCode == 200) {
      // int otpCode = jsonBody['data']; // Get the OTP code as an integer
      // String otpValue = otpCode.toString();
      // verify(otpValue, userforgotemailcontroller.text, context);
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => otp()),
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
    print(otp);

    final response = await NetworkHelper().postApi(ApiUrls().otp, {
      "email": userforgotemailcontroller.text,
      "otp": otp,
    });

    logger.d(response.body);
    final body = response.body;
    final jsonBody = json.decode(body);
    if (response.statusCode == 200) {
      userToken = jsonBody['data']['userToken'];
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                Confirmpass(token: jsonBody['data']['userToken'])),
      );
    } else if (response.statusCode == 401) {
      showtoast(jsonBody['message']);
    } else {
      throw Exception(
          'Failed to make the API request. Status code: ${response.statusCode}');
    }
  }

  resetpass(context) async {
    print(passwordcontroller.text);
    print(confirmpasswordcontroller.text);

    final response = await NetworkHelper().postApi(ApiUrls().resetpass, {
      "password": passwordcontroller.text,
      "confirmPassword": confirmpasswordcontroller.text,
    });
    final body = response.body;
    final jsonBody = json.decode(body);
    if (response.statusCode == 200) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
    } else if (response.statusCode == 401) {
      showtoast(jsonBody['message']);
    } else {
      throw Exception(
          'Failed to make the API request. Status code: ${response.statusCode}');
    }
  }
}
