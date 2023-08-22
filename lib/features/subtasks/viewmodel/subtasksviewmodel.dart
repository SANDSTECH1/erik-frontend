import 'package:erick/features/subtasks/view/editsubtasks.dart';
import 'package:erick/features/tasks/model/tasks.dart';
import 'package:erick/features/tasks/model/usermember.dart';
import 'package:erick/features/tasks/view/calender_screen.dart';
import 'package:erick/helper/loader/loader.dart';
import 'package:erick/helper/network/network.dart';
import 'package:erick/helper/toast/toast.dart';
import 'package:erick/features/subtasks/view/viewtask.dart';
import 'package:flutter/material.dart';
import 'dart:convert';

import 'package:intl/intl.dart';

String userToken = "";

class SubTaskViewModel with ChangeNotifier {
  final TextEditingController subtaskTitlecontroller = TextEditingController();
  final TextEditingController estimatedTimecontroller = TextEditingController();
  final TextEditingController pricecontroller = TextEditingController();
  final TextEditingController subtaskDescriptioncontroller =
      TextEditingController();

  String timecontroller = '';
  String daycontroller = DateFormat('yyyy-MM-dd').format(DateTime.now());
  DateTime? selectedDay;
  List<userListData> _users = [];
  List<userListData> get usersdata => _users;
  TimeOfDay selectedTime = TimeOfDay.now();

  Future<void> hideLoader(BuildContext context) async {
    Navigator.of(context).pop();
  }

