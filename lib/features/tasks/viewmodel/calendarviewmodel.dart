import 'dart:convert';

import 'package:erick/features/tasks/model/tasks.dart';
import 'package:erick/features/tasks/view/assigntask.dart';
import 'package:erick/features/tasks/view/edittasks.dart';
import 'package:erick/features/tasks/view/task_screen.dart';
import 'package:erick/helper/logger/logger.dart';
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
  int activeShowMonth = 6;

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

  // areTasksAssigned(DateTime date) {
  //   final tasks = ['data'] as List<dynamic>;
  //   final targetDate = DateFormat('dd').format(date);
  //   return tasks.any((task) => task['date'] == targetDate);
  // }

  showdetails(targetDate, context) async {
    //print("$targetDate-${activeShowMonth + 1}-$year");
    print('$year-${activeShowMonth + 1}-$targetDate');
    //print(targetDate);

    final response = await NetworkHelper().getApi(
        "${ApiUrls().getTaskByDate}?targetDate=$year-${activeShowMonth + 1}-$targetDate");

    final body = response.body;
    final jsonBody = json.decode(body);
    //final List<Map<String, dynamic>> taskDataList = jsonBody['data'];
    List<taskByDate> _getTasks = jsonBody['data']
        .map<taskByDate>((m) => taskByDate.fromJson(m))
        .toList();
    if (response.statusCode == 200) {
      print(jsonBody['data']);
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => TaskScreen(
                  tasks: _getTasks,
                )),
      );
    } else if (response.statusCode == 400) {
      showtoast(jsonBody['message']);
    } else {
      // throw Exception(
      //     'Failed to make the API request. Status code: ${response.statusCode}');
    }
  }

  // void editTask(BuildContext context, List<taskByDate> tasks) {
  //   List<taskByDate> _getTasks = jsonBody['data']
  //       .map<taskByDate>((m) => taskByDate.fromJson(m))
  //       .toList();
  //   Navigator.push(
  //     context,
  //     MaterialPageRoute(
  //       builder: (context) => TaskScreen(tasks: _getTasks),
  //     ),
  //   );
  // }

  // gettasks() async {
  //   final response = await NetworkHelper().getApi(
  //     ApiUrls().gettask,
  //   );
  //   logger.d(response.body);
  //   final jsonBody = json.decode(response.body);
  //   logger.d(jsonBody['data']);

  //   _getTasks = jsonBody['data']
  //       .map<taskByDate>((m) => taskByDate.fromJson(m))
  //       .toList();
  //   notifyListeners();
  // }
}
