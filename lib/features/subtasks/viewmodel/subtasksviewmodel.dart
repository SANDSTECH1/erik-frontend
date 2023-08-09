import 'package:erick/features/subtasks/view/editsubtasks.dart';
import 'package:erick/features/tasks/model/tasks.dart';
import 'package:erick/features/tasks/model/usermember.dart';
import 'package:erick/features/tasks/view/calender_screen.dart';
import 'package:erick/helper/loader/loader.dart';
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
  Future<void> hideLoader(BuildContext context) async {
    Navigator.of(context).pop();
  }

  createSubTask(context, taskid) async {
    showLoader(context);
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
      hideLoader(context);
      showtoast("SubTask Created Successfully");
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const calender_screen()),
      );
      subtaskDescriptioncontroller.clear();
      subtaskTitlecontroller.clear();
      estimatedTimecontroller.clear();
      pricecontroller.clear();
    } else if (response.statusCode == 400) {
      showtoast(jsonBody['message']);
    } else {
      showtoast(" Failed To Create SubTask");
    }
  }

  void editTask(
    BuildContext context,
    SubTasks taskid,
  ) async {
    print(taskid.sId);

    try {
      final response = await NetworkHelper().putApi(
        "${ApiUrls().updatesubtasks}/${taskid.sId}",
        {
          "subTaskTitle": subtaskTitlecontroller.text,
          "subTaskDescription": subtaskDescriptioncontroller.text,
          "task": taskid.task,
          "estimatedTime": estimatedTimecontroller.text,
          "price": pricecontroller.text,
        },
      );
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
    SubTasks subtask,
  ) {
    // List assignedmembers =
    //     _users.where((element) => element.selected == true).toList();
    // print(assignedmembers.length);
    // // List<String> ids =
    // //     assignedmembers.map((user) => user.sId.toString()).toList();

    // List<String> ids =
    //     subtask.assignedUsers!.map((user) => user.sId.toString()).toList();

    // print('Assigned User IDs: $ids');

    // // Iterate through the assigned user IDs and update the selected property
    // for (final assignedUserId in ids) {
    //   final userIndex =
    //       _users.indexWhere((user) => user.sId.toString() == assignedUserId);
    //   if (userIndex != -1) {
    //     _users[userIndex].selected = true;
    //     print('User with ID $assignedUserId is marked as selected.');
    //   }
    // }
    subtaskTitlecontroller.text = subtask.subTaskTitle.toString();
    subtaskDescriptioncontroller.text = subtask.subTaskDescription.toString();
    pricecontroller.text = subtask.price.toString();
    estimatedTimecontroller.text = subtask.estimatedTime.toString();
    print("subTaskDescription: ${subtask.subTaskTitle}");
    print("subTaskTitle: ${subtaskTitlecontroller.text}");
    print("pricecontroller: ${pricecontroller.text}");
    print("estimatedTimecontroller: ${estimatedTimecontroller.text}");
    print(subtask.sId);
    showtoast("Edit your Task");
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => editSubAssignTask(
          id: subtask,
          // assignedUserIds: ids,
        ),
      ),
    );
  }

  void viewtasks(BuildContext context, SubTasks subtask) {
    subtaskDescriptioncontroller.text = subtask.subTaskDescription.toString();
    subtaskTitlecontroller.text = subtask.subTaskTitle.toString();
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
