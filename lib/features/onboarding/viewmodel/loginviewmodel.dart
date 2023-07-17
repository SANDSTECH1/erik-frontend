import 'dart:convert';

import 'package:erick/features/onboarding/model/user.dart';
import 'package:erick/helper/logger/logger.dart';
import 'package:erick/helper/network/network.dart';
import 'package:erick/helper/toast/toast.dart';
import 'package:flutter/material.dart';

class LoginViewModel with ChangeNotifier {
  final TextEditingController useremailcontroller = TextEditingController();
  final TextEditingController userpasswordcontroller = TextEditingController();

  late userModel _user;
  userModel get userdata => _user;

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

    // if (!response['success']) {
    //   return showtoast(response['message']);
    // }
    // _user = userModel.fromJson(response['data']);

    // notifyListeners();
  }
}