  void createSubTask(BuildContext context, taskid) async {
    showLoader(context);

    if (subtaskTitlecontroller.text.isEmpty ||
        subtaskDescriptioncontroller.text.isEmpty ||
        estimatedTimecontroller.text.isEmpty ||
        pricecontroller.text.isEmpty) {
      showtoast('Please fill in all required fields');
      hideLoader(context);
      return; // Do not proceed
    }
    try {
      // String date = daycontroller;
      // String time = timecontroller;

      // int combinedDateTimeMillis = combineDateAndTime(date, time);

      // DateTime combinedDateTimeUtc = DateTime.fromMillisecondsSinceEpoch(
      //     combinedDateTimeMillis,
      //     isUtc: true);
      // final formattedDateTime =
      //     DateFormat("yyyy-MM-ddTHH:mm:ss'Z'").format(combinedDateTimeUtc);

      final response = await NetworkHelper().postApi(ApiUrls().createsubtask, {
        "subTaskTitle": subtaskTitlecontroller.text,
        "subTaskDescription": subtaskDescriptioncontroller.text,
        "task": taskid,
        "estimatedTime": estimatedTimecontroller.text,
        "price": pricecontroller.text,
        //"scheduledDateTime": formattedDateTime,
      });

      subtaskDescriptioncontroller.clear();
      subtaskTitlecontroller.clear();
      estimatedTimecontroller.clear();
      pricecontroller.clear();
      clearAssignedUsers();
      clearSelectedTime();
      //selectedTime = TimeOfDay.now();

      if (response.statusCode == 200) {
        hideLoader(context);
        showtoast("SubTask Created Successfully");
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const calender_screen()),
        );
        Navigator.pop(context);
      } else if (response.statusCode == 400) {
        //showtoast(jsonBody['message']);
      } else {
        showtoast("Failed To Create SubTask");
        hideLoader(context);
      }
    } catch (e) {
      showtoast("Error creating SubTask: $e");
      hideLoader(context);
    } finally {
      hideLoader(context);
    }
  }

  void editTask(
    BuildContext context,
    SubTasks taskid,
  ) async {
    print(taskid.sId);
    if (subtaskTitlecontroller.text.isEmpty ||
        subtaskDescriptioncontroller.text.isEmpty ||
        estimatedTimecontroller.text.isEmpty ||
        pricecontroller.text.isEmpty) {
      showtoast('Please fill in all required fields');
      return; // Do not proceed
    }
    try {
      showLoader(context);
      String date = daycontroller;
      String time = timecontroller;

      // int combinedDateTimeMillis = combineDateAndTime(date, time);

      // String? formattedDateTimeStr;

      // if (combinedDateTimeMillis != 0) {
      //   // Use the provided date and time
      //   DateTime localDateTime = DateTime.fromMillisecondsSinceEpoch(
      //     combinedDateTimeMillis,
      //     isUtc: true,
      //   ).toLocal();

      //   formattedDateTimeStr =
      //       DateFormat("yyyy-MM-ddTHH:mm:ss'Z'").format(localDateTime.toUtc());
      // } else {
      //   // Use the existing scheduled time from the task
      //   formattedDateTimeStr = taskid.scheduledDateTime;
      // }
      final response = await NetworkHelper().putApi(
        "${ApiUrls().updatesubtasks}/${taskid.sId}",
        {
          "subTaskTitle": subtaskTitlecontroller.text,
          "subTaskDescription": subtaskDescriptioncontroller.text,
          "task": taskid.task,
          "estimatedTime": estimatedTimecontroller.text,
          "price": pricecontroller.text,
          //"scheduledDateTime": formattedDateTimeStr,
        },
      );

      final body = response.body;
      final jsonBody = json.decode(body);

      if (response.statusCode == 200) {
        showtoast("SubTask Updated Successfully");
        hideLoader(context);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => calender_screen()),
        );
        subtaskDescriptioncontroller.clear();
        subtaskTitlecontroller.clear();
        estimatedTimecontroller.clear();
        pricecontroller.clear();

        //clearSelectedTime();
      } else if (response.statusCode == 400) {
        hideLoader(context);

        showtoast(jsonBody['message']);
      } else {
        hideLoader(context);

        showtoast('Failed to update the task');
      }
    } catch (e) {
      showtoast('Error updating task: $e');
      hideLoader(context);
    }
  }

  deleteTask(context, SubTasks taskid) async {
    final response = await NetworkHelper()
        .deleteApi("${ApiUrls().deletesubtasks}/${taskid.sId}");
    print(taskid.sId);
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

  editTaskclicks(BuildContext context, SubTasks subtask) async {
    subtaskTitlecontroller.text = subtask.subTaskTitle.toString();
    subtaskDescriptioncontroller.text = subtask.subTaskDescription.toString();
    pricecontroller.text = subtask.price.toString();
    estimatedTimecontroller.text = subtask.estimatedTime.toString();

    // // Convert UTC scheduledDateTime to local time
    // final int milliseconds = int.parse(subtask.scheduledDateTime ?? "0");
    // if (milliseconds != 0) {
    //   final DateTime utcDateTime =
    //       DateTime.fromMillisecondsSinceEpoch(milliseconds, isUtc: true);
    //   final localDateTime = utcDateTime.toLocal();

    //   daycontroller = DateFormat('yyyy-MM-dd').format(localDateTime);
    //   print(localDateTime);
    //   DateTime dateTime = DateTime.parse(localDateTime.toString());
    //   TimeOfDay timeOfDay =
    //       TimeOfDay(hour: dateTime.hour, minute: dateTime.minute);

    //   String formattedTime = DateFormat.jm()
    //       .format(dateTime); // Format as 12-hour clock with AM/PM

    //   print(formattedTime);
    //   timecontroller = formattedTime;

    //   selectedDay = localDateTime;

    //   // Automatically save the time without opening the time picker
    //   selectedTime = TimeOfDay.fromDateTime(localDateTime);
    //   //isTimeModified = false; // Set time modification flag to false
    // }
    showtoast("Edit your Task");
    bool dataEdited = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => editSubAssignTask(
          id: subtask,
          //updatedTime: selectedTime,
        ),
      ),
    );
    if (dataEdited == true) {
      // Clear the necessary data fields
      subtaskDescriptioncontroller.clear();
      subtaskTitlecontroller.clear();
      estimatedTimecontroller.clear();
      pricecontroller.clear();
      // ...
    }
  }

  void viewtasks(BuildContext context, SubTasks subtask) {
    subtaskDescriptioncontroller.text = subtask.subTaskDescription.toString();
    subtaskTitlecontroller.text = subtask.subTaskTitle.toString();
    estimatedTimecontroller.text = subtask.estimatedTime.toString();
    pricecontroller.text = subtask.price.toString();
    List assignedmembers =
        _users.where((element) => element.selected == true).toList();
    print(assignedmembers.length);
    List<String> ids =
        assignedmembers.map((user) => user.sId.toString()).toList();
    showtoast("View Your Task");
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => ViewSubTasks(
                subtasks: subtask,
              )),
    );
  }

  // changeTime(pickedTime, context) {
  //   if (pickedTime == null) {
  //     // If pickedTime is null, it means the time selection was canceled, so clear the time.
  //     selectedTime = TimeOfDay.now();

  //     timecontroller = '';
  //   } else {
  //     // Otherwise, update the selected time.
  //     selectedTime = pickedTime;
  //     timecontroller = selectedTime.format(context);
  //   }
  //   notifyListeners();
  // }

  // int combineDateAndTime(String? date, String? time) {
  //   if (date == null || time == null) {
  //     throw ArgumentError("Date and time must not be null.");
  //   }

  //   time = time.replaceAll('\u202F', ' ');

  //   DateTime parsedDate = DateTime.parse(date);
  //   DateTime parsedTime = DateFormat("h:mm a").parse(time.toString());
  //   print(parsedTime);

  //   // Convert to local time zone (if needed)
  //   DateTime combinedDateTime = DateTime(
  //     parsedDate.year,
  //     parsedDate.month,
  //     parsedDate.day,
  //     parsedTime.hour,
  //     parsedTime.minute,
  //   );

  //   // Convert to UTC before getting milliseconds since epoch
  //   int millisecondsSinceEpoch =
  //       combinedDateTime.toUtc().millisecondsSinceEpoch;

  //   return millisecondsSinceEpoch;
  // }

  void clearAssignedUsers() {
    _users.forEach((user) {
      user.selected = false;
    });
  }

  void clearSelectedTime() {
    selectedTime = TimeOfDay.now();
    timecontroller = '';
    notifyListeners();
  }
}
