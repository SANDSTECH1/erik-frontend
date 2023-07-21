import 'package:erick/features/tasks/viewmodel/tasksviewmodel.dart';
import 'package:erick/widgets/subtask.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

class AssignTask extends StatefulWidget {
  const AssignTask({super.key});

  @override
  State<AssignTask> createState() => _AssignTaskState();
}

class _AssignTaskState extends State<AssignTask> {
  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<TaskViewModel>(context);

    // controller.getmembers();
    DateTime _selectedDay = DateTime.now(); // Initially set to the current date
    DateTime _focusedDay = DateTime.now();
    DateTime _selectedDate = DateTime.now();
    // Initially set to the current date

    CalendarFormat calendarFormat = CalendarFormat.month;
    DateTime focusedDay = DateTime.now();
    DateTime? selectedDay;
    final todayDate = DateTime.now();
    final kFirstDay = DateTime(
        DateTime.now().year, DateTime.now().month - 3, DateTime.now().day);
    final kLastDay = DateTime(
        DateTime.now().year, DateTime.now().month + 3, DateTime.now().day);

    TimeOfDay _selectedTime = TimeOfDay.now();

    void _showTimePicker() async {
      final pickedTime = await showTimePicker(
        context: context,
        initialTime: _selectedTime,
      );
      print("33 ${_selectedTime}");

      if (pickedTime != null) {
        print("334 ${_selectedTime}");

        setState(() {
          _selectedTime = pickedTime;
          controller.timecontroller = _selectedTime.format(context);
        });
      }
    }
    //    @override
    // void initState() {
    //   super.initState();
    //   // Set the initial value of the day controller
    //   final _selectedDay dateFormatter = _selectedDay('yyyy-MM-dd');
    //   controller.daycontroller.text = dateFormatter.format(_selectedDay);
    // }

