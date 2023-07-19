import 'dart:convert';
import 'package:erick/features/onboarding/model/user.dart';
import 'package:erick/helper/logger/logger.dart';
import 'package:erick/helper/network/network.dart';
import 'package:erick/helper/toast/toast.dart';
import 'package:flutter/material.dart';

class ResetPassViewModel with ChangeNotifier {
  final TextEditingController passwordcontroller = TextEditingController();
  final TextEditingController confirmpasswordcontroller =
      TextEditingController();
  late userModel _user;
  userModel get userdata => _user;

  String? _userToken; // Store the userToken in the view model

  String? get userToken => _userToken; // Getter to access the userToken

  resetpass() async {
    final response = await NetworkHelper().postApi(ApiUrls().resetpass, {
      "password": passwordcontroller.text,
      "confirmPassword": confirmpasswordcontroller.text,
    });
    final body = response.body;
    final jsonBody = json.decode(body);
    if (response.statusCode == 200) {
      // Extract and store the user token from the API response.
      _userToken = jsonBody['data'][
          'userToken']; // Replace 'data' with the actual key for the userToken in the API response.
      logger.d(
          'User Token: $_userToken'); // Verify if the token is being captured correctly.
    } else if (response.statusCode == 401) {
      showtoast(jsonBody['message']);
    } else {
      throw Exception(
          'Failed to make the API request. Status code: ${response.statusCode}');
    }
  }
}
