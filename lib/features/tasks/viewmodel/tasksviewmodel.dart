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
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:pdf/widgets.dart' as pdfWidgets;
import 'package:flutter/foundation.dart';

class TaskViewModel with ChangeNotifier {
  final TextEditingController taskTitlecontroller = TextEditingController();
  final TextEditingController estimatedTimecontroller = TextEditingController();
  final TextEditingController pricecontroller = TextEditingController();
  final TextEditingController searchController = TextEditingController();

  String daycontroller = "";
  String timecontroller = "";
  String getFormattedMonthAndYearcontroller = "";
  DateTime? selectedDay;
  bool isTimeModified = false;

  final TextEditingController taskDescriptioncontroller =
      TextEditingController();

  List<userListData> _users = [];
  List<userListData> get usersdata => _users;
  List<userListData> _filteredUsers = [];
  List<userListData> get filteredUsers => _filteredUsers;
  set filteredUsers(List<userListData> value) {
    _filteredUsers = value;
    notifyListeners();
  }

  CalendarFormat calendarFormat = CalendarFormat.month;
  DateTime focusedDay = DateTime.now();

  final kFirstDay = DateTime(
      DateTime.now().year, DateTime.now().month - 7, DateTime.now().day);
  final kLastDay = DateTime(
      DateTime.now().year, DateTime.now().month + 40, DateTime.now().day);

  TimeOfDay selectedTime = TimeOfDay.now();

  TaskViewModel() {
    getmembers();
    filteredUsers = _users;

    //clearSelectedTime();
  }
  Future<void> hideLoader(BuildContext context) async {
    Navigator.of(context).pop();
  }

