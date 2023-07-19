import 'dart:convert';

import 'package:erick/features/onboarding/model/user.dart';
import 'package:erick/features/onboarding/view/OTP.dart';
import 'package:erick/helper/logger/logger.dart';
import 'package:erick/helper/network/network.dart';
import 'package:erick/helper/toast/toast.dart';
import 'package:flutter/material.dart';

class ForgetPassViewModel with ChangeNotifier {
  final BuildContext context; // Add the context as an instance variable

  ForgetPassViewModel(this.context);
  final TextEditingController useremailcontroller = TextEditingController();
  late userModel _user;
  userModel get userdata => _user;

  void navigateToOTPScreen(String otpValue) {
    // Replace 'OTPScreen' with the actual name of your OTP screen widget
    // If you need to pass more data to the OTP screen, create a constructor for the OTP screen widget accordingly.
    Navigator.push(
      context, // Make sure you have access to the context where the navigation is happening.
      MaterialPageRoute(builder: (context) => otp(data: otpValue)),
    );
  }

  forgetpass() async {
    final response = await NetworkHelper().postApi(ApiUrls().forgetpass, {
      "email": useremailcontroller.text,
    });
    logger.d(response.body);
    final body = response.body;
    final jsonBody = json.decode(body);
    if (response.statusCode == 200) {
      _user = userModel.fromJson(jsonBody['data']);
      int otpCode = jsonBody['data']['otp']; // Get the OTP code as an integer
      String otpValue = otpCode.toString();
      navigateToOTPScreen(otpValue); // Convert the integer to a string
      // Call the callback function to navigate to the OTP screen with the OTP value
    } else if (response.statusCode == 401) {
      showtoast(jsonBody['message']);
    } else {
      throw Exception(
          'Failed to make the API request. Status code: ${response.statusCode}');
    }

    // if (!response['success']) {
    //   return showtoast(response['message']);
    // }
    // _user = userModel.fromJson(response['data']);

    // notifyListeners();
  }
  // Callback function to navigate to the OTP screen
}
