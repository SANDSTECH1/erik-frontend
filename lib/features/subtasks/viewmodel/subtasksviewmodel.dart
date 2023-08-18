// import 'package:erick/features/subtasks/view/editsubtasks.dart';
// import 'package:erick/features/tasks/model/tasks.dart';
// import 'package:erick/features/tasks/model/usermember.dart';
// import 'package:erick/features/tasks/view/calender_screen.dart';
// import 'package:erick/helper/loader/loader.dart';
// import 'package:erick/helper/network/network.dart';
// import 'package:erick/helper/toast/toast.dart';
// import 'package:erick/features/subtasks/view/viewtask.dart';
// import 'package:flutter/material.dart';
// import 'dart:convert';

// import 'package:intl/intl.dart';

// String userToken = "";

// class SubTaskViewModel with ChangeNotifier {
//   final TextEditingController subtaskTitlecontroller = TextEditingController();
//   final TextEditingController estimatedTimecontroller = TextEditingController();
//   final TextEditingController pricecontroller = TextEditingController();
//   final TextEditingController subtaskDescriptioncontroller =
//       TextEditingController();

//   String timecontroller = '';
//   String daycontroller = DateFormat('yyyy-MM-dd').format(DateTime.now());
//   DateTime selectedDay = DateTime.now();
//   //TimeOfDay selectedTime = TimeOfDay.now();
//   int? subtaskCreatedTimeMillis;
//   TimeOfDay? updatedTime;
//   //DateTime? selectedDate;
//   int? updatedSubtaskId;
//   List<userListData> _users = [];
//   List<userListData> get usersdata => _users;
//   DateTime? _selectedDate;
//   TimeOfDay _selectedTime = TimeOfDay.now();

//   DateTime? get selectedDate => _selectedDate;
//   TimeOfDay get selectedTime => _selectedTime;
//   // Create a new list for selected users

//   //TimeOfDay selectedTime = TimeOfDay.now();
//   Future<void> hideLoader(BuildContext context) async {
//     Navigator.of(context).pop();
//   }

//   void createSubTask(BuildContext context, taskid) async {
//     showLoader(context);

//     if (subtaskTitlecontroller.text.isEmpty ||
//         subtaskDescriptioncontroller.text.isEmpty ||
//         estimatedTimecontroller.text.isEmpty ||
//         pricecontroller.text.isEmpty) {
//       showtoast('Please fill in all required fields');
//       hideLoader(context);
//       return; // Do not proceed
//     }
//     try {
//       List assignedmembers =
//           _users.where((element) => element.selected == true).toList();
//       List<String> ids =
//           assignedmembers.map((user) => user.sId.toString()).toList();

//       // Use the selectedDate and selectedTime properties from the view model
//       final combinedDateTimeMillis =
//           combineDateAndTime(selectedDate!, selectedTime);

//       final response = await NetworkHelper().postApi(ApiUrls().createsubtask, {
//         "subTaskTitle": subtaskTitlecontroller.text,
//         "subTaskDescription": subtaskDescriptioncontroller.text,
//         "task": taskid,
//         "estimatedTime": estimatedTimecontroller.text,
//         "price": pricecontroller.text,
//         "scheduledDateTime": combinedDateTimeMillis,
//       });

//       subtaskDescriptioncontroller.clear();
//       subtaskTitlecontroller.clear();
//       estimatedTimecontroller.clear();
//       pricecontroller.clear();
//       clearAssignedUsers();
//       //clearSelectedTime();
//       //selectedTime = TimeOfDay.now();

//       if (response.statusCode == 200) {
//         hideLoader(context);
//         showtoast("SubTask Created Successfully");
//         Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(builder: (context) => const calender_screen()),
//         );
//         Navigator.pop(context);
//       } else if (response.statusCode == 400) {
//         //showtoast(jsonBody['message']);
//       } else {
//         showtoast("Failed To Create SubTask");
//       }
//     } catch (e) {
//       showtoast("Error creating SubTask: $e");
//     } finally {
//       hideLoader(context);
//     }
//   }

//   void editTask(
//     BuildContext context,
//     SubTasks taskid,
//   ) async {
//     print(taskid.sId);
//     if (subtaskTitlecontroller.text.isEmpty ||
//         subtaskDescriptioncontroller.text.isEmpty ||
//         estimatedTimecontroller.text.isEmpty ||
//         pricecontroller.text.isEmpty) {
//       showtoast('Please fill in all required fields');
//       return; // Do not proceed
//     }
//     try {
//       // // Get the existing scheduled time from the task
//       // String? existingScheduledTime = taskid.scheduledDateTime;

