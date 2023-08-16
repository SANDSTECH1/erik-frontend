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

class TaskViewModel with ChangeNotifier {
  final TextEditingController taskTitlecontroller = TextEditingController();
  final TextEditingController estimatedTimecontroller = TextEditingController();
  final TextEditingController pricecontroller = TextEditingController();

  String daycontroller = "";
  String timecontroller = "";
  String getFormattedMonthAndYearcontroller = "";
  DateTime? selectedDay;
  bool isTimeModified = false;

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
    clearSelectedTime();
  }
  Future<void> hideLoader(BuildContext context) async {
    Navigator.of(context).pop();
  }

  void createTask(BuildContext context) async {
    try {
      showLoader(context);

      List assignedmembers =
          _users.where((element) => element.selected == true).toList();
      List<String> ids =
          assignedmembers.map((user) => user.sId.toString()).toList();

      String date = daycontroller;
      String time = timecontroller;
      int combinedDateTimeMillis = combineDateAndTime(date, time);

      DateTime combinedDateTimeUtc = DateTime.fromMillisecondsSinceEpoch(
          combinedDateTimeMillis,
          isUtc: true);
      final formattedDateTime =
          DateFormat("yyyy-MM-ddTHH:mm:ss'Z'").format(combinedDateTimeUtc);

      final response = await NetworkHelper().postApi(ApiUrls().createtask, {
        "title": taskTitlecontroller.text,
        "description": taskDescriptioncontroller.text,
        "assignedUsers": ids,
        "scheduledDateTime": formattedDateTime,
        "estimatedTime": estimatedTimecontroller.text,
        "price": pricecontroller.text,
      });
      //hideLoader(context);
      logger.d(response.body);
      final body = response.body;
      final jsonBody = json.decode(body);

      if (response.statusCode == 200) {
        showtoast("Task Created Successfully");
        taskTitlecontroller.clear();
        taskDescriptioncontroller.clear();
        daycontroller = '';
        timecontroller = '';
        estimatedTimecontroller.clear();
        pricecontroller.clear();
        clearAssignedUsers();
        changeselectedate(null);
        clearSelectedTime();
      } else if (response.statusCode == 400) {
        showtoast(jsonBody['message']);
        return; // Return without navigating
      } else {
        showtoast('Failed to create the task');
        return; // Return without navigating
      }
    } catch (e) {
      showtoast('Error creating task: $e');
      return; // Return without navigating
    } finally {
      hideLoader(context); // Hide the loader regardless of success or error
    }
    Navigator.pop(context);
    // After the try-catch-finally block, navigate to the calendar screen
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const calender_screen()),
    );
  }

  void editTask(BuildContext context, taskByDate task) async {
    try {
      showLoader(context);
      List assignedmembers =
          _users.where((element) => element.selected == true).toList();
      List<String> ids =
          assignedmembers.map((user) => user.sId.toString()).toList();

      // Check if the time is empty or not
      String date = daycontroller;
      String time = timecontroller;
      int combinedDateTimeMillis = combineDateAndTime(date, time);

      String? formattedDateTimeStr;

      if (combinedDateTimeMillis != 0) {
        // Use the provided date and time
        DateTime localDateTime = DateTime.fromMillisecondsSinceEpoch(
          combinedDateTimeMillis,
          isUtc: true,
        ).toLocal();

        formattedDateTimeStr =
            DateFormat("yyyy-MM-ddTHH:mm:ss'Z'").format(localDateTime.toUtc());
      } else {
        // Use the existing scheduled time from the task
        formattedDateTimeStr = task.scheduledDateTime;
      }

      final response = await NetworkHelper().putApi(
        "${ApiUrls().updatetask}/${task.sId}",
        {
          "title": taskTitlecontroller.text,
          "description": taskDescriptioncontroller.text,
          "assignedUsers": ids,
          "estimatedTime": estimatedTimecontroller.text,
          "price": pricecontroller.text,
          "scheduledDateTime": formattedDateTimeStr,
        },
      );

      final body = response.body;
      final jsonBody = json.decode(body);

      if (response.statusCode == 200) {
        hideLoader(context);
        showtoast('Task updated successfully');

        // Check the current route before navigating
        if (ModalRoute.of(context)?.settings.name != '/calender_screen') {
          // Use the Navigator.pushReplacement method to navigate to the calendar screen
          Navigator.pop(context);
          // Navigator.pushReplacement(
          //   context,
          //   MaterialPageRoute(builder: (context) => const calender_screen()),
          // );
        }

        // Clear fields and selections
        taskTitlecontroller.clear();
        taskDescriptioncontroller.clear();
        timecontroller = '';
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
    } finally {
      hideLoader(context); // Hide the loader regardless of success or error
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
    clearSelectedTime();
    showLoader(context);

    // Convert UTC scheduledDateTime to local time
    final int milliseconds = int.parse(task.scheduledDateTime ?? "0");
    if (milliseconds != 0) {
      final DateTime utcDateTime =
          DateTime.fromMillisecondsSinceEpoch(milliseconds, isUtc: true);
      final localDateTime = utcDateTime.toLocal();

      daycontroller = DateFormat('yyyy-MM-dd').format(localDateTime);
      selectedDay = localDateTime;

      // Automatically save the time without opening the time picker
      selectedTime = TimeOfDay.fromDateTime(localDateTime);
      isTimeModified = false; // Set time modification flag to false
    }

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

    showtoast("Edit your Task Or Add Subtasks As Well");

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditTask(
          tasks: task,
        ),
      ),
    );
  }

  void viewtasks(BuildContext context, taskByDate taskss) {
    taskDescriptioncontroller.text = taskss.description.toString();
    taskTitlecontroller.text = taskss.title.toString();
    estimatedTimecontroller.text = taskss.estimatedTime.toString();
    pricecontroller.text = taskss.price.toString();
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

  resetUserSelections() {
    for (var user in _users) {
      user.selected = false;
    }
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

  initializeTimeForNewSubtask(context) {
    selectedTime = TimeOfDay.now();
    timecontroller = selectedTime.format(context);
  }

  // Initialize time for editing an existing subtask
  void initializeTimeForExistingSubtask(TimeOfDay scheduledTime, context) {
    // Set the selected time to the subtask's scheduled time
    selectedTime = scheduledTime;

    // Update timecontroller
    timecontroller = selectedTime.format(context);
  }

  void clearAssignedUsers() {
    _users.forEach((user) {
      user.selected = false;
    });
    notifyListeners();
  }

  clearSelectedTime() {
    selectedTime = TimeOfDay.now();
    timecontroller = '';
    notifyListeners();
  }

  void showTimePickerAndUpdateFlag(BuildContext context) async {
    final pickedTime = await showTimePicker(
      context: context,
      initialTime: selectedTime ?? TimeOfDay.now(),
    );

    if (pickedTime != null) {
      selectedTime = pickedTime;
      isTimeModified = true;
      notifyListeners();
    }
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

int combineDateAndTime(String? date, String? time) {
  if (date == null || time == null) {
    throw ArgumentError("Date and time must not be null.");
  }

  DateTime parsedDate = DateTime.parse(date);
  DateTime parsedTime = DateFormat("h:mm a").parse(time);

  // Convert to local time zone (if needed)
  DateTime combinedDateTime = DateTime(
    parsedDate.year,
    parsedDate.month,
    parsedDate.day,
    parsedTime.hour,
    parsedTime.minute,
  );

  // Convert to UTC before getting milliseconds since epoch
  int millisecondsSinceEpoch = combinedDateTime.toUtc().millisecondsSinceEpoch;

  return millisecondsSinceEpoch;
}
