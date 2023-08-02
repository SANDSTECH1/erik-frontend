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
  void createSubTasksForAll() async {
    for (taskByDate taskData in _subtasks) {
      String taskId =
          taskData.sId ?? ""; // Get the taskId from the taskByDate object
      await createSubTask(taskId);
    }
  }

  createSubTask(
    context,
  ) async {
    String taskId = "";
    print(subtaskTitlecontroller.text);
    print(subtaskDescriptioncontroller.text);
    //print(taskId);

    final response = await NetworkHelper().postApi(ApiUrls().createsubtask, {
      "title": subtaskTitlecontroller.text,
      "description": subtaskDescriptioncontroller.text,
      "task": taskId,
      "estimatedTime": estimatedTimecontroller.text,
      "price": pricecontroller.text,
    });

    logger.d(response.body);
    final body = response.body;
    final jsonBody = json.decode(body);
    if (response.statusCode == 200) {
      // Navigator.push(
      //   context,
      //   MaterialPageRoute(builder: (context) => const calender_screen()),
      // );
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
