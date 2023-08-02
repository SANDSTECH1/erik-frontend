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
import 'package:table_calendar/table_calendar.dart';

String userToken = "";

class SubTaskViewModel with ChangeNotifier {
  final TextEditingController subtaskTitlecontroller = TextEditingController();
  final TextEditingController estimatedTimecontroller = TextEditingController();
  final TextEditingController pricecontroller = TextEditingController();
  final TextEditingController subtaskDescriptioncontroller =
      TextEditingController();

  String daycontroller = "";
  String timecontroller = "";
  String getFormattedMonthAndYearcontroller = "";
  DateTime? selectedDay;

  List<userListData> _users = [];
  List<userListData> get usersdata => _users;

  CalendarFormat calendarFormat = CalendarFormat.month;
  DateTime focusedDay = DateTime.now();

  final kFirstDay = DateTime(
      DateTime.now().year, DateTime.now().month - 3, DateTime.now().day);
  final kLastDay = DateTime(
      DateTime.now().year, DateTime.now().month + 12, DateTime.now().day);

  TimeOfDay selectedTime = TimeOfDay.now();

  SubTaskViewModel() {
    getmembers();
  }
// Function to create subtasks for each subtask data
  Future<void> createSubTasksForAll(List<subtasks> subtasksList) async {
    for (subtasks subtaskData in subtasksList) {
      String taskId = subtaskData.task ?? "";
      await createSubTask(taskId);
    }
  }

  createSubTask(
    context,
  ) async {
    String taskId = "";
    // print("timecontroller$timecontroller");
    // print("daycontroller $daycontroller");
    print(estimatedTimecontroller);
    print(pricecontroller);

    final response = await NetworkHelper().postApi(ApiUrls().createsubtask, {
      "title": subtaskTitlecontroller.text,
      "description": subtaskDescriptioncontroller.text,
      "task": taskId,
      // "scheduledDateTime": combinedDateTime,
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

  void editTask(BuildContext context, taskByDate subtask) async {
    try {
      List assignedmembers =
          _users.where((element) => element.selected == true).toList();
      print(assignedmembers.length);
      List<String> ids =
          assignedmembers.map((user) => user.sId.toString()).toList();
      //final combinedDateTime = combineDateAndTime(task.scheduledDateTime, '');
      String date = daycontroller; // Assuming the value is "2023-07-21"
      String time = timecontroller; // Assuming the value is "8:58 AM"
      print(
        {
          "title": subtaskTitlecontroller.text,
          "description": subtaskDescriptioncontroller.text,
          "task": ids,
          "estimatedTime": estimatedTimecontroller.text,
          "price": pricecontroller.text,
        },
      );

      final response = await NetworkHelper().putApi(
        "${ApiUrls().updatesubtasks}/${subtask.sId}",
        {
          "title": subtaskTitlecontroller.text,
          "description": subtaskDescriptioncontroller.text,
          "task": ids,
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

  deleteTask(context, taskByDate subtask) async {
    final response = await NetworkHelper()
        .deleteApi("${ApiUrls().deletesubtasks}/${subtask.sId}");
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
    taskByDate subtask,
  ) {
    List assignedmembers =
        _users.where((element) => element.selected == true).toList();
    print(assignedmembers.length);
    List<String> ids =
        assignedmembers.map((user) => user.sId.toString()).toList();
    subtaskDescriptioncontroller.text = subtask.description.toString();
    subtaskTitlecontroller.text = subtask.title.toString();
    pricecontroller.text = subtask.price.toString();
    estimatedTimecontroller.text = subtask.estimatedTime.toString();
    final parsedDateTime = DateTime.parse(subtask.scheduledDateTime.toString());
    final formattedTime =
        DateFormat('hh:mm a').format(parsedDateTime.toLocal());
    final formattedDate =
        DateFormat('yyyy-MM-dd').format(parsedDateTime.toLocal());
    selectedTime =
        TimeOfDay.fromDateTime(DateFormat('hh:mm a').parse(formattedTime));

    daycontroller = formattedDate;
    selectedDay = DateFormat('yyyy-MM-dd').parse(formattedDate);
    print(formattedDate);
    //print('Assigned User IDs: $assignedUserIds');
    //print(formattedDate1);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SubAssignTask(
          subtasks: subtask,
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
