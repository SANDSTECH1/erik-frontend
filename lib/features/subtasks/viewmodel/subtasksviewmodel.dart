import 'package:erick/features/subtasks/model/getSubtasks.dart';
import 'package:erick/features/subtasks/view/editsubtasks.dart';
import 'package:erick/features/tasks/model/tasks.dart';
import 'package:erick/features/tasks/model/usermember.dart';
import 'package:erick/features/tasks/view/calender_screen.dart';
import 'package:erick/helper/logger/logger.dart';
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

  String daycontroller = "";
  String timecontroller = "";

  DateTime? selectedDay;

  List<userListData> _users = [];
  List<userListData> get usersdata => _users;
  TimeOfDay selectedTime = TimeOfDay.now();

  SubTaskViewModel() {
    getmembers();
  }

  createSubTask(context, taskid) async {
    print(subtaskTitlecontroller.text);
    print(subtaskDescriptioncontroller.text);
    //print(taskId);
    final response = await NetworkHelper().postApi(ApiUrls().createsubtask, {
      "subTaskTitle": subtaskTitlecontroller.text,
      "subTaskDescription": subtaskDescriptioncontroller.text,
      "task": taskid,
      "estimatedTime": estimatedTimecontroller.text,
      "price": pricecontroller.text,
    });
    subtaskDescriptioncontroller.clear();
    subtaskTitlecontroller.clear();
    estimatedTimecontroller.clear();
    pricecontroller.clear();
    clearAssignedUsers();

    logger.d(response.body);
    final body = response.body;
    final jsonBody = json.decode(body);
    print(
      subtaskTitlecontroller.text,
    );
    print(
      subtaskDescriptioncontroller.text,
    );
    if (response.statusCode == 200) {
      showtoast("SubTask Created Successfully");
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const calender_screen()),
      );
    } else if (response.statusCode == 400) {
      showtoast(jsonBody['message']);
    } else {
      showtoast(" Failed To Create SubTask");
    }
  }

  void editTask(BuildContext context, SubTasks taskid) async {
    try {
      final response = await NetworkHelper().putApi(
        "${ApiUrls().updatesubtasks}/${taskid.sId}",
        {
          "subTaskTitle": subtaskTitlecontroller.text,
          "subTaskDescription": subtaskDescriptioncontroller.text,
          "task": taskid,
          "estimatedTime": estimatedTimecontroller.text,
          "price": pricecontroller.text,
        },
      );
      print(taskid.sId);
      subtaskDescriptioncontroller.clear();
      subtaskTitlecontroller.clear();
      estimatedTimecontroller.clear();
      pricecontroller.clear();
      clearAssignedUsers();
      final body = response.body;
      final jsonBody = json.decode(body);
      print(
        {
          "subTaskTitle": subtaskTitlecontroller.text,
          "subTaskDescription": subtaskDescriptioncontroller.text,
          "task": taskid,
          "estimatedTime": estimatedTimecontroller.text,
          "price": pricecontroller.text,
        },
      );
      if (response.statusCode == 200) {
        showtoast("SubTask Updated Successfully");
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => calender_screen()),
        );
      } else if (response.statusCode == 400) {
        showtoast(jsonBody['message']);
      } else {
        showtoast('Failed to update the task');
      }
    } catch (e) {
      showtoast('Error updating task: $e');
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

  void editTaskclicks(
    BuildContext context,
    SubTasks subTasks,
  ) {
    subtaskDescriptioncontroller.text = subTasks.subTaskDescription.toString();
    subtaskTitlecontroller.text = subTasks.subTaskTitle.toString();
    pricecontroller.text = subTasks.price.toString();
    estimatedTimecontroller.text = subTasks.estimatedTime.toString();
    print("subTaskDescription: ${subtaskDescriptioncontroller.text}");
    print("subTaskTitle: ${subtaskTitlecontroller.text}");
    print("pricecontroller: ${pricecontroller.text}");
    print("estimatedTimecontroller: ${estimatedTimecontroller.text}");
    print(subTasks.sId);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => editSubAssignTask(
          id: subTasks,
          // assignedUserIds: ids,
        ),
      ),
    );
  }

  void viewtasks(BuildContext context, SubTasks subtasks) {
    subtaskDescriptioncontroller.text = subtasks.subTaskDescription.toString();
    subtaskTitlecontroller.text = subtasks.subTaskTitle.toString();
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => ViewSubTasks(
                subtasks: subtasks,
              )),
    );
  }

  getmembers() async {
    print("getmember");
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
    print(s);
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

  void clearAssignedUsers() {
    _users.forEach((user) {
      user.selected = false;
    });
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