//       // // Get the current date and selected time
//       // String currentDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
//       // String selectedTime = timecontroller;

//       // // Combine the current date and selected time
//       // String formattedDateTime = "$currentDate $selectedTime";

//       // // Convert formatted date-time string to DateTime object
//       // DateTime combinedDateTime =
//       //     DateFormat("yyyy-MM-dd hh:mm a").parse(formattedDateTime);

//       // // Convert DateTime to UTC and get milliseconds since epoch
//       // int combinedDateTimeMillis =
//       //     combinedDateTime.toUtc().millisecondsSinceEpoch;

//       // // Use the existing scheduled time if user doesn't change the time
//       // String? scheduledDateTime = combinedDateTimeMillis != 0
//       //     ? formattedDateTime
//       //     : existingScheduledTime;
//       // Use selectedTime from the SubTaskViewModel
//       // Use the selectedDate and selectedTime properties from the view model
//       final combinedDateTimeMillis =
//           combineDateAndTime(selectedDate!, selectedTime);

//       final response = await NetworkHelper().putApi(
//         "${ApiUrls().updatesubtasks}/${taskid.sId}",
//         {
//           "subTaskTitle": subtaskTitlecontroller.text,
//           "subTaskDescription": subtaskDescriptioncontroller.text,
//           "task": taskid.task,
//           "estimatedTime": estimatedTimecontroller.text,
//           "price": pricecontroller.text,
//           "scheduledDateTime": combinedDateTimeMillis,
//         },
//       );

//       final body = response.body;
//       final jsonBody = json.decode(body);

//       if (response.statusCode == 200) {
//         showtoast("SubTask Updated Successfully");
//         Navigator.push(
//           context,
//           MaterialPageRoute(builder: (context) => calender_screen()),
//         );
//         subtaskDescriptioncontroller.clear();
//         subtaskTitlecontroller.clear();
//         estimatedTimecontroller.clear();
//         pricecontroller.clear();

//         //clearSelectedTime();
//       } else if (response.statusCode == 400) {
//         showtoast(jsonBody['message']);
//       } else {
//         showtoast('Failed to update the task');
//       }
//     } catch (e) {
//       showtoast('Error updating task: $e');
//     }
//   }

//   deleteTask(context, SubTasks taskid) async {
//     final response = await NetworkHelper()
//         .deleteApi("${ApiUrls().deletesubtasks}/${taskid.sId}");
//     print(taskid.sId);
//     if (response.statusCode == 200) {
//       showtoast('Task deleted successfully');
//       Navigator.push(
//         context,
//         MaterialPageRoute(builder: (context) => calender_screen()),
//       );
//     } else {
//       showtoast('Failed to delete the task');
//     }
//     return response;
//   }

//   Future<void> editTaskclicks(BuildContext context, SubTasks subtask) async {
//     subtaskTitlecontroller.text = subtask.subTaskTitle.toString();
//     subtaskDescriptioncontroller.text = subtask.subTaskDescription.toString();
//     pricecontroller.text = subtask.price.toString();
//     estimatedTimecontroller.text = subtask.estimatedTime.toString();

//     if (subtask.scheduledDateTime != null) {
//       final int editMilliseconds = int.parse(subtask.scheduledDateTime!);

//       if (editMilliseconds != 0) {
//         final DateTime utcEditDateTime =
//             DateTime.fromMillisecondsSinceEpoch(editMilliseconds, isUtc: true);
//         final selectedDateTime = utcEditDateTime.toLocal();

//         // Update the selectedTime and selectedDate properties of the specific subtask
//         subtask.selectedTime = TimeOfDay(
//           hour: selectedDateTime.hour,
//           minute: selectedDateTime.minute,
//         );
//         subtask.selectedDate = selectedDateTime;
//       }
//     }

//     showtoast("Edit your Task");
//     bool dataEdited = await Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => editSubAssignTask(
//           id: subtask,
//         ),
//       ),
//     );

//     // Refresh UI after returning from the editSubAssignTask screen
//     if (dataEdited == true) {
//       // Update the UI based on the edited subtask object
//       subtaskDescriptioncontroller.text = subtask.subTaskDescription.toString();
//       subtaskTitlecontroller.text = subtask.subTaskTitle.toString();
//       estimatedTimecontroller.text = subtask.estimatedTime.toString();
//       pricecontroller.text = subtask.price.toString();
//     }
//   }

