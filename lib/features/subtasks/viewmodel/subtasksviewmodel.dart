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

  List<taskByDate> _subtasks = [];
  List<taskByDate> get subtasksdata => _subtasks;

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

  void editTask(BuildContext context, taskByDate task) async {
    try {
      final response = await NetworkHelper().putApi(
        "${ApiUrls().updatesubtasks}/${task.sId}",
        {
          "subTaskTitle": subtaskTitlecontroller.text,
          "subTaskDescription": subtaskDescriptioncontroller.text,
          "task": task,
          "estimatedTime": estimatedTimecontroller.text,
          "price": pricecontroller.text,
        },
      );
      final body = response.body;
      final jsonBody = json.decode(body);

      if (response.statusCode == 200) {
        // Handle successful update, e.g., show a toast or navigate to another screen
        showtoast('Task updated successfully');
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

  deleteTask(context, taskid) async {
    final response = await NetworkHelper()
        .deleteApi("${ApiUrls().deletesubtasks}/${taskid}");
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
    taskid,
  ) {
    subtaskDescriptioncontroller.text = taskid.description.toString();
    subtaskTitlecontroller.text = taskid.title.toString();
    pricecontroller.text = taskid.price.toString();
    estimatedTimecontroller.text = taskid.estimatedTime.toString();

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => editSubAssignTask(
          id: taskid,
          // assignedUserIds: ids,
        ),
      ),
    );
  }

  void viewtasks(BuildContext context, taskByDate subtaskss) {
    subtaskDescriptioncontroller.text = subtaskss.description.toString();
    subtaskTitlecontroller.text = subtaskss.title.toString();
    List assignedmembers =
        _users.where((element) => element.selected == true).toList();
    print(assignedmembers.length);
    List<String> ids =
        assignedmembers.map((user) => user.sId.toString()).toList();

    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => ViewSubTasks(
                subtasks: subtaskss,
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
