import 'package:erick/features/subtasks/viewmodel/subtasksviewmodel.dart';
import 'package:erick/features/tasks/viewmodel/tasksviewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class SubAssignTask extends StatelessWidget {
  final id;
  const SubAssignTask({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    print(id);
    final controller = Provider.of<SubTaskViewModel>(context);
    final taskcontroller = Provider.of<TaskViewModel>(context);
    return Material(
      child: SizedBox(
        width: 725.w,
        child: Column(
          children: [
            Container(
              width: 725.w,
              height: 60.h,
              decoration: const BoxDecoration(color: Color(0xff163300)),
              child: Padding(
                padding: EdgeInsets.only(left: 23.w, right: 23.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Sub Assign Task",
                      style: TextStyle(color: Colors.white, fontSize: 17.sp),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context, true);
                      },
                      child: CircleAvatar(
                        radius: 18.r,
                        backgroundColor: Colors.white,
                        child: Icon(
                          Icons.close,
                          size: 20.w,
                          color: Colors.green,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            SizedBox(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 242.w,
                    child: Expanded(
                      child: Container(
                        decoration: const BoxDecoration(
                          color: Colors.white,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            20.verticalSpace,
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.2),
                                    spreadRadius: 3,
                                    blurRadius: 5,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                              ),
                              width: 198.w,
                              child: TextField(
                                enabled: false,
                                decoration: InputDecoration(
                                  prefixIcon: const Icon(Icons.search),
                                  fillColor: Colors.white,
                                  filled: true,
                                  border: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                      width: 0,
                                      style: BorderStyle.none,
                                    ),
                                    borderRadius: BorderRadius.circular(20.0),
                                  ),
                                  hintText: "Search",
                                  hintStyle: const TextStyle(
                                      fontSize: 16, color: Color(0xFFB3B1B1)),
                                ),
                                obscureText: false,
                              ),
                            ),
                            20.verticalSpace,
                            SizedBox(
                              width: 198.w,
                              child: Align(
                                alignment: Alignment.topLeft,
                                child: Padding(
                                  padding: EdgeInsets.only(left: 10.w),
                                  child: Text(
                                    "Members",
                                    style: TextStyle(
                                        fontSize: 16.sp,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 700.h,
                              width: 198.w,
                              child: ListView.builder(
                                shrinkWrap: true,
                                itemCount: taskcontroller.usersdata.length,
                                itemBuilder: (context, index) {
                                  return GestureDetector(
                                    onTap: () {
                                      // Toggle the user selection
                                      bool isSelected = !taskcontroller
                                          .usersdata[index].selected;
                                      taskcontroller.changeSelectedUser(
                                          index, isSelected);
                                    },
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Image.asset(
                                              'assets/icons/erickpic.png',
                                              width: 36.w,
                                            ),
                                            1.horizontalSpace,
                                            Text(
                                              taskcontroller
                                                  .usersdata[index].name
                                                  .toString(),
                                              style: TextStyle(
                                                fontWeight: FontWeight.w400,
                                                color: taskcontroller
                                                        .usersdata[index]
                                                        .selected
                                                    ? const Color(0xff163300)
                                                    : Colors
                                                        .black, // Change color for unselected users
                                                fontSize: 16.sp,
                                              ),
                                            ),
                                          ],
                                        ),
                                        // Show the checkmark icon based on the selection
                                        taskcontroller.usersdata[index].selected
                                            ? Icon(
                                                Icons.check_box,
                                                color: Color(0xff163300),
                                              )
                                            : SizedBox(),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  20.horizontalSpace,
                  Column(
                    children: [
                      20.verticalSpace,
                      SizedBox(
                        width: 400.w,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                              onTap: () async {
                                final pickedTime = await showTimePicker(
                                  context: context,
                                  initialTime: controller.selectedTime,
                                  builder:
                                      (BuildContext context, Widget? child) {
                                    return Theme(
                                      data: ThemeData(
                                        buttonTheme: ButtonThemeData(
                                          textTheme: ButtonTextTheme.primary,
                                        ),
                                        colorScheme: ColorScheme.fromSwatch(
                                                primarySwatch: Colors.green)
                                            .copyWith(secondary: Colors.green),
                                      ),
                                      child: child!,
                                    );
                                  },
                                );

                                if (pickedTime != null) {
                                  // Call the SubTaskViewModel method to set the selected time
                                  controller.changeTime(pickedTime, context);
                                }
                              },
                              child: const Row(
                                children: [
                                  Icon(Icons.access_time_filled_sharp),
                                  // SizedBox(width: 8),
                                  Text(
                                    'Time',
                                    style: TextStyle(color: Color(0xff163300)),
                                  ),
                                  Icon(Icons.arrow_drop_down),
                                ],
                              ),
                            ),
                            Text(
                              controller.selectedTime.format(context),
                              style: const TextStyle(color: Color(0xff163300)),
                            ),
                            const Icon(Icons.access_time_filled_sharp),
                            2.horizontalSpace,
                            const Text(
                              'Estimated Time :  ',
                              style: TextStyle(color: Color(0xff163300)),
                            ),
                            SizedBox(
                              width: 50.w,
                              height: 30.h,
                              child: TextField(
                                controller: controller.estimatedTimecontroller,
                                style: TextStyle(
                                    color: Colors.black, fontSize: 15.sp),
                                decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.symmetric(
                                      vertical: 0.0, horizontal: 10),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(4.r)),
                                    borderSide: const BorderSide(
                                        width: 1, color: Colors.grey),
                                  ),
                                  disabledBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(4.r)),
                                    borderSide: const BorderSide(
                                        width: 1, color: Colors.grey),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(4.r)),
                                    borderSide: const BorderSide(
                                        width: 1, color: Colors.grey),
                                  ),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(4.r)),
                                      borderSide: const BorderSide(
                                        width: 1,
                                      )),
                                  errorBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(4.r)),
                                      borderSide: const BorderSide(
                                          width: 1, color: Colors.grey)),
                                  focusedErrorBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(4.r)),
                                      borderSide: const BorderSide(
                                          width: 1, color: Colors.grey)),
                                  hintText: "",
                                  hintStyle: const TextStyle(
                                      fontSize: 16, color: Colors.black),
                                ),
                                obscureText: false,
                              ),
                            ),
                            const Icon(Icons.money),
                            2.horizontalSpace,
                            const Text(
                              'Price :  ',
                              style: TextStyle(color: Color(0xff163300)),
                            ),
                            SizedBox(
                              width: 50.w,
                              height: 30.h,
                              child: TextField(
                                controller: controller.pricecontroller,
                                style: TextStyle(
                                    color: Colors.black, fontSize: 15.sp),
                                decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.symmetric(
                                      vertical: 0.0, horizontal: 10),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(4.r)),
                                    borderSide: const BorderSide(
                                        width: 1, color: Colors.grey),
                                  ),
                                  disabledBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(4.r)),
                                    borderSide: const BorderSide(
                                        width: 1, color: Colors.grey),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(4.r)),
                                    borderSide: const BorderSide(
                                        width: 1, color: Colors.grey),
                                  ),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(4.r)),
                                      borderSide: const BorderSide(
                                        width: 1,
                                      )),
                                  errorBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(4.r)),
                                      borderSide: const BorderSide(
                                          width: 1, color: Colors.grey)),
                                  focusedErrorBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(4.r)),
                                      borderSide: const BorderSide(
                                          width: 1, color: Colors.grey)),
                                  hintText: "",
                                  hintStyle: const TextStyle(
                                      fontSize: 16, color: Colors.black),
                                ),
                                obscureText: false,
                              ),
                            ),
                          ],
                        ),
                      ),
                      23.verticalSpace,
                      SizedBox(
                        width: 400.w,
                        child: TextField(
                          style: TextStyle(color: Colors.black),
                          controller: controller.subtaskTitlecontroller,
                          //enabled: false, // to trigger disabledBorder
                          decoration: InputDecoration(
                            focusedBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.r)),
                              borderSide: const BorderSide(
                                  width: 1, color: Colors.grey),
                            ),
                            disabledBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.r)),
                              borderSide: const BorderSide(
                                  width: 1, color: Colors.grey),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.r)),
                              borderSide: const BorderSide(
                                  width: 1, color: Colors.grey),
                            ),
                            border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10.r)),
                                borderSide: const BorderSide(
                                  width: 1,
                                )),
                            errorBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10.r)),
                                borderSide: const BorderSide(
                                    width: 1, color: Colors.grey)),
                            focusedErrorBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10.r)),
                                borderSide: const BorderSide(
                                    width: 1, color: Colors.grey)),
                            hintText: "Task Title",
                            hintStyle: const TextStyle(
                                fontSize: 16, color: Color(0xFFB3B1B1)),
                          ),
                          obscureText: false,
                        ),
                      ),
                      23.verticalSpace,
                      SizedBox(
                        width: 400.w,
                        child: TextField(
                          style: TextStyle(color: Colors.black),
                          controller: controller.subtaskDescriptioncontroller,
                          keyboardType: TextInputType.multiline,
                          minLines: 5, //Normal textInputField will be displayed
                          maxLines:
                              10, // when user presses enter it will adapt to it
                          //enabled: false, // to trigger disabledBorder
                          decoration: InputDecoration(
                            focusedBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.r)),
                              borderSide: const BorderSide(
                                  width: 1, color: Colors.grey),
                            ),
                            disabledBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.r)),
                              borderSide: const BorderSide(
                                  width: 1, color: Colors.grey),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.r)),
                              borderSide: const BorderSide(
                                  width: 1, color: Colors.grey),
                            ),
                            border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10.r)),
                                borderSide: const BorderSide(
                                  width: 1,
                                )),
                            errorBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10.r)),
                                borderSide: const BorderSide(
                                    width: 1, color: Colors.grey)),
                            focusedErrorBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10.r)),
                                borderSide: const BorderSide(
                                    width: 1, color: Colors.grey)),
                            hintText: "Write your task",
                            hintStyle: const TextStyle(
                                fontSize: 16, color: Color(0xFFB3B1B1)),
                          ),
                          obscureText: false,
                        ),
                      ),
                      23.verticalSpace,
                      SizedBox(
                        width: 400.w,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            // Container(
                            //   width: 100.w,
                            //   decoration: BoxDecoration(
                            //       color: const Color(0xff9FE870),
                            //       borderRadius:
                            //           BorderRadius.all(Radius.circular(4.r))),
                            //   child: Padding(
                            //     padding: EdgeInsets.all(9.w),
                            //     child: Center(
                            //       child: Text(
                            //         'ADD SUBTASK',
                            //         style: TextStyle(
                            //             color: Colors.white, fontSize: 14.sp),
                            //       ),
                            //     ),
                            //   ),
                            // ),
                            // 20.horizontalSpace,
                            GestureDetector(
                              onTap: () {
                                // Show loading indicator
                                // showLoader(context);

                                // // Simulate an asynchronous task, like navigating to the next screen
                                // await Future.delayed(Duration(
                                //     seconds:
                                //         1)); // Replace this with your actual navigation logic

                                // // Hide loading indicator after the asynchronous task is done
                                // hideLoader(context);
                                // // Navigator.pop(context);
                                // //controller.editTask(context, id);

                                controller.createSubTask(context, id);
                              },
                              child: Container(
                                width: 100.w,
                                decoration: BoxDecoration(
                                    color: const Color(0xff9FE870),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(4.r))),
                                child: Padding(
                                  padding: EdgeInsets.all(9.w),
                                  child: Center(
                                    child: Text(
                                      'ASSIGN',
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 14.sp),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