    return Material(
      child: SizedBox(
        width: 725.w,
        child: SingleChildScrollView(
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
                        "Assign Task",
                        style: TextStyle(color: Colors.white, fontSize: 17.sp),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
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
                                height: 750.h,
                                width: 198.w,
                                child: ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: controller.usersdata.length,
                                    itemBuilder: (context, index) {
                                      return GestureDetector(
                                        onTap: () {
                                          controller.changeSelectedUser(
                                              index,
                                              !controller
                                                  .usersdata[index].selected);
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
                                                  controller
                                                      .usersdata[index].name
                                                      .toString(),
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      color: const Color(
                                                          0xff163300),
                                                      fontSize: 16.sp),
                                                ),
                                              ],
                                            ),
                                            controller.usersdata[index].selected
                                                ? Icon(
                                                    Icons.check_box,
                                                    color: Color(0xff163300),
                                                  )
                                                : SizedBox()
                                          ],
                                        ),
                                      );
                                    }),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    Column(
                      children: [
                        Container(
                          color: const Color(0xffFFF7F0),
                          width: 470.w,
                          height: 478.h,
                          child: TableCalendar(
                            firstDay: kFirstDay,
                            lastDay: kLastDay,
                            focusedDay: focusedDay,
                            weekNumbersVisible: false,
                            headerStyle: HeaderStyle(
                                leftChevronIcon: const Icon(
                                  Icons.arrow_back_ios,
                                  color: Colors.green,
                                ),
                                rightChevronIcon: const Icon(
                                  Icons.arrow_forward_ios,
                                  color: Colors.green,
                                ),
                                // decoration: BoxDecoration(color: Colors.red),
                                titleTextStyle: TextStyle(
                                    color: Colors.black,
                                    fontSize: 20.sp,
                                    fontWeight: FontWeight.bold),
                                titleCentered: true,
                                formatButtonVisible: false),
                            calendarStyle: CalendarStyle(
                              isTodayHighlighted: true,
                              selectedDecoration: const BoxDecoration(
                                color: Colors.grey,
                              ),

                              disabledTextStyle: TextStyle(
                                  color: Colors.black, fontSize: 12.sp),
                              disabledDecoration: const BoxDecoration(
                                color: Color(0xffFFDBC2),
                              ),
                              tablePadding:
                                  EdgeInsets.only(left: 40.w, right: 40.w),
                              // cellPadding: const EdgeInsets.all(30),
                              outsideTextStyle: TextStyle(
                                  color: Colors.black, fontSize: 12.sp),

                              outsideDecoration: const BoxDecoration(
                                color: Color(0xffFFDBC2),
                              ),
                              weekendTextStyle: TextStyle(
                                  color: Colors.black, fontSize: 12.sp),
                              weekendDecoration: const BoxDecoration(
                                color: Color(0xffFFDBC2),
                                // color: Colors.red,
                              ),
                              holidayTextStyle: TextStyle(
                                  color: Colors.black, fontSize: 12.sp),
                              holidayDecoration: const BoxDecoration(
                                color: Color(0xffFFDBC2),
                                // color: Colors.red,
                              ),
                              todayTextStyle: TextStyle(
                                  color: Colors.black, fontSize: 12.sp),
                              todayDecoration: const BoxDecoration(
                                color: Color(0xffFFDBC2),
                              ),
                              selectedTextStyle: TextStyle(
                                  color: Colors.black, fontSize: 12.sp),
                              // selectedDecoration: const BoxDecoration(
                              //   color: Colors.grey,
                              // ),
                              defaultTextStyle: TextStyle(
                                  color: Colors.black, fontSize: 12.sp),
                              defaultDecoration: const BoxDecoration(
                                color: Color(0xffFFDBC2),
                              ),
                            ),
                            selectedDayPredicate: (day) {
                              // Use `selectedDayPredicate` to determine which day is currently selected.
                              // If this returns true, then `day` will be marked as selected.

                              // Using `isSameDay` is recommended to disregard
                              // the time-part of compared DateTime objects.
                              'Selected Date: ${_selectedDay.toString()}';
                              return isSameDay(selectedDay, day);
                            },
                            onDaySelected: (selectedDay, focusedDay) {
                              print("selectedDayyy ${selectedDay}");
                              controller.daycontroller = selectedDay.toString();

                              print('Selected Date: ${selectedDay.toString()}');
                              print(
                                  'Selected Date2: ${controller.daycontroller.toString()}');
                              // if (!isSameDay(selectedDay, selectedDay)) {
                              //   //Call `setState()` when updating the selected day
                              //   setState(() {
                              //     selectedDay = selectedDay;
                              //     focusedDay = focusedDay;

                              //     controller.daycontroller =
                              //         _selectedDay.toString();

                              //     'Selected Date: ${_selectedDay.toString()}';
                              //     'Selected Date2: ${controller.daycontroller.toString()}';
                              //   });
                              // }
                            },
                            onFormatChanged: (format) {
                              if (calendarFormat != format) {
                                //Call `setState()` when updating calendar format
                                setState(() {
                                  calendarFormat = format;
                                  'Selected Date: ${_selectedDay.toString()}';
                                });
                              }
                            },
                            onPageChanged: (focusedDay) {
                              // No need to call `setState()` here
                              focusedDay = focusedDay;
                              'Selected Date: ${_selectedDay.toString()}';
                            },
                          ),
                        ),
                        SizedBox(
                          width: 400.w,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  GestureDetector(
                                    onTap:
                                        _showTimePicker, // Show time picker when tapped
                                    child: Row(
                                      children: [
                                        const Icon(
                                            Icons.access_time_filled_sharp),
                                        const SizedBox(width: 8),
                                        const Text(
                                          'Time',
                                          style: TextStyle(
                                              color: Color(0xff163300)),
                                        ),
                                        const Icon(Icons.arrow_drop_down),
                                      ],
                                    ),
                                  ),
                                  Text(
                                    _selectedTime.format(context),
                                    style: TextStyle(color: Color(0xff163300)),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
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
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 15.sp),
                                      decoration: InputDecoration(
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                                vertical: 0.0, horizontal: 10),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(4.r)),
                                          borderSide: const BorderSide(
                                              width: 1, color: Colors.grey),
                                        ),
                                        disabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(4.r)),
                                          borderSide: const BorderSide(
                                              width: 1, color: Colors.grey),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(4.r)),
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
                              Row(
                                children: [
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
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 15.sp),
                                      decoration: InputDecoration(
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                                vertical: 0.0, horizontal: 10),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(4.r)),
                                          borderSide: const BorderSide(
                                              width: 1, color: Colors.grey),
                                        ),
                                        disabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(4.r)),
                                          borderSide: const BorderSide(
                                              width: 1, color: Colors.grey),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(4.r)),
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
                            ],
                          ),
                        ),
                        23.verticalSpace,
                        SizedBox(
                          width: 400.w,
                          child: TextField(
                            //enabled: false,
                            controller: controller
                                .taskTitlecontroller, // to trigger disabledBorder
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
                            controller: controller.taskDescriptioncontroller,
                            keyboardType: TextInputType.multiline,
                            minLines:
                                5, //Normal textInputField will be displayed
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
                              GestureDetector(
                                onTap: () {
                                  Navigator.pop(context);

                                  showDialog(
                                      context: context,
                                      builder: (_) => AlertDialog(
                                            contentPadding: EdgeInsets.zero,
                                            shape: const RoundedRectangleBorder(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(10.0))),
                                            content: Builder(
                                              builder: (context) {
                                                return const SubAssignTask();
                                              },
                                            ),
                                          ));
                                },
                                child: Container(
                                  width: 100.w,
                                  decoration: BoxDecoration(
                                      color: const Color(0xff9FE870),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(4.r))),
                                  child: Padding(
                                    padding: EdgeInsets.all(9.w),
                                    child: Center(
                                      child: Text(
                                        'ADD SUBTASK',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 14.sp),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              20.horizontalSpace,
                              GestureDetector(
                                onTap: () {
                                  controller.createTask(context);
                                  //Navigator.pop(context);
                                },
                                child: Container(
                                  width: 100.w,
                                  decoration: BoxDecoration(
                                      color: const Color(0xff9FE870),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(4.r))),
                                  child: Padding(
                                    padding: EdgeInsets.all(9.w),
                                    child: Center(
                                      child: Text(
                                        'ASSIGN',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 14.sp),
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
      ),
    );
  }
}
