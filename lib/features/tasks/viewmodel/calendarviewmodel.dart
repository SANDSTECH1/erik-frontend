import 'dart:convert';

import 'package:erick/features/tasks/model/tasks.dart';
import 'package:erick/features/tasks/view/task_screen.dart';
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
  String date = '';
  int activeShowMonth = 7;

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

  showdetails(targetDate, context) async {
    print('$year-${activeShowMonth + 1}-$targetDate');

    final response = await NetworkHelper().getApi(
        "${ApiUrls().getTaskByDate}?targetDate=$year-${activeShowMonth + 1}-$targetDate");

    final body = response.body;
    final jsonBody = json.decode(body);

    if (jsonBody['data'] == null) {
      // No tasks found, show a message to the user
      showtoast('No tasks found for the selected date.');
    } else {
      List<taskByDate> _getTasks = jsonBody['data']
          .map<taskByDate>((m) => taskByDate.fromJson(m))
          .toList();
      if (response.statusCode == 200) {
        // print(jsonBody['data']);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TaskScreen(
              tasks: _getTasks,
            ),
          ),
        );
      } else if (response.statusCode == 400) {
        showtoast(jsonBody['message']);
      } else {
        // throw Exception(
        //     'Failed to make the API request. Status code: ${response.statusCode}');
      }
    }
  }

  void previousMonth() {
    if (activeShowMonth > 0) {
      activeShowMonth--;
      notifyListeners();
    }
  }

  void nextMonth() {
    if (activeShowMonth < 11) {
      activeShowMonth++;
      notifyListeners();
    }
  }
}
