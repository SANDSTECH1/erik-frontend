import 'package:erick/features/subtasks/viewmodel/subtasksviewmodel.dart';
import 'package:erick/features/tasks/model/tasks.dart';
import 'package:erick/features/tasks/viewmodel/calendarviewmodel.dart';
import 'package:erick/features/tasks/viewmodel/tasksviewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class TaskScreen extends StatelessWidget {
  final List<taskByDate> tasks;
  final List<SubTasks> subtasks;
  const TaskScreen({
    super.key,
    required this.tasks,
    required this.subtasks,
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
                              Navigator.pop(context, true);
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
                              // '${calendarcontroller.activeShowYear}-${calendarcontroller.activeShowMonth + 1}',
                              calendarcontroller.getFormattedMonthAndYear(),
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
                    return Column(
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
                                              taskcontroller
                                                  .editTaskConfirmation(
                                                      context, tasks[index]);
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
                                                        context, tasks[index]);
                                                  },
                                                  child: Row(
                                                    children: [
                                                      const Icon(
                                                          Icons.visibility),
                                                      2.horizontalSpace,
                                                      Text(
                                                        'VIEW',
                                                        style: TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 16.sp),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                                5.horizontalSpace,
                                                GestureDetector(
                                                  onTap: () {
                                                    taskcontroller
                                                        .deleteTaskConfirmation(
                                                            context,
                                                            tasks[index]);
                                                  },
                                                  child: Row(
                                                    children: [
                                                      const Icon(Icons.delete),
                                                      2.horizontalSpace,
                                                      Text(
                                                        'DELETE',
                                                        style: TextStyle(
                                                            color: Colors.black,
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
                                                padding:
                                                    EdgeInsets.only(left: 13.w),
                                                child: Text(
                                                  tasks[index]
                                                      .subTasks![i]
                                                      .subTaskTitle
                                                      .toString(),
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
                                                  style: TextStyle(
                                                      color: Colors.grey,
                                                      fontSize: 11.sp),
                                                ),
                                                15.verticalSpace,
                                                SizedBox(
                                                  width: 550.w,
                                                  child: GestureDetector(
                                                    onTap: () {
                                                      subtaskcontroller
                                                          .editSubTaskConfirmation(
                                                              context,
                                                              tasks[index]
                                                                  .subTasks![i]);
                                                    },
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment.end,
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
                                                                .viewsubtasks(
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
                                                            subtaskcontroller
                                                                .deleteSubTaskConfirmation(
                                                                    context,
                                                                    tasks[index]
                                                                        .subTasks![i]);
                                                          },
                                                          child: Row(
                                                            children: [
                                                              const Icon(
                                                                  Icons.delete),
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