//   void viewtasks(BuildContext context, SubTasks subtask) {
//     subtaskDescriptioncontroller.text = subtask.subTaskDescription.toString();
//     subtaskTitlecontroller.text = subtask.subTaskTitle.toString();
//     estimatedTimecontroller.text = subtask.estimatedTime.toString();
//     pricecontroller.text = subtask.price.toString();
//     List assignedmembers =
//         _users.where((element) => element.selected == true).toList();
//     print(assignedmembers.length);
//     List<String> ids =
//         assignedmembers.map((user) => user.sId.toString()).toList();
//     showtoast("View Your Task");
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//           builder: (context) => ViewSubTasks(
//                 subtasks: subtask,
//               )),
//     );
//   }

// // Define a method to combine a DateTime and TimeOfDay into milliseconds
//   int combineDateAndTime(DateTime date, TimeOfDay time) {
//     final dateTime =
//         DateTime(date.year, date.month, date.day, time.hour, time.minute);
//     return dateTime.millisecondsSinceEpoch;
//   }

//   void setSelectedDate(DateTime? date) {
//     _selectedDate = date;
//     notifyListeners();
//   }

//   void setSelectedTime(TimeOfDay time) {
//     _selectedTime = time;
//     notifyListeners();
//   }

//   void setUpdatedTime(TimeOfDay updatedTime, int subtaskId) {
//     this.updatedTime = updatedTime;
//     this.updatedSubtaskId =
//         subtaskId; // Add this property to track the subtask ID
//     notifyListeners();
//   }

//   changeselectedate(s) {
//     if (s == null) {
//       //selectedDay = null;
//       daycontroller = '';
//     } else {
//       selectedDay = s;
//       daycontroller = s.toString();
//     }
//     notifyListeners();
//   }

//   changeSelectedUser(int, value) {
//     _users[int].selected = value;
//     notifyListeners();
//   }

//   // void changeTime(TimeOfDay? pickedTime, BuildContext context) {
//   //   if (pickedTime == null) {
//   //     selectedTime = TimeOfDay.now();
//   //     timecontroller = '';
//   //   } else {
//   //     selectedTime = pickedTime;
//   //     timecontroller = selectedTime.format(context);
//   //   }
//   //   notifyListeners();
//   // }

//   // int combineDateAndTime(String? date, String? time) {
//   //   if (date == null || time == null) {
//   //     throw ArgumentError("Date and time must not be null.");
//   //   }

//   //   DateTime parsedDate = DateTime.parse(date);
//   //   DateTime parsedTime = DateFormat("h:mm a").parse(time);

//   //   DateTime combinedDateTime = DateTime(
//   //     parsedDate.year,
//   //     parsedDate.month,
//   //     parsedDate.day,
//   //     parsedTime.hour,
//   //     parsedTime.minute,
//   //   );

//   //   int millisecondsSinceEpoch =
//   //       combinedDateTime.toUtc().millisecondsSinceEpoch;
//   //   return millisecondsSinceEpoch;
//   // }

//   void clearAssignedUsers() {
//     _users.forEach((user) {
//       user.selected = false;
//     });
//   }

