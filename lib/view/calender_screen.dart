import 'package:erick/view/task_screen.dart';
import 'package:erick/widgets/assigntask.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:intl/intl.dart';

class calender_screen extends StatelessWidget {
  const calender_screen({super.key});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final dateFormat = DateFormat('MMMM');

    final weekdayFormat = DateFormat('EEEE');

    final datesByMonth = [];
    for (var i = 1; i < 13; i++) {
      final lastDayOfMonth = DateTime(now.year, i + 1, 0);
      final firstDayOfMonth = DateTime(now.year, i, 1);
      final dates = [];
      for (var j = 0; j < lastDayOfMonth.day; j++) {
        final date = firstDayOfMonth.add(Duration(days: j));
        final formattedDate = DateFormat('dd').format(date);
        final formattedWeekday = weekdayFormat.format(date);
        // dates.add('$formattedDate ($formattedWeekday)');
        dates.add({'date': formattedDate, 'week': formattedWeekday});
      }
      datesByMonth.add(dates);
    }

    return Scaffold(
        body: Row(
      children: [
        Container(
          width: 199.w,
          decoration: const BoxDecoration(
            color: Color(0xff163300),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              96.verticalSpace,
              Row(
                children: [
                  Container(
                    margin: const EdgeInsets.only(left: 30),
                    child: const Icon(
                      Icons.menu,
                      color: Color(0xff9FE870),
                    ),
                  ),
                  10.horizontalSpace,
                  SizedBox(
                    width: 99.w,
                    child: Text(
                      "ASSIGN TASK",
                      style: TextStyle(
                          color: const Color(0xffFFFFFF), fontSize: 16.sp),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                decoration: const BoxDecoration(color: Color(0xffF6FFFD)),
                child: Padding(
                  padding: EdgeInsets.all(18.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          // Container(
                          //   child: const Icon(Icons.arrow_back),
                          // ),
                          Container(
                            child: const Icon(Icons.calendar_month_outlined),
                          ),
                          5.horizontalSpace,
                          Container(
                            child: Text(
                              "MARCH, 2023",
                              style: TextStyle(
                                  fontSize: 16.sp,
                                  color: const Color(0xff000000),
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        width: 222.w,
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
                              borderRadius: BorderRadius.circular(13.0),
                            ),
                            hintText: "Search",
                            hintStyle: const TextStyle(
                                fontSize: 16, color: Color(0xFFB3B1B1)),
                          ),
                          obscureText: false,
                        ),
                      ),
                      Row(
                        children: [
                          Image.asset(
                            'assets/icons/erickpic.png',
                            width: 36.w,
                          ),
                          3.horizontalSpace,
                          Text(
                            'ERICK',
                            style: TextStyle(
                                fontWeight: FontWeight.w400,
                                color: const Color(0xff163300),
                                fontSize: 14.sp),
                          ),
                          10.horizontalSpace,
                        ],
                      )
                    ],
                  ),
                ),
              ),
              30.verticalSpace,
              Expanded(
                child: Column(
                  children: [
                    SizedBox(
                      height: 70.h,
                      child: GridView.builder(
                        padding: const EdgeInsets.all(0),
                        itemCount: 7,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 7,
                          childAspectRatio: 2,
                        ),
                        itemBuilder: (BuildContext context, int index) {
                          return Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                            ),
                            child: Center(
                              child: Text(
                                datesByMonth[0][index]['week'],
                                style: TextStyle(
                                    color: const Color(0xff000000),
                                    fontSize: 14.sp),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    Expanded(
                      child: Container(
                        child: GridView.builder(
                          padding: const EdgeInsets.all(0),
                          itemCount: datesByMonth[0].length,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 7,
                            childAspectRatio: 1,
                          ),
                          itemBuilder: (BuildContext context, int index) {
                            final dayOfMonth = index + 1;
                            return Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                              ),
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      datesByMonth[0][index]['date'].toString(),
                                      style: TextStyle(
                                          color: const Color(0xff000000),
                                          fontSize: 14.sp),
                                    ),
                                    5.verticalSpace,
                                    datesByMonth[0][index]['date'].toString() ==
                                            "02"
                                        ? GestureDetector(
                                            onTap: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        const TaskScreen()),
                                              );
                                            },
                                            child: Container(
                                              width: 63.w,
                                              decoration: BoxDecoration(
                                                  border: Border.all(
                                                      color: const Color(
                                                          0xff163300))),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Text("See All Task",
                                                        style: TextStyle(
                                                            color: const Color(
                                                                0xff163300),
                                                            fontSize: 12.sp,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold)),
                                                    2.horizontalSpace,
                                                    const Icon(
                                                      Icons.arrow_forward_ios,
                                                      size: 12,
                                                      color: Color(0xff163300),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
                                          )
                                        : GestureDetector(
                                            onTap: () {
                                              showDialog(
                                                  context: context,
                                                  builder: (_) => AlertDialog(
                                                        contentPadding:
                                                            EdgeInsets.zero,
                                                        shape: const RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius.all(
                                                                    Radius.circular(
                                                                        10.0))),
                                                        content: Builder(
                                                          builder: (context) {
                                                            return const AssignTask();
                                                          },
                                                        ),
                                                      ));
                                              // showDialog(
                                              //     context: context,
                                              //     builder: (BuildContext context) {
                                              //       return const AssignTask();
                                              //     });
                                            },
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                const Icon(
                                                  Icons.add_circle,
                                                  color: Color(0xff163300),
                                                ),
                                                4.horizontalSpace,
                                                Text(
                                                  'Assign Task',
                                                  style: TextStyle(
                                                      color: const Color(
                                                          0xff163300),
                                                      fontSize: 14.sp),
                                                )
                                              ],
                                            ),
                                          )
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    ));
  }

  List<Meeting> _getDataSource() {
    final List<Meeting> meetings = <Meeting>[];
    final DateTime today = DateTime.now();
    final DateTime startTime =
        DateTime(today.year, today.month, today.day, 9, 0, 0);
    final DateTime endTime = startTime.add(const Duration(hours: 2));
    meetings.add(Meeting(
        'Conference', startTime, endTime, const Color(0xFF0F8644), false));
    return meetings;
  }
}

class MeetingDataSource extends CalendarDataSource {
  MeetingDataSource(List<Meeting> source) {
    appointments = source;
  }

  @override
  DateTime getStartTime(int index) {
    return appointments![index].from;
  }

  @override
  DateTime getEndTime(int index) {
    return appointments![index].to;
  }

  @override
  String getSubject(int index) {
    return appointments![index].eventName;
  }

  @override
  Color getColor(int index) {
    return appointments![index].background;
  }

  @override
  bool isAllDay(int index) {
    return appointments![index].isAllDay;
  }
}

class Meeting {
  Meeting(this.eventName, this.from, this.to, this.background, this.isAllDay);

  String eventName;
  DateTime from;
  DateTime to;
  Color background;
  bool isAllDay;
}