  void createTask(BuildContext context) async {
    try {
      showLoader(context);

      List assignedmembers =
          _filteredUsers.where((element) => element.selected == true).toList();
      List<String> ids =
          assignedmembers.map((user) => user.sId.toString()).toList();

      String date = daycontroller;
      String time = timecontroller;

      int combinedDateTimeMillis = combineDateAndTime(date, time);
      if (date.isEmpty || time.isEmpty) {
        throw Exception("Date and time must be selected.");
      }
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
      clearTaskData();
      if (response.statusCode == 200) {
        hideLoader(context);
        showtoast("Task Created Successfully");
        clearTaskData();
      } else if (response.statusCode == 400) {
        //hideLoader(context);
        showtoast(jsonBody['message']);
        return;
      } else {
        //hideLoader(context);
        showtoast('Failed to create the task');
        return;
      }
    } catch (e) {
      showtoast('Error creating task: $e');
      return;
    } finally {
      hideLoader(context); // Hide the loader regardless of success or error
    }
    // Navigator.pop(context);
    // After the try-catch-finally block, navigate to the calendar screen
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const calender_screen()),
    );
  }

  void editTask(BuildContext context, taskByDate task) async {
    try {
      showLoader(context);
      List assignedmembers =
          _filteredUsers.where((element) => element.selected == true).toList();
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
          Navigator.pop(context);
          // Navigator.pushReplacement(
          //   context,
          //   MaterialPageRoute(builder: (context) => const calender_screen()),
          // );
        }
        clearTaskData();
      } else if (response.statusCode == 400) {
        hideLoader(context);
        showtoast(jsonBody['message']);
      } else {
        hideLoader(context);
        showtoast('Failed to update the task');
      }
    } catch (e) {
      hideLoader(context);
      showtoast('Error updating task: $e');
    } finally {
      hideLoader(context); // Hide the loader regardless of success or error
    }
  }

  deleteTask(context, taskByDate task) async {
    showLoader(context);
    final response =
        await NetworkHelper().deleteApi("${ApiUrls().deletetask}/${task.sId}");
    if (response.statusCode == 200) {
      hideLoader(context);
      showtoast('Task deleted successfully');
    } else {
      hideLoader(context);
      showtoast('Failed to delete the task');
    }
    return response;
  }

  void editTaskclick(
    BuildContext context,
    taskByDate task,
  ) {
    showLoader(context);
    clearAssignedUsers();
    clearSelectedTime();

    // Convert UTC scheduledDateTime to local time
    final int milliseconds = int.parse(task.scheduledDateTime ?? "0");
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

    hideLoader(context);
    List<String> ids =
        task.assignedUsers!.map((user) => user.sId.toString()).toList();

    print('Assigned User IDs: $ids');

    // Iterate through the assigned user IDs and update the selected property
    for (final assignedUserId in ids) {
      final userIndex = _filteredUsers
          .indexWhere((user) => user.sId.toString() == assignedUserId);
      if (userIndex != -1) {
        _filteredUsers[userIndex].selected = true;
        print('User with ID $assignedUserId is marked as selected.');
      }
      hideLoader(context);
    }

    taskDescriptioncontroller.text = task.description.toString();
    taskTitlecontroller.text = task.title.toString();
    pricecontroller.text = task.price.toString();
    estimatedTimecontroller.text = task.estimatedTime.toString();
  }

  void viewtasks(BuildContext context, taskByDate taskss) {
    showLoader(context);
    taskDescriptioncontroller.text = taskss.description.toString();
    taskTitlecontroller.text = taskss.title.toString();
    estimatedTimecontroller.text = taskss.estimatedTime.toString();
    pricecontroller.text = taskss.price.toString();
    List assignedmembers =
        _filteredUsers.where((element) => element.selected == true).toList();
    print(assignedmembers.length);
    List<String> ids =
        assignedmembers.map((user) => user.sId.toString()).toList();
    hideLoader(context);
    showtoast("View Your Task");
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => ViewTask(
                tasks: taskss,
              )),
    );
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

  Future<void> getmembers() async {
    print('memberscall');
    try {
      final response = await NetworkHelper().getApi(ApiUrls().getuser);
      logger.d(response.body);
      final pdfContent = await generatePdfContent(this);
      if (pdfContent != null) {
        // Store the PDF content in a variable for later use
      }

      if (response.statusCode == 200) {
        final jsonBody = json.decode(response.body);
        logger.d(jsonBody['data']);

        _users = jsonBody['data']
            .map<userListData>((m) => userListData.fromJson(m))
            .toList();

        // Sync the selected status between _users and _filteredUsers
        for (var user in _users) {
          final filteredUserIndex = _filteredUsers
              .indexWhere((filteredUser) => filteredUser.sId == user.sId);
          if (filteredUserIndex != -1) {
            user.selected = _filteredUsers[filteredUserIndex].selected;
          }
        }

        // Assign _users to _filteredUsers
        _filteredUsers = _users.toList();

        notifyListeners();
      } else {
        // Handle the case when the API response indicates an error
        final errorBody = json.decode(response.body);
        final errorMessage = errorBody['message'];
        print('API Error: $errorMessage');
        // You can display the error message or handle it in any other way you prefer.
      }
    } catch (e) {
      print('An error occurred: $e');
      // Handle other types of exceptions that might occur during the API call.
    }
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

  void changeSelectedUser(int index, bool value) async {
    final userId = filteredUsers[index].sId;

    // Update selection state in the main user list
    final userIndex = _filteredUsers.indexWhere((user) => user.sId == userId);
    if (userIndex != -1) {
      _filteredUsers[userIndex].selected = value;
    }

    // Update selection state in the filtered user list
    final filteredIndex =
        filteredUsers.indexWhere((user) => user.sId == userId);
    if (filteredIndex != -1) {
      filteredUsers[filteredIndex].selected = value;
    }

    // Also update the _filteredUsers list
    final _userIndex = _filteredUsers.indexWhere((user) => user.sId == userId);
    if (_userIndex != -1) {
      _filteredUsers[_userIndex].selected = value;
    }

    notifyListeners();
  }

  resetUserSelections() {
    for (var user in _filteredUsers) {
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

  void clearAssignedUsers() {
    _filteredUsers.forEach((user) {
      user.selected = false;
    });
  }

  void clearTaskUserData() {
    clearAssignedUsers();
  }

  void clearTaskData() {
    clearTaskUserData();
    clearTaskNonUserData();
  }

  void clearSelectedTime() {
    selectedTime = TimeOfDay.now();
    timecontroller = '';
    notifyListeners();
  }

  void clearTaskNonUserData() {
    taskTitlecontroller.clear();
    taskDescriptioncontroller.clear();
    estimatedTimecontroller.clear();
    pricecontroller.clear();
    clearSelectedTime();
    changeselectedate(null);
    daycontroller = '';
    timecontroller = '';
  }

  void editTaskConfirmation(BuildContext context, taskByDate task) {
    showDialog(
      barrierColor: Colors.transparent,
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: Color(0xffFFF1E8),
        // contentPadding:
        //     EdgeInsets.zero,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Your confirmation message
            Text(
              'Are You Sure?',
              style: TextStyle(fontSize: 14.sp, color: Colors.grey),
            ),
            SizedBox(height: 20.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                  onTap: () {
                    // Close the AlertDialog
                    Navigator.pop(context);
                  },
                  child: Container(
                    width: 71.w,
                    height: 26.h,
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.black),
                        borderRadius: BorderRadius.circular(10)),
                    child: Center(
                        child: Text(
                      'CANCEL',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 10.sp,
                          color: Colors.black),
                    )),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    editTaskclick(context, task);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditTask(
                          tasks: task,
                        ),
                      ),
                    );
                  },
                  child: Container(
                    width: 71.w,
                    height: 26.h,
                    decoration: BoxDecoration(
                        color: Colors.black,
                        border: Border.all(color: Colors.black),
                        borderRadius: BorderRadius.circular(10)),
                    child: Center(
                        child: Text(
                      'EDIT',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 10.sp,
                          color: Colors.white),
                    )),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void deleteTaskConfirmation(BuildContext context, taskByDate task) {
    showDialog(
      barrierColor: Colors.transparent,
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: Color(0xffFFF1E8),
        // contentPadding:
        //     EdgeInsets.zero,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Your confirmation message
            Text(
              'Are You Sure?',
              style: TextStyle(fontSize: 14.sp, color: Colors.grey),
            ),
            SizedBox(height: 20.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                  onTap: () {
                    // Close the AlertDialog
                    Navigator.pop(context);
                  },
                  child: Container(
                    width: 71.w,
                    height: 26.h,
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.black),
                        borderRadius: BorderRadius.circular(10)),
                    child: Center(
                        child: Text(
                      'CANCEL',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 10.sp,
                          color: Colors.black),
                    )),
                  ),
                ),
                GestureDetector(
                  onTap: () async {
                    Navigator.pop(context); // Close the AlertDialog
                    await deleteTask(
                        context, task); // Wait for task deletion to complete
                    Navigator.pushReplacement(
                      // Navigate back to the calendar screen
                      context,
                      MaterialPageRoute(
                          builder: (context) => calender_screen()),
                    );
                  },
                  child: Container(
                    width: 71.w,
                    height: 26.h,
                    decoration: BoxDecoration(
                        color: Colors.black,
                        border: Border.all(color: Colors.black),
                        borderRadius: BorderRadius.circular(10)),
                    child: Center(
                        child: Text(
                      'DELETE',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 10.sp,
                          color: Colors.white),
                    )),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

int combineDateAndTime(String? date, String? time) {
  if (date == null || time == null) {
    return 0;
  }

  time = time.replaceAll('\u202F', ' ');

  DateTime parsedDate = DateTime.parse(date);
  DateTime parsedTime = DateFormat("h:mm a").parse(time.toString());
  print(parsedTime);

  try {
    DateTime combinedDateTime = DateTime(
      parsedDate.year,
      parsedDate.month,
      parsedDate.day,
      parsedTime.hour,
      parsedTime.minute,
    );

    // Convert to UTC before getting milliseconds since epoch
    int millisecondsSinceEpoch =
        combinedDateTime.toUtc().millisecondsSinceEpoch;

    return millisecondsSinceEpoch;
  } catch (e) {
    // Handle the exception, e.g., show an error message
    print("Error parsing time: $e");
    return 0; // Return a value that indicates an error
  }
}

Future<Uint8List?> generatePdfContent(TaskViewModel taskcontroller) async {
  final pdf = pdfWidgets.Document();

  final headingStyle = pdfWidgets.TextStyle(
    fontSize: 20,
    fontWeight: pdfWidgets.FontWeight.bold,
  );

  final dataStyle = pdfWidgets.TextStyle(
    fontSize: 20,
    fontWeight: pdfWidgets.FontWeight.normal,
  );

  pdf.addPage(
    pdfWidgets.Page(
      build: (context) {
        return pdfWidgets.Column(
          crossAxisAlignment: pdfWidgets.CrossAxisAlignment.start,
          children: [
            pdfWidgets.Row(
              mainAxisAlignment: pdfWidgets.MainAxisAlignment.center,
              children: [
                pdfWidgets.Text(
                  'Task Report',
                  style: pdfWidgets.TextStyle(
                    fontSize: 24,
                    fontWeight: pdfWidgets.FontWeight.bold,
                  ),
                ),
              ],
            ),
            pdfWidgets.Text(
              'Task Title:',
              style: headingStyle, // Use heading style
            ),
            pdfWidgets.Text(
              taskcontroller.taskTitlecontroller.text,
              style: dataStyle, // Use data style
            ),
            pdfWidgets.Padding(padding: pdfWidgets.EdgeInsets.only(top: 20)),
            pdfWidgets.Text(
              'Description:',
              style: headingStyle, // Use heading style
            ),
            pdfWidgets.Text(
              taskcontroller.taskDescriptioncontroller.text,
              style: dataStyle, // Use data style
            ),
            pdfWidgets.Padding(padding: pdfWidgets.EdgeInsets.only(top: 20)),
            pdfWidgets.Text(
              'Estimated Time:',
              style: headingStyle, // Use heading style
            ),
            pdfWidgets.Text(
              taskcontroller.estimatedTimecontroller.text,
              style: dataStyle, // Use data style
            ),
            pdfWidgets.Padding(padding: pdfWidgets.EdgeInsets.only(top: 20)),
            pdfWidgets.Text(
              'Price:',
              style: headingStyle, // Use heading style
            ),
            pdfWidgets.Text(
              taskcontroller.pricecontroller.text,
              style: dataStyle, // Use data style
            ),
            pdfWidgets.Padding(padding: pdfWidgets.EdgeInsets.only(top: 20)),
            pdfWidgets.Text(
              'Assigned To:',
              style: headingStyle, // Use heading style
            ),
            pdfWidgets.Padding(padding: pdfWidgets.EdgeInsets.only(top: 10)),
            pdfWidgets.Column(
              crossAxisAlignment: pdfWidgets.CrossAxisAlignment.start,
              children: taskcontroller._filteredUsers.map((user) {
                return pdfWidgets.Text(
                  user.name.toString(),
                  style: dataStyle,
                );
              }).toList(),
            ),
          ],
        );
      },
    ),
  );

  return pdf.save();
}
