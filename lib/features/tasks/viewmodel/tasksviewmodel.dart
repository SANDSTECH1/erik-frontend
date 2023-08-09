import 'package:erick/features/tasks/model/tasks.dart';
import 'package:erick/features/tasks/model/usermember.dart';
import 'package:erick/features/tasks/view/calender_screen.dart';
import 'package:erick/features/tasks/view/edittasks.dart';
import 'package:erick/features/tasks/view/viewtasks.dart';
import 'package:erick/helper/loader/loader.dart';
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
  final TextEditingController estimatedTimecontroller = TextEditingController();
  final TextEditingController pricecontroller = TextEditingController();

  String daycontroller = "";
  String timecontroller = "";
  String getFormattedMonthAndYearcontroller = "";
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
      DateTime.now().year, DateTime.now().month + 12, DateTime.now().day);

  TimeOfDay selectedTime = TimeOfDay.now();

  TaskViewModel() {
    getmembers();
  }
  Future<void> hideLoader(BuildContext context) async {
    Navigator.of(context).pop();
  }

  createTask(
    context,
  ) async {
    showLoader(context);
    List assignedmembers =
        _users.where((element) => element.selected == true).toList();
    print(assignedmembers.length);
    List<String> ids =
        assignedmembers.map((user) => user.sId.toString()).toList();

    String date = daycontroller; // Assuming the value is "2023-07-21"
    String time = timecontroller;
    String combinedDateTime = combineDateAndTime(date, time);
    print(combinedDateTime); // Output: "2023-07-21T08:58:00"

    final response = await NetworkHelper().postApi(ApiUrls().createtask, {
      "title": taskTitlecontroller.text,
      "description": taskDescriptioncontroller.text,
      "assignedUsers": ids,
      "scheduledDateTime": combinedDateTime,
      "estimatedTime": combinedDateTime,
      "price": pricecontroller.text,
    });

    logger.d(response.body);
    final body = response.body;
    final jsonBody = json.decode(body);
    if (response.statusCode == 200) {
      hideLoader(context);
      showtoast("Task Created Successfully");
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const calender_screen()),
      );
      taskTitlecontroller.clear();
      taskDescriptioncontroller.clear();
      daycontroller = '';
      timecontroller = '';
      combinedDateTime = '';
      estimatedTimecontroller.clear();
      pricecontroller.clear();
      clearAssignedUsers();
      changeselectedate(null);
      clearSelectedTime();
      //changeTime(selectedTime, null);
    } else if (response.statusCode == 400) {
      showtoast(jsonBody['message']);
    } else {
      showtoast('Failed to create the task');
    }
  }

  void editTask(BuildContext context, taskByDate task) async {
    try {
      List assignedmembers =
          _users.where((element) => element.selected == true).toList();
      print(assignedmembers.length);
      List<String> ids =
          assignedmembers.map((user) => user.sId.toString()).toList();
      //final combinedDateTime = combineDateAndTime(task.scheduledDateTime, '');
      String date = daycontroller; // Assuming the value is "2023-07-21"
      String time = timecontroller; // Assuming the value is "8:58 AM"

      String combinedDateTime = combineDateAndTime(date, time);
      final response = await NetworkHelper().putApi(
        "${ApiUrls().updatetask}/${task.sId}",
        {
          "title": taskTitlecontroller.text,
          "description": taskDescriptioncontroller.text,
          "assignedUsers": ids,
          "estimatedTime": estimatedTimecontroller.text,
          "price": pricecontroller.text,
          "scheduledDateTime": combinedDateTime
        },
      );
      final body = response.body;
      final jsonBody = json.decode(body);

      if (response.statusCode == 200) {
        showLoader(context);
        showtoast('Task updated successfully');
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => calender_screen()),
        );
        taskTitlecontroller.clear();
        taskDescriptioncontroller.clear();
        daycontroller = '';
        timecontroller = '';
        combinedDateTime = "";
        estimatedTimecontroller.clear();
        pricecontroller.clear();
        clearAssignedUsers();
        changeselectedate(null);
        clearSelectedTime();
      } else if (response.statusCode == 400) {
        showtoast(jsonBody['message']);
      } else {
        showtoast('Failed to update the task');
      }
    } catch (e) {
      showtoast('Error updating task: $e');
    }
  }

  deleteTask(context, taskByDate task) async {
    final response =
        await NetworkHelper().deleteApi("${ApiUrls().deletetask}/${task.sId}");
    if (response.statusCode == 200) {
      showtoast('Task deleted successfully');
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => calender_screen()),
      );
    } else {
      showtoast('Failed to delete the task');
    }
    return response;
  }

  void editTaskclick(
    BuildContext context,
    taskByDate task,
  ) {
    clearAssignedUsers();
    showLoader(context);
    hideLoader(context);
    List<String> ids =
        task.assignedUsers!.map((user) => user.sId.toString()).toList();

    print('Assigned User IDs: $ids');

    // Iterate through the assigned user IDs and update the selected property
    for (final assignedUserId in ids) {
      final userIndex =
          _users.indexWhere((user) => user.sId.toString() == assignedUserId);
      if (userIndex != -1) {
        _users[userIndex].selected = true;
        print('User with ID $assignedUserId is marked as selected.');
      }
    }

    taskDescriptioncontroller.text = task.description.toString();
    taskTitlecontroller.text = task.title.toString();
    pricecontroller.text = task.price.toString();
    estimatedTimecontroller.text = task.estimatedTime.toString();
    final int milliseconds = int.parse(task.scheduledDateTime ?? "0");
    final DateTime parsedDateTime =
        DateTime.fromMillisecondsSinceEpoch(milliseconds);

    final formattedTime =
        DateFormat('hh:mm a').format(parsedDateTime.toLocal());
    final formattedDate =
        DateFormat('yyyy-MM-dd').format(parsedDateTime.toLocal());
    selectedTime =
        TimeOfDay.fromDateTime(DateFormat('hh:mm a').parse(formattedTime));

    daycontroller = formattedDate;
    selectedDay = DateFormat('yyyy-MM-dd').parse(formattedDate);

    print(formattedDate);
    hideLoader(context);
    showtoast("Edit your Task Or Add Subtasks As Well");
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditTask(
          tasks: task,
        ),
      ),
    );
    // taskDescriptioncontroller.clear();
    // taskTitlecontroller.clear();
    // pricecontroller.clear();
    // estimatedTimecontroller.clear();
    // clearAssignedUsers();
    // changeselectedate(null);
    // clearSelectedTime();
  }

  void viewtasks(BuildContext context, taskByDate taskss) {
    taskDescriptioncontroller.text = taskss.description.toString();
    taskTitlecontroller.text = taskss.title.toString();
    List assignedmembers =
        _users.where((element) => element.selected == true).toList();
    print(assignedmembers.length);
    List<String> ids =
        assignedmembers.map((user) => user.sId.toString()).toList();
    showtoast("View Your Task");
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => ViewTask(
                tasks: taskss,
              )),
    );
  }

  getmembers() async {
    print('memberscall');
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
    if (s == null) {
      selectedDay = null;
      daycontroller = '';
    } else {
      selectedDay = s;
      daycontroller = s.toString();
    }
    notifyListeners();
  }

  changeSelectedUser(int, value) {
    _users[int].selected = value;
    notifyListeners();
  }

  changeTime(pickedTime, context) {
    if (pickedTime == null) {
      // If pickedTime is null, it means the time selection was canceled, so clear the time.
      selectedTime = TimeOfDay.now();
      timecontroller = '';
    } else {
      // Otherwise, update the selected time.
      selectedTime = pickedTime;
      timecontroller = selectedTime.format(context);
    }
    notifyListeners();
  }

  void clearAssignedUsers() {
    _users.forEach((user) {
      user.selected = false;
    });
    notifyListeners();
  }

  void clearSelectedTime() {
    selectedTime = TimeOfDay.now();
    timecontroller = '';
    notifyListeners();
  }

  putimage(String url, data, file, type) async {
    try {
      final response = await NetworkHelper().mediaFormUpload(
          "http://localhost:4000/api/v1/updateImage", [], file, "image");
      if (response['success'] == true) {
        print('Image update successful');
      } else {
        print('Failed to update image: ${response['message']}');
      }
    } catch (e) {
      print('Error updating image: $e');
    }
  }
}

String combineDateAndTime(String? date, String? time) {
  if (date == null || time == null) {
    throw ArgumentError("Date and time must not be null.");
  }

  // Parse the date and time strings separately
  DateTime parsedDate = DateTime.parse(date);
  DateTime parsedTime = DateFormat("h:mm a").parse(time);

  // Combine the date and time
  DateTime combinedDateTime = DateTime(
    parsedDate.year,
    parsedDate.month,
    parsedDate.day,
    parsedTime.hour,
    parsedTime.minute,
  );

  // Get the milliseconds since the epoch
  int millisecondsSinceEpoch = combinedDateTime.millisecondsSinceEpoch;

  print(millisecondsSinceEpoch); // Output: 1677768000000

  // Convert the DateTime back to a formatted string if needed
  final DateFormat format = DateFormat("yyyy-MM-ddTHH:mm:ss'Z'");
  final String formattedDateTime = format.format(combinedDateTime);
  return formattedDateTime;
}
