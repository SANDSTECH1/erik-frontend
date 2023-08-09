import 'package:erick/features/subtasks/viewmodel/subtasksviewmodel.dart';
import 'package:erick/features/tasks/model/tasks.dart';
import 'package:erick/features/tasks/viewmodel/calendarviewmodel.dart';
import 'package:erick/features/tasks/viewmodel/tasksviewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class TaskScreen extends StatelessWidget {
  final List<taskByDate> tasks;
  const TaskScreen({
    super.key,
    required this.tasks,
  });

  @override
  Widget build(BuildContext context) {
    final calendarcontroller = Provider.of<CalendarViewModel>(context);
    final taskcontroller = Provider.of<TaskViewModel>(context);
    final subtaskcontroller = Provider.of<SubTaskViewModel>(context);

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
                          GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Container(
                              child: const Icon(Icons.arrow_back),
                            ),
                          ),
                          5.horizontalSpace,
                          Container(
                            child: const Icon(Icons.calendar_month_outlined),
                          ),
                          5.horizontalSpace,
                          Container(
                            child: Text(
                              '${calendarcontroller.dateFormat.format(DateTime(calendarcontroller.year, calendarcontroller.activeShowMonth + 1))} ${calendarcontroller.year}',
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
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: tasks.length,
                  itemBuilder: (context, index) {
                    //final task = tasks[index];
                    return Expanded(
                      child: Column(
                        children: [
                          SizedBox(
                            width: 775.w,
                            child: Column(
                              children: [
                                Container(
                                  width: 550.w,
                                  height: 39.h,
                                  decoration: const BoxDecoration(
                                      color: Color(0xff163300)),
                                  child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: Padding(
                                        padding: EdgeInsets.only(left: 13.w),
                                        child:
                                            Text(tasks[index].title.toString()),
                                      )),
                                ),
                                Container(
                                  width: 550.w,
                                  color: const Color(0xffF6FFFD),
                                  child: Padding(
                                    padding: EdgeInsets.all(13.w),
                                    child: Column(
                                      children: [
                                        Text(
                                          tasks[index].description.toString(),
                                          style: TextStyle(
                                              color: Colors.grey,
                                              fontSize: 11.sp),
                                        ),
                                        15.verticalSpace,
                                        SizedBox(
                                            width: 550.w,
                                            child: GestureDetector(
                                              onTap: () {
                                                showDialog(
                                                  barrierColor:
                                                      Colors.transparent,
                                                  context: context,
                                                  builder: (_) => AlertDialog(
                                                    backgroundColor:
                                                        Color(0xffFFF1E8),
                                                    // contentPadding:
                                                    //     EdgeInsets.zero,
                                                    shape:
                                                        const RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  10.0)),
                                                    ),
                                                    content: Column(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        // Your confirmation message
                                                        Text(
                                                          'Are You Sure?',
                                                          style: TextStyle(
                                                              fontSize: 14.sp,
                                                              color:
                                                                  Colors.grey),
                                                        ),
                                                        SizedBox(height: 20.0),
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceEvenly,
                                                          children: [
                                                            GestureDetector(
                                                              onTap: () {
                                                                Navigator.pop(
                                                                    context);
                                                              },
                                                              child: Container(
                                                                width: 71.w,
                                                                height: 26.h,
                                                                decoration: BoxDecoration(
                                                                    border: Border.all(
                                                                        color: Colors
                                                                            .black),
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            10)),
                                                                child: Center(
                                                                    child: Text(
                                                                  'CANCEL',
                                                                  style: TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      fontSize:
                                                                          10.sp,
                                                                      color: Colors
                                                                          .black),
                                                                )),
                                                              ),
                                                            ),
                                                            GestureDetector(
                                                              onTap: () {
                                                                Navigator.pop(
                                                                    context);
                                                                taskcontroller
                                                                    .editTaskclick(
                                                                        context,
                                                                        tasks[
                                                                            index]);
                                                              },
                                                              child: Container(
                                                                width: 71.w,
                                                                height: 26.h,
                                                                decoration: BoxDecoration(
                                                                    color: Colors
                                                                        .black,
                                                                    border: Border.all(
                                                                        color: Colors
                                                                            .black),
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            10)),
                                                                child: Center(
                                                                    child: Text(
                                                                  'EDIT',
                                                                  style: TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      fontSize:
                                                                          10.sp,
                                                                      color: Colors
                                                                          .white),
                                                                )),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                );
                                              },
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                children: [
                                                  Row(
                                                    children: [
                                                      const Icon(Icons.edit),
                                                      2.horizontalSpace,
                                                      Text(
                                                        'EDIT',
                                                        style: TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 16.sp),
                                                      ),
                                                    ],
                                                  ),
                                                  5.horizontalSpace,
                                                  GestureDetector(
                                                    onTap: () {
                                                      taskcontroller.viewtasks(
                                                          context,
                                                          tasks[index]);
                                                    },
                                                    child: Row(
                                                      children: [
                                                        const Icon(
                                                            Icons.visibility),
                                                        2.horizontalSpace,
                                                        Text(
                                                          'VIEW',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.black,
                                                              fontSize: 16.sp),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                  5.horizontalSpace,
                                                  GestureDetector(
                                                    onTap: () {
                                                      showDialog(
                                                        barrierColor:
                                                            Colors.transparent,
                                                        context: context,
                                                        builder: (_) =>
                                                            AlertDialog(
                                                          backgroundColor:
                                                              Color(0xffFFF1E8),
                                                          // contentPadding:
                                                          //     EdgeInsets.zero,
                                                          shape:
                                                              const RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius.all(
                                                                    Radius.circular(
                                                                        10.0)),
                                                          ),
                                                          content: Column(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .min,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              // Your confirmation message
                                                              Text(
                                                                'Are You Sure?',
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        14.sp,
                                                                    color: Colors
                                                                        .grey),
                                                              ),
                                                              SizedBox(
                                                                  height: 20.0),
                                                              Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceEvenly,
                                                                children: [
                                                                  GestureDetector(
                                                                    onTap: () {
                                                                      Navigator.pop(
                                                                          context);
                                                                    },
                                                                    child:
                                                                        Container(
                                                                      width:
                                                                          71.w,
                                                                      height:
                                                                          26.h,
                                                                      decoration: BoxDecoration(
                                                                          border:
                                                                              Border.all(color: Colors.black),
                                                                          borderRadius: BorderRadius.circular(10)),
                                                                      child: Center(
                                                                          child: Text(
                                                                        'CANCEL',
                                                                        style: TextStyle(
                                                                            fontWeight:
                                                                                FontWeight.bold,
                                                                            fontSize: 10.sp,
                                                                            color: Colors.black),
                                                                      )),
                                                                    ),
                                                                  ),
                                                                  GestureDetector(
                                                                    onTap: () {
                                                                      Navigator.pop(
                                                                          context);
                                                                      taskcontroller.deleteTask(
                                                                          context,
                                                                          tasks[
                                                                              index]);
                                                                    },
                                                                    child:
                                                                        Container(
                                                                      width:
                                                                          71.w,
                                                                      height:
                                                                          26.h,
                                                                      decoration: BoxDecoration(
                                                                          color: Colors
                                                                              .black,
                                                                          border:
                                                                              Border.all(color: Colors.black),
                                                                          borderRadius: BorderRadius.circular(10)),
                                                                      child: Center(
                                                                          child: Text(
                                                                        'DELETE',
                                                                        style: TextStyle(
                                                                            fontWeight:
                                                                                FontWeight.bold,
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
                                                    },
                                                    child: Row(
                                                      children: [
                                                        const Icon(
                                                            Icons.delete),
                                                        2.horizontalSpace,
                                                        Text(
                                                          'DELETE',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.black,
                                                              fontSize: 16.sp),
                                                        )
                                                      ],
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ))
                                      ],
                                    ),
                                  ),
                                ),
                                20.verticalSpace,
                                ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: //subtasks.length,
                                        tasks[index].subTasks!.length,
                                    itemBuilder: ((context, i) {
                                      return Column(
                                        children: [
                                          Container(
                                            width: 510.w,
                                            height: 39.h,
                                            decoration: const BoxDecoration(
                                                color: Color(0xff9FE870)),
                                            child: Align(
                                                alignment: Alignment.centerLeft,
                                                child: Padding(
                                                  padding: EdgeInsets.only(
                                                      left: 13.w),
                                                  child: Text(
                                                    tasks[index]
                                                        .subTasks![i]
                                                        .subTaskTitle
                                                        .toString(),
                                                    // subtasks[index]
                                                    //     .subTaskTitle
                                                    //     .toString()
                                                  ),
                                                )),
                                          ),
                                          Container(
                                            width: 510.w,
                                            color: const Color(0xffF6FFFD),
                                            child: Padding(
                                              padding: EdgeInsets.all(13.w),
                                              child: Column(
                                                children: [
                                                  Text(
                                                    tasks[index]
                                                        .subTasks![i]
                                                        .subTaskDescription
                                                        .toString(),
                                                    // subtasks[index]
                                                    //     .subTaskDescription
                                                    //     .toString(),
                                                    style: TextStyle(
                                                        color: Colors.grey,
                                                        fontSize: 11.sp),
                                                  ),
                                                  15.verticalSpace,
                                                  SizedBox(
                                                    width: 550.w,
                                                    child: GestureDetector(
                                                      onTap: () {
                                                        showDialog(
                                                          barrierColor: Colors
                                                              .transparent,
                                                          context: context,
                                                          builder: (_) =>
                                                              AlertDialog(
                                                            backgroundColor:
                                                                Color(
                                                                    0xffFFF1E8),
                                                            // contentPadding:
                                                            //     EdgeInsets.zero,
                                                            shape:
                                                                const RoundedRectangleBorder(
                                                              borderRadius: BorderRadius
                                                                  .all(Radius
                                                                      .circular(
                                                                          10.0)),
                                                            ),
                                                            content: Column(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .min,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                // Your confirmation message
                                                                Text(
                                                                  'Are You Sure?',
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          14.sp,
                                                                      color: Colors
                                                                          .grey),
                                                                ),
                                                                SizedBox(
                                                                    height:
                                                                        20.0),
                                                                Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceEvenly,
                                                                  children: [
                                                                    GestureDetector(
                                                                      onTap:
                                                                          () {
                                                                        Navigator.pop(
                                                                            context);
                                                                      },
                                                                      child:
                                                                          Container(
                                                                        width:
                                                                            71.w,
                                                                        height:
                                                                            26.h,
                                                                        decoration: BoxDecoration(
                                                                            border:
                                                                                Border.all(color: Colors.black),
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
                                                                      onTap:
                                                                          () {
                                                                        Navigator.pop(
                                                                            context);
                                                                        subtaskcontroller.editTaskclicks(
                                                                            context,
                                                                            tasks[index].subTasks![i]);
                                                                      },
                                                                      child:
                                                                          Container(
                                                                        width:
                                                                            71.w,
                                                                        height:
                                                                            26.h,
                                                                        decoration: BoxDecoration(
                                                                            color:
                                                                                Colors.black,
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
                                                      },
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .end,
                                                        children: [
                                                          Row(
                                                            children: [
                                                              const Icon(
                                                                  Icons.edit),
                                                              2.horizontalSpace,
                                                              Text(
                                                                'EDIT',
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .black,
                                                                    fontSize:
                                                                        16.sp),
                                                              )
                                                            ],
                                                          ),
                                                          5.horizontalSpace,
                                                          GestureDetector(
                                                            onTap: () {
                                                              subtaskcontroller
                                                                  .viewtasks(
                                                                      context,
                                                                      tasks[index]
                                                                          .subTasks![i]);
                                                            },
                                                            child: Row(
                                                              children: [
                                                                const Icon(Icons
                                                                    .visibility),
                                                                2.horizontalSpace,
                                                                Text(
                                                                  'VIEW',
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .black,
                                                                      fontSize:
                                                                          16.sp),
                                                                )
                                                              ],
                                                            ),
                                                          ),
                                                          5.horizontalSpace,
                                                          GestureDetector(
                                                            onTap: () {
                                                              showDialog(
                                                                barrierColor: Colors
                                                                    .transparent,
                                                                context:
                                                                    context,
                                                                builder: (_) =>
                                                                    AlertDialog(
                                                                  backgroundColor:
                                                                      Color(
                                                                          0xffFFF1E8),
                                                                  // contentPadding:
                                                                  //     EdgeInsets.zero,
                                                                  shape:
                                                                      const RoundedRectangleBorder(
                                                                    borderRadius:
                                                                        BorderRadius.all(
                                                                            Radius.circular(10.0)),
                                                                  ),
                                                                  content:
                                                                      Column(
                                                                    mainAxisSize:
                                                                        MainAxisSize
                                                                            .min,
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    children: [
                                                                      // Your confirmation message
                                                                      Text(
                                                                        'Are You Sure?',
                                                                        style: TextStyle(
                                                                            fontSize:
                                                                                14.sp,
                                                                            color: Colors.grey),
                                                                      ),
                                                                      SizedBox(
                                                                          height:
                                                                              20.0),
                                                                      Row(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.spaceEvenly,
                                                                        children: [
                                                                          GestureDetector(
                                                                            onTap:
                                                                                () {
                                                                              Navigator.pop(context);
                                                                            },
                                                                            child:
                                                                                Container(
                                                                              width: 71.w,
                                                                              height: 26.h,
                                                                              decoration: BoxDecoration(border: Border.all(color: Colors.black), borderRadius: BorderRadius.circular(10)),
                                                                              child: Center(
                                                                                  child: Text(
                                                                                'CANCEL',
                                                                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10.sp, color: Colors.black),
                                                                              )),
                                                                            ),
                                                                          ),
                                                                          GestureDetector(
                                                                            onTap:
                                                                                () {
                                                                              Navigator.pop(context);
                                                                              subtaskcontroller.deleteTask(context, tasks[index].subTasks![i]);
                                                                            },
                                                                            child:
                                                                                Container(
                                                                              width: 71.w,
                                                                              height: 26.h,
                                                                              decoration: BoxDecoration(color: Colors.black, border: Border.all(color: Colors.black), borderRadius: BorderRadius.circular(10)),
                                                                              child: Center(
                                                                                  child: Text(
                                                                                'DELETE',
                                                                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10.sp, color: Colors.white),
                                                                              )),
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              );
                                                            },
                                                            child: Row(
                                                              children: [
                                                                const Icon(Icons
                                                                    .delete),
                                                                2.horizontalSpace,
                                                                Text(
                                                                  'DELETE',
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .black,
                                                                      fontSize:
                                                                          16.sp),
                                                                )
                                                              ],
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                          20.verticalSpace,
                                        ],
                                      );
                                    }))
                              ],
                            ),
                          )
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    ));
  }
}
