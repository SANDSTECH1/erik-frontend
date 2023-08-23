import 'package:erick/features/subtasks/view/editsubtasks.dart';
import 'package:erick/features/tasks/model/tasks.dart';
import 'package:erick/features/tasks/model/usermember.dart';
import 'package:erick/features/tasks/view/calender_screen.dart';
import 'package:erick/helper/loader/loader.dart';
import 'package:erick/helper/logger/logger.dart';
import 'package:erick/helper/network/network.dart';
import 'package:erick/helper/toast/toast.dart';
import 'package:erick/features/subtasks/view/viewsubtask.dart';
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
  final TextEditingController searchController = TextEditingController();

  String daycontroller = "";
  String timecontroller = "";
  DateTime? selectedDay;
  List<userListData> _users = [];
  List<userListData> get usersdata => _users;
  TimeOfDay selectedTime = TimeOfDay.now();
  List<userListData> _filteredUsers = [];
  List<userListData> get filteredUsers => _filteredUsers;
  bool isTimeModified = false;

  set filteredUsers(List<userListData> value) {
    _filteredUsers = value;
    notifyListeners();
  }

  SubTaskViewModel() {
    getmembers();
  }

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
      List assignedmembers =
          _users.where((element) => element.selected == true).toList();
      List<String> ids =
          assignedmembers.map((user) => user.sId.toString()).toList();
      // After populating assignedmembers
      for (final user in _users) {
        user.selected = assignedmembers.contains(user);
      }
      final formattedDateTime = combineTimeWithCurrentDay(timecontroller);
      final response = await NetworkHelper().postApi(ApiUrls().createsubtask, {
        "subTaskTitle": subtaskTitlecontroller.text,
        "subTaskDescription": subtaskDescriptioncontroller.text,
        "task": taskid,
        "estimatedTime": estimatedTimecontroller.text,
        "price": pricecontroller.text,
        "scheduledDateTime": formattedDateTime,
      });

      subtaskDescriptioncontroller.clear();
      subtaskTitlecontroller.clear();
      estimatedTimecontroller.clear();
      pricecontroller.clear();
      clearAssignedUsers();
      clearSelectedTime();
      //selectedTime = TimeOfDay.now();
      logger.d(response.body);
      final body = response.body;
      final jsonBody = json.decode(body);
      if (response.statusCode == 200) {
        showtoast("SubTask Created Successfully");
        hideLoader(context);
        // Navigator.pop(context);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const calender_screen()),
        ).then((_) {
          // Code to handle navigation after returning from the calendar screen
        });
        //Navigator.pop(context);
      } else if (response.statusCode == 400) {
        showtoast(jsonBody['message']);
        hideLoader(context);
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

  void editSubTask(
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
      List assignedmembers =
          _users.where((element) => element.selected == true).toList();
      List<String> ids =
          assignedmembers.map((user) => user.sId.toString()).toList();
      String date = daycontroller;
      String time = timecontroller;

      int combinedDateTimeMillis = combineTimeWithCurrentDay(time);

      String formattedDateTimeStr = "";

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
        formattedDateTimeStr = taskid.scheduledDateTime.toString();
      }
      final response = await NetworkHelper().putApi(
        "${ApiUrls().updatesubtasks}/${taskid.sId}",
        {
          "subTaskTitle": subtaskTitlecontroller.text,
          "subTaskDescription": subtaskDescriptioncontroller.text,
          "task": taskid.task,
          "estimatedTime": estimatedTimecontroller.text,
          "price": pricecontroller.text,
          "scheduledDateTime": formattedDateTimeStr.toString(),
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
        clearSelectedTime();
        clearAssignedUsers();

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

  deleteSubTask(context, SubTasks taskid) async {
    showLoader(context);
    final response = await NetworkHelper()
        .deleteApi("${ApiUrls().deletesubtasks}/${taskid.sId}");
    print(taskid.sId);
    if (response.statusCode == 200) {
      hideLoader(context);
      showtoast('Task deleted successfully');
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => calender_screen()),
      );
    } else {
      hideLoader(context);
      showtoast('Failed to delete the task');
    }
    return response;
  }

  void editSubTaskclicks(BuildContext context, SubTasks subtask) async {
    subtaskTitlecontroller.text = subtask.subTaskTitle.toString();
    subtaskDescriptioncontroller.text = subtask.subTaskDescription.toString();
    pricecontroller.text = subtask.price.toString();
    estimatedTimecontroller.text = subtask.estimatedTime.toString();
    //showLoader(context);
    // if (subtask.assignedUsers != null) {
    //   List<String> ids =
    //       subtask.assignedUsers!.map((user) => user.sId.toString()).toList();

    //   // Iterate through the users and update the 'selected' property based on the assigned user IDs
    //   for (final user in _users) {
    //     user.selected = ids.contains(user.sId.toString());
    //   }
    //   for (final assignedUserId in ids) {
    //     final userIndex =
    //         _users.indexWhere((user) => user.sId.toString() == assignedUserId);
    //     if (userIndex != -1) {
    //       _users[userIndex].selected = true;
    //       print('User with ID $assignedUserId is marked as selected.');
    //     }
    //   }

    //   print('Assigned User IDs: $ids');
    // } else {
    //   print('subtask.assignedUsers is null');
    // }
    // Iterate through the users and update the 'selected' property based on the assigned user IDs
    for (final user in _users) {
      user.selected = subtask.assignedUsers != null &&
          subtask.assignedUsers!
              .any((assignedUser) => assignedUser.sId == user.sId);
    }

// Convert UTC scheduledDateTime to local time
    final int milliseconds = int.parse(subtask.scheduledDateTime ?? "0");
    if (milliseconds != 0) {
      final DateTime utcDateTime =
          DateTime.fromMillisecondsSinceEpoch(milliseconds, isUtc: true);
      final localDateTime = utcDateTime.toLocal();

      daycontroller = DateFormat('yyyy-MM-dd').format(localDateTime);
      print(localDateTime);
      DateTime dateTime = DateTime.parse(localDateTime.toString());
      TimeOfDay timeOfDay =
          TimeOfDay(hour: dateTime.hour, minute: dateTime.minute);

      String formattedTime = DateFormat.jm()
          .format(dateTime); // Format as 12-hour clock with AM/PM

      print(formattedTime);
      timecontroller = formattedTime;

      selectedDay = localDateTime;

      // Automatically save the time without opening the time picker
      selectedTime = TimeOfDay.fromDateTime(localDateTime);
      isTimeModified = false; // Set time modification flag to false
    }
    // Navigate to the editSubAssignTask screen
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => editSubAssignTask(
          id: subtask,
        ),
      ),
    );
  }

  void viewsubtasks(BuildContext context, SubTasks subtask) {
    showLoader(context);
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
    hideLoader(context);
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => ViewSubTasks(
                subtasks: subtask,
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
    _filteredUsers = _users.toList();
    notifyListeners();
  }

  // Update selected user and persist data
  void changeSelectedUser(int index, bool value) async {
    final userId = filteredUsers[index].sId;

    // Update selection state in the main user list
    final userIndex = usersdata.indexWhere((user) => user.sId == userId);
    if (userIndex != -1) {
      usersdata[userIndex].selected = value;
    }

    // Update selection state in the filtered user list
    final filteredIndex =
        filteredUsers.indexWhere((user) => user.sId == userId);
    if (filteredIndex != -1) {
      filteredUsers[filteredIndex].selected = value;
    }
    notifyListeners();
  }

  void filterMembers(String searchTerm) {
    if (searchTerm.isEmpty) {
      // If search input is empty, show all members
      filteredUsers = usersdata;
    } else {
      // Filter members based on search input
      filteredUsers = usersdata.where((user) {
        return user.name!.toLowerCase().contains(searchTerm.toLowerCase());
      }).toList();
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

  int combineTimeWithCurrentDay(String? time) {
    if (time == null) {
      throw ArgumentError("Time must not be null.");
    }

    // Get the current date
    DateTime currentDate = DateTime.now();

    // Parse the selected time
    DateFormat timeFormat = DateFormat("h:mm a");
    DateTime parsedTime = timeFormat.parse(time);

    // Create a new DateTime by combining the current date and the selected time
    DateTime combinedDateTime = DateTime(
      currentDate.year,
      currentDate.month,
      currentDate.day,
      parsedTime.hour,
      parsedTime.minute,
    );

    // Convert to UTC before getting milliseconds since epoch
    int millisecondsSinceEpoch =
        combinedDateTime.toUtc().millisecondsSinceEpoch;

    return millisecondsSinceEpoch;
  }

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
