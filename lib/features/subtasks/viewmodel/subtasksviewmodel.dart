import 'package:erick/features/onboarding/model/user.dart';
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
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:flutter/foundation.dart';
import 'package:pdf/widgets.dart' as pdfWidgets;

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
          _filteredUsers.where((element) => element.selected == true).toList();
      List<String> ids =
          assignedmembers.map((user) => user.sId.toString()).toList();
      // After populating assignedmembers
      for (final user in _users) {
        user.selected = assignedmembers.contains(user);
      }
      String date = daycontroller;
      String time = timecontroller;
      int combinedDateTimeMillis = combineDateAndTime(date, time);

      DateTime combinedDateTimeUtc = DateTime.fromMillisecondsSinceEpoch(
          combinedDateTimeMillis,
          isUtc: true);
      if (combinedDateTimeMillis == 0) {
        showtoast('Please select a date and time');
        hideLoader(context);
        return; // Do not proceed
      }
      //final formattedDateTime = combineTimeWithCurrentDay(timecontroller);
      final formattedDateTime =
          DateFormat("yyyy-MM-ddTHH:mm:ss'Z'").format(combinedDateTimeUtc);
      final response = await NetworkHelper().postApi(ApiUrls().createsubtask, {
        "subTaskTitle": subtaskTitlecontroller.text,
        "subTaskDescription": subtaskDescriptioncontroller.text,
        "task": taskid,
        "estimatedTime": estimatedTimecontroller.text,
        "price": pricecontroller.text,
        "scheduledDateTime": formattedDateTime,
        "assignedUsers": ids,
      });

      clearSubTaskData();
      logger.d(response.body);
      final body = response.body;
      final jsonBody = json.decode(body);
      if (response.statusCode == 200) {
        showtoast("SubTask Created Successfully");
        hideLoader(context);
        // Navigate back to the calendar screen and handle the return using .then
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const calender_screen()),
        ).then((_) {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const calender_screen()));
        });
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
          _filteredUsers.where((element) => element.selected == true).toList();
      List<String> ids =
          assignedmembers.map((user) => user.sId.toString()).toList();
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
        formattedDateTimeStr = taskid.scheduledDateTime;
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
          "assignedUsers": ids,
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
        clearSubTaskData();
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
    //showLoader(context);
    final response = await NetworkHelper()
        .deleteApi("${ApiUrls().deletesubtasks}/${taskid.sId}");
    print(taskid.sId);
    if (response.statusCode == 200) {
      hideLoader(context);
      showtoast('Task deleted successfully');
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
    List<String> assignedUserIds = subtask.assignedUsers!; // List of user IDs

    print('Assigned User IDs: $assignedUserIds');

// Iterate through the assigned user IDs and update the selected property
    for (final assignedUserId in assignedUserIds) {
      final userIndex =
          _filteredUsers.indexWhere((user) => user.sId == assignedUserId);
      if (userIndex != -1) {
        _filteredUsers[userIndex].selected = true;
        print('User with ID $assignedUserId is marked as selected. 111');
      }
    }
    hideLoader(context);

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
  }

  void viewsubtasks(BuildContext context, SubTasks subtask) async {
    showLoader(context);

    try {
      subtaskDescriptioncontroller.text = subtask.subTaskDescription.toString();
      subtaskTitlecontroller.text = subtask.subTaskTitle.toString();
      estimatedTimecontroller.text = subtask.estimatedTime.toString();
      pricecontroller.text = subtask.price.toString();

      List assignedmembers =
          _filteredUsers.where((element) => element.selected == true).toList();
      List<String> ids =
          assignedmembers.map((user) => user.sId.toString()).toList();

      // Generate the PDF content
      Uint8List? pdfContent = await generatePdfContent(this);

      // Check if PDF generation was successful
      if (pdfContent != null) {
        // Show a success toast
        showtoast("View Your Task");

        // Hide the loader
        hideLoader(context);

        // Navigate to the ViewSubTasks screen, passing the PDF content
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ViewSubTasks(
              subtasks: subtask,
              //pdfContent: pdfContent, // Pass the PDF content here
            ),
          ),
        );
      } else {
        // Handle PDF generation failure
        hideLoader(context);
        showtoast("Failed to generate PDF");
      }
    } catch (e) {
      // Handle any errors that might occur during PDF generation
      hideLoader(context);
      showtoast("Error: $e");
    }
  }

  Future<void> getmembers() async {
    print('memberscall');
    try {
      final response = await NetworkHelper().getApi(ApiUrls().getuser);
      logger.d(response.body);
// Generate PDF after loading user data
      final pdfContent = await generatePdfContent(this);
      if (pdfContent != null) {
        // Store the PDF content in a variable for later use
      }

      if (response.statusCode == 200) {
        final jsonBody = json.decode(response.body);
        logger.d(jsonBody['data']);

        _filteredUsers = jsonBody['data']
            .map<userListData>((m) => userListData.fromJson(m))
            .toList();
        _filteredUsers = _filteredUsers.toList();
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

    // Also update the _filteredUsers list
    final _userIndex = _filteredUsers.indexWhere((user) => user.sId == userId);
    if (_userIndex != -1) {
      _filteredUsers[_userIndex].selected = value;
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

  void clearAssignedUsers() {
    _filteredUsers.forEach((user) {
      user.selected = false;
    });
  }

  void clearSubTaskUserData() {
    clearAssignedUsers();
  }

  void clearSubTaskData() {
    clearSubTaskUserData();
    clearSubTaskNonUserData();
  }

  void clearSelectedTime() {
    selectedTime = TimeOfDay.now();
    timecontroller = '';
    notifyListeners();
  }

  void clearSubTaskNonUserData() {
    subtaskTitlecontroller.clear();
    subtaskDescriptioncontroller.clear();
    estimatedTimecontroller.clear();
    pricecontroller.clear();
    clearSelectedTime();
  }

  void editSubTaskConfirmation(BuildContext context, SubTasks subtask) {
    showDialog(
      barrierColor: Colors.transparent,
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: Color(0xffFFF1E8),
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
                    editSubTaskclicks(context, subtask);
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => editSubAssignTask(
                          id: subtask,
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

  void deleteSubTaskConfirmation(BuildContext context, SubTasks taskid) {
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
                    await deleteSubTask(
                        context, taskid); // Wait for task deletion to complete
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
  if (date == null || time == null || time.isEmpty) {
    return 0; // Return a value that indicates no time is selected
  }

  time = time.replaceAll('\u202F', ' ');

  DateTime currentDate = DateTime.now();
  DateFormat timeFormat = DateFormat("h:mm a");

  try {
    DateTime parsedTime = timeFormat.parse(time);
    DateTime combinedDateTime = DateTime(
      currentDate.year,
      currentDate.month,
      currentDate.day,
      parsedTime.hour,
      parsedTime.minute,
    );
    int millisecondsSinceEpoch =
        combinedDateTime.toUtc().millisecondsSinceEpoch;
    return millisecondsSinceEpoch;
  } catch (e) {
    // Handle the exception, e.g., show an error message
    print("Error parsing time: $e");
    return 0; // Return a value that indicates an error
  }
}

Future<Uint8List?> generatePdfContent(
  SubTaskViewModel subtaskcontroller,
) async {
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
                  'Sub Task Report',
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
              subtaskcontroller.subtaskTitlecontroller.text,
              style: dataStyle, // Use data style
            ),
            pdfWidgets.Padding(padding: pdfWidgets.EdgeInsets.only(top: 20)),
            pdfWidgets.Text(
              'Description:',
              style: headingStyle, // Use heading style
            ),
            pdfWidgets.Text(
              subtaskcontroller.subtaskDescriptioncontroller.text,
              style: dataStyle, // Use data style
            ),
            pdfWidgets.Padding(padding: pdfWidgets.EdgeInsets.only(top: 20)),
            pdfWidgets.Text(
              'Estimated Time:',
              style: headingStyle, // Use heading style
            ),
            pdfWidgets.Text(
              subtaskcontroller.estimatedTimecontroller.text,
              style: dataStyle, // Use data style
            ),
            pdfWidgets.Padding(padding: pdfWidgets.EdgeInsets.only(top: 20)),
            pdfWidgets.Text(
              'Price:',
              style: headingStyle, // Use heading style
            ),
            pdfWidgets.Text(
              subtaskcontroller.pricecontroller.text,
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
              // children: subtaskcontroller
              //     .filteredUsers // Use the filteredUsers list
              //     .where((user) => user.selected) // Check for selected users
              //     .map((user) {
              children: subtaskcontroller.filteredUsers.map((user) {
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
