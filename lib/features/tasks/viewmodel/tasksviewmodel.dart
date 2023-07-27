import 'package:erick/features/tasks/model/tasks.dart';
import 'package:erick/features/tasks/model/usermember.dart';
import 'package:erick/features/tasks/view/assigntask.dart';
import 'package:erick/features/tasks/view/calender_screen.dart';
import 'package:erick/features/tasks/view/edittasks.dart';
import 'package:erick/helper/logger/logger.dart';
import 'package:erick/helper/network/network.dart';
import 'package:erick/helper/toast/toast.dart';
import 'package:flutter/material.dart';
import 'dart:convert';

import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

String userToken = "";

class TaskViewModel with ChangeNotifier {
  final TextEditingController taskTitlecontroller = TextEditingController();

  String daycontroller = "";
  String timecontroller = "";
  DateTime? selectedDay;

  final TextEditingController taskDescriptioncontroller =
      TextEditingController();

  List<userListData> _users = [];
  List<userListData> get usersdata => _users;

  CalendarFormat calendarFormat = CalendarFormat.month;
  DateTime focusedDay = DateTime.now();

  final kFirstDay = DateTime(
      DateTime.now().year, DateTime.now().month - 3, DateTime.now().day);
  final kLastDay = DateTime(
      DateTime.now().year, DateTime.now().month + 3, DateTime.now().day);

  TimeOfDay selectedTime = TimeOfDay.now();

  TaskViewModel() {
    getmembers();
  }

  createTask(
    context,
  ) async {
    List assignedmembers =
        _users.where((element) => element.selected == true).toList();
    print(assignedmembers.length);
    List<String> ids =
        assignedmembers.map((user) => user.sId.toString()).toList();
    // print(ids);
    // print(taskTitlecontroller.text);
    // print(taskDescriptioncontroller.text);
    print("timecontroller$timecontroller");
    print("daycontroller $daycontroller");

    String date = daycontroller; // Assuming the value is "2023-07-21"
    String time = timecontroller; // Assuming the value is "8:58 AM"

    String combinedDateTime = combineDateAndTime(date, time);
    print(combinedDateTime); // Output: "2023-07-21T08:58:00"

    final response = await NetworkHelper().postApi(ApiUrls().createtask, {
      "title": taskTitlecontroller.text,
      "description": taskDescriptioncontroller.text,
      "assignedUsers": ids,
      "scheduledDateTime": combinedDateTime,
    });

    logger.d(response.body);
    final body = response.body;
    final jsonBody = json.decode(body);
    if (response.statusCode == 200) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const calender_screen()),
      );
    } else if (response.statusCode == 400) {
      showtoast(jsonBody['message']);
    } else {
      // throw Exception(
      //     'Failed to make the API request. Status code: ${response.statusCode}');
    }
  }

  editTask(context, taskByDate task) async {
    List<String> ids =
        task.assignedUsers!.map((user) => user.sId.toString()).toList();

    String combinedDateTime = combineDateAndTime(task.scheduledDateTime, '');

    final response = await NetworkHelper().putApi(ApiUrls().updatetask, {
      "id": task.sId, // Assuming you have an id field in your taskByDate class
      "title": task.title,
      "description": task.description,
      "assignedUsers": ids,
      "scheduledDateTime": combinedDateTime,
    });

    logger.d(response.body);
    final body = response.body;
    final jsonBody = json.decode(body);
    if (response.statusCode == 200) {
      // Handle successful update, e.g., show a toast or navigate to another screen
      showtoast('Task updated successfully');
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => EditTask(tasks: task)),
      );
    } else if (response.statusCode == 400) {
      showtoast(jsonBody['message']);
    } else {
      // Handle error
      showtoast('Failed to update the task');
    }
  }

  // deleteTask() async {
  //   final response = await NetworkHelper().deleteApi(ApiUrls().deletetask);
  //   if (response.statusCode == 200) {
  //     // Handle successful DELETE response
  //   } else {
  //     // Handle error
  //   }
  //   return response;
  // }

  void editTaskclick(BuildContext context, taskByDate task) {
    taskDescriptioncontroller.text = task.description.toString();
    taskTitlecontroller.text = task.title.toString();
    final parsedDateTime = DateTime.parse(task.scheduledDateTime.toString());
    final formattedTime =
        DateFormat('hh:mm a').format(parsedDateTime.toLocal());
    final formattedDate =
        DateFormat('yyyy-MM-dd').format(parsedDateTime.toLocal());
    selectedTime =
        TimeOfDay.fromDateTime(DateFormat('hh:mm a').parse(formattedTime));

    daycontroller = formattedDate;
    selectedDay = DateFormat('yyyy-MM-dd').parse(formattedDate);
    print(formattedDate);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditTask(tasks: task),
      ),
    );
  }

  getmembers() async {
    final response = await NetworkHelper().getApi(
      ApiUrls().getuser,
    );
    logger.d(response.body);
    final jsonBody = json.decode(response.body);
    logger.d(jsonBody['data']);

    _users = jsonBody['data']
        .map<userListData>((m) => userListData.fromJson(m))
        .toList();
    notifyListeners();
  }

  changeselectedate(s) {
    selectedDay = s;
    daycontroller = s.toString();
    notifyListeners();
  }

  changeSelectedUser(int, value) {
    _users[int].selected = value;
    notifyListeners();
  }

  changeTime(pickedTime, context) {
    selectedTime = pickedTime;
    timecontroller = selectedTime.format(context);
    notifyListeners();
  }
}

String combineDateAndTime(String? date, String? time) {
  if (date == null || time == null) {
    throw ArgumentError("Date and time must not be null.");
  }
  final DateTime selectedDate = DateFormat("yyyy-MM-dd").parse(date);
  final TimeOfDay selectedTime = TimeOfDay(
    hour: int.parse(time.split(":")[0]),
    minute: int.parse(time.split(":")[1].split(" ")[0]),
  );

  final DateTime combinedDateTime = DateTime(
    selectedDate.year,
    selectedDate.month,
    selectedDate.day,
    selectedTime.hour,
    selectedTime.minute,
  );

  final DateFormat format = DateFormat("yyyy-MM-ddTHH:mm:ss");
  final String formattedDateTime = format.format(combinedDateTime);
  return formattedDateTime;
}
