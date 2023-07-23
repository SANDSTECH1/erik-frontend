import 'dart:convert';

import 'package:erick/helper/network/network.dart';
import 'package:erick/helper/toast/toast.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CalendarViewModel with ChangeNotifier {
  final now = DateTime.now();
  final dateFormat = DateFormat('MMMM');
  final weekdayFormat = DateFormat('EEEE');
  final datesByMonth = [];
  final year = 2023;

  int activeShowMonth = 6; //Month on which calendar is active

  CalendarViewModel() {
    addDatesGrid();
  }

  addDatesGrid() {
    for (var i = 1; i < 13; i++) {
      final lastDayOfMonth = DateTime(now.year, i + 1, 0);
      final firstDayOfMonth = DateTime(now.year, i, 1);
      final dates = [];
      for (var j = 0; j < lastDayOfMonth.day; j++) {
        final date = firstDayOfMonth.add(Duration(days: j));
        final formattedDate = DateFormat('dd').format(date);
        final formattedWeekday = weekdayFormat.format(date);
        // dates.add('$formattedDate ($formattedWeekday)');
        dates.add({'date': formattedDate, 'week': formattedWeekday});
      }
      datesByMonth.add(dates);
    }
  }

  showdetails(date, context) async {
    print("$date-${activeShowMonth + 1}-$year");

    final response =
        await NetworkHelper().getApi("${ApiUrls().getTaskByDate}/$date");

    final body = response.body;
    final jsonBody = json.decode(body);
    if (response.statusCode == 200) {
      print(jsonBody['data']);
    } else if (response.statusCode == 400) {
      showtoast(jsonBody['message']);
    } else {
      // throw Exception(
      //     'Failed to make the API request. Status code: ${response.statusCode}');
    }
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(builder: (context) => const TaskScreen()),
    // );
  }
}
