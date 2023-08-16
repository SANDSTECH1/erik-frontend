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
  int selectedUserIndexForEditing = -1;
  DateTime? selectedDay;

  List<userListData> _users = [];
  List<userListData> get usersdata => _users;
  // Create a new list for selected users

  TimeOfDay selectedTime = TimeOfDay.now();
  Future<void> hideLoader(BuildContext context) async {
    Navigator.of(context).pop();
  }

  createSubTask(context, taskid) async {
    showLoader(context);

    // List assignedmembers =
    //     _users.where((element) => element.selected == true).toList();
    // List<String> ids =
    //     assignedmembers.map((user) => user.sId.toString()).toList();
    print(subtaskTitlecontroller.text);
    print(subtaskDescriptioncontroller.text);
    if (subtaskTitlecontroller.text.isEmpty ||
        subtaskDescriptioncontroller.text.isEmpty ||
        estimatedTimecontroller.text.isEmpty ||
        pricecontroller.text.isEmpty) {
      showtoast('Please fill in all required fields');
      hideLoader(context);
      return; // Do not proceed
    }
    try {
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

      subtaskDescriptioncontroller.clear();
      subtaskTitlecontroller.clear();
      estimatedTimecontroller.clear();
      pricecontroller.clear();
      clearAssignedUsers();
      clearSelectedTime();

      if (response.statusCode == 200) {
        selectedTime = selectedTime;
        subtaskDescriptioncontroller.clear();
        subtaskTitlecontroller.clear();
        estimatedTimecontroller.clear();
        pricecontroller.clear();
        clearAssignedUsers();
        //clearSelectedTime();
        hideLoader(context);
        showtoast("SubTask Created Successfully");
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const calender_screen()),
        );
        Navigator.pop(context);
      } else if (response.statusCode == 400) {
        showtoast(jsonBody['message']);
      } else {
        showtoast("Failed To Create SubTask");
      }
    } catch (e) {
      showtoast("Error creating SubTask: $e");
    } finally {
      hideLoader(context); // Hide the loader regardless of success or error
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
      hideLoader(context);
      //clearAssignedUsers();
      return; // Do not proceed
    }
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

      final body = response.body;
      final jsonBody = json.decode(body);

      if (response.statusCode == 200) {
        showtoast("SubTask Updated Successfully");
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => calender_screen()),
        );
        //Navigator.pop(context);
        subtaskDescriptioncontroller.clear();
        subtaskTitlecontroller.clear();
        estimatedTimecontroller.clear();
        pricecontroller.clear();
        //clearAssignedUsers();
        //clearSelectedTime();
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
        ),
      ),
    );
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

  // Initialize time for editing an existing subtask
  void initializeTimeForExistingSubtask(TimeOfDay scheduledTime, context) {
    // Set the selected time to the subtask's scheduled time
    selectedTime = scheduledTime;

    // Update timecontroller
    timecontroller = selectedTime.format(context);
  }
  // submembers() async {
  //   print('memberscall');
  //   final response = await NetworkHelper().getApi(
  //     ApiUrls().getuser,
  //   );
  //   logger.d(response.body);
  //   final jsonBody = json.decode(response.body);
  //   logger.d(jsonBody['data']);

  //   _users = jsonBody['data']
  //       .map<userListData>((m) => userListData.fromJson(m))
  //       .toList();
  //   notifyListeners();
  // }

  // void changeSelectedUser(int index, bool value) {
  //   _users[index].selected = value;
  //   notifyListeners();
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