//   void clearSelectedTime() {
//     _selectedTime = TimeOfDay.now();
//     timecontroller = '';
//     notifyListeners();
//   }
// }
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
  DateTime selectedDay = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();
  int? subtaskCreatedTimeMillis;
  TimeOfDay? updatedTime;
  List<userListData> _users = [];
  List<userListData> get usersdata => _users;
  // Create a new list for selected users

  //TimeOfDay selectedTime = TimeOfDay.now();
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
      int combinedDateTimeMillis =
          combineDateAndTime(selectedDay.toString(), timecontroller);

      subtaskCreatedTimeMillis = combinedDateTimeMillis;

      final response = await NetworkHelper().postApi(ApiUrls().createsubtask, {
        "subTaskTitle": subtaskTitlecontroller.text,
        "subTaskDescription": subtaskDescriptioncontroller.text,
        "task": taskid,
        "estimatedTime": estimatedTimecontroller.text,
        "price": pricecontroller.text,
        "scheduledDateTime": DateFormat("yyyy-MM-dd HH:mm:ss").format(
            DateTime.fromMillisecondsSinceEpoch(combinedDateTimeMillis)),
      });

      subtaskDescriptioncontroller.clear();
      subtaskTitlecontroller.clear();
      estimatedTimecontroller.clear();
      pricecontroller.clear();
      clearAssignedUsers();
      clearSelectedTime();
      selectedTime = TimeOfDay.now();

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
      }
    } catch (e) {
      showtoast("Error creating SubTask: $e");
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
      // Get the existing scheduled time from the task
      String? existingScheduledTime = taskid.scheduledDateTime;

      // Get the current date and selected time
      String currentDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
      String selectedTime = timecontroller;

      // Combine the current date and selected time
      String formattedDateTime = "$currentDate $selectedTime";

      // Convert formatted date-time string to DateTime object
      DateTime combinedDateTime =
          DateFormat("yyyy-MM-dd hh:mm a").parse(formattedDateTime);

      // Convert DateTime to UTC and get milliseconds since epoch
      int combinedDateTimeMillis =
          combinedDateTime.toUtc().millisecondsSinceEpoch;

      // Use the existing scheduled time if user doesn't change the time
      String? scheduledDateTime = combinedDateTimeMillis != 0
          ? formattedDateTime
          : existingScheduledTime;

      final response = await NetworkHelper().putApi(
        "${ApiUrls().updatesubtasks}/${taskid.sId}",
        {
          "subTaskTitle": subtaskTitlecontroller.text,
          "subTaskDescription": subtaskDescriptioncontroller.text,
          "task": taskid.task,
          "estimatedTime": estimatedTimecontroller.text,
          "price": pricecontroller.text,
          "scheduledDateTime": scheduledDateTime,
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

  Future<void> editTaskclicks(BuildContext context, SubTasks subtask) async {
    subtaskTitlecontroller.text = subtask.subTaskTitle.toString();
    subtaskDescriptioncontroller.text = subtask.subTaskDescription.toString();
    pricecontroller.text = subtask.price.toString();
    estimatedTimecontroller.text = subtask.estimatedTime.toString();

    final int editMilliseconds = int.parse(subtask.scheduledDateTime ?? "0");

    DateTime? selectedDateTime;

    if (editMilliseconds != 0) {
      final DateTime utcEditDateTime =
          DateTime.fromMillisecondsSinceEpoch(editMilliseconds, isUtc: true);
      final localEditDateTime = utcEditDateTime.toLocal();

      selectedDateTime = localEditDateTime;
    }

    if (subtaskCreatedTimeMillis != null) {
      final int createMilliseconds =
          int.parse(subtaskCreatedTimeMillis.toString());

      if (createMilliseconds != 0) {
        final DateTime createDateTime = DateTime.fromMillisecondsSinceEpoch(
            createMilliseconds,
            isUtc: true);
        selectedDateTime = createDateTime.toLocal();
      }
    }

    if (selectedDateTime != null) {
      // Check if the subtask being edited is the same as the updatedTime's taskid
      if (updatedTime != null && subtask.sId == updatedTime!) {
        // Use the updatedTime for this subtask
        selectedTime = updatedTime!;
        daycontroller = DateFormat('yyyy-MM-dd').format(selectedDateTime);
        selectedDay = selectedDateTime;
      } else {
        if (selectedTime == TimeOfDay.now()) {
          selectedTime = TimeOfDay(
            hour: selectedDateTime.hour,
            minute: selectedDateTime.minute,
          );

          daycontroller = DateFormat('yyyy-MM-dd').format(selectedDateTime);
          selectedDay = selectedDateTime;
        } else {
          // Convert selectedTime to formatted String and assign to daycontroller
          daycontroller = selectedTime.format(context);
        }
      }
    }

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

  void changeTime(TimeOfDay? pickedTime, BuildContext context) {
    if (pickedTime == null) {
      selectedTime = TimeOfDay.now();
      timecontroller = '';
    } else {
      selectedTime = pickedTime;
      timecontroller = selectedTime.format(context);
    }
    notifyListeners();
  }

  int combineDateAndTime(String? date, String? time) {
    if (date == null || time == null) {
      throw ArgumentError("Date and time must not be null.");
    }

    DateTime parsedDate = DateTime.parse(date);
    DateTime parsedTime = DateFormat("h:mm a").parse(time);

    DateTime combinedDateTime = DateTime(
      parsedDate.year,
      parsedDate.month,
      parsedDate.day,
      parsedTime.hour,
      parsedTime.minute,
    );

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
