import 'package:erick/widgets/viewtask.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TaskScreen extends StatelessWidget {
  const TaskScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
                      width: 775.w,
                      child: Column(
                        children: [
                          Container(
                            width: 550.w,
                            height: 39.h,
                            decoration:
                                const BoxDecoration(color: Color(0xff163300)),
                            child: Align(
                                alignment: Alignment.centerLeft,
                                child: Padding(
                                  padding: EdgeInsets.only(left: 13.w),
                                  child: const Text('Task Title 1'),
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
                                    "It is a long established fact that a reader will be distracted by the readable content of a page when looking at its layout. The point of using Lorem Ipsum is that it has a more-or-less normal distribution of letters, as opposed to using 'Content here, content here', making it look like readable English. Many desktop publishing packages and web page editors now use Lorem Ipsum as their default model text.",
                                    style: TextStyle(
                                        color: Colors.grey, fontSize: 11.sp),
                                  ),
                                  15.verticalSpace,
                                  SizedBox(
                                    width: 550.w,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
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
                                            )
                                          ],
                                        ),
                                        5.horizontalSpace,
                                        GestureDetector(
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
                                                          return const ViewTask();
                                                        },
                                                      ),
                                                    ));
                                          },
                                          child: Row(
                                            children: [
                                              const Icon(Icons.visibility),
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
                                        Row(
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
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                          20.verticalSpace,
                          Container(
                            width: 510.w,
                            height: 39.h,
                            decoration:
                                const BoxDecoration(color: Color(0xff9FE870)),
                            child: Align(
                                alignment: Alignment.centerLeft,
                                child: Padding(
                                  padding: EdgeInsets.only(left: 13.w),
                                  child: const Text('Sub Task 1'),
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
                                    "It is a long established fact that a reader will be distracted by the readable content of a page when looking at its layout. The point of using Lorem Ipsum is that it has a more-or-less normal distribution of letters, as opposed to using 'Content here, content here', making it look like readable English. Many desktop publishing packages and web page editors now use Lorem Ipsum as their default model text.",
                                    style: TextStyle(
                                        color: Colors.grey, fontSize: 11.sp),
                                  ),
                                  15.verticalSpace,
                                  SizedBox(
                                    width: 550.w,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
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
                                            )
                                          ],
                                        ),
                                        5.horizontalSpace,
                                        GestureDetector(
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
                                                          return const ViewTask();
                                                        },
                                                      ),
                                                    ));
                                          },
                                          child: Row(
                                            children: [
                                              const Icon(Icons.visibility),
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
                                        Row(
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
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                          20.verticalSpace,
                          Container(
                            width: 510.w,
                            height: 39.h,
                            decoration:
                                const BoxDecoration(color: Color(0xff9FE870)),
                            child: Align(
                                alignment: Alignment.centerLeft,
                                child: Padding(
                                  padding: EdgeInsets.only(left: 13.w),
                                  child: const Text('Sub Task 2'),
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
                                    "It is a long established fact that a reader will be distracted by the readable content of a page when looking at its layout. The point of using Lorem Ipsum is that it has a more-or-less normal distribution of letters, as opposed to using 'Content here, content here', making it look like readable English. Many desktop publishing packages and web page editors now use Lorem Ipsum as their default model text.",
                                    style: TextStyle(
                                        color: Colors.grey, fontSize: 11.sp),
                                  ),
                                  15.verticalSpace,
                                  SizedBox(
                                    width: 550.w,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
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
                                            )
                                          ],
                                        ),
                                        5.horizontalSpace,
                                        GestureDetector(
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
                                                          return const ViewTask();
                                                        },
                                                      ),
                                                    ));
                                          },
                                          child: Row(
                                            children: [
                                              const Icon(Icons.visibility),
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
                                        Row(
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
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                          20.verticalSpace,
                          Align(
                            alignment: Alignment.topRight,
                            child: Padding(
                              padding: EdgeInsets.only(right: 10.w),
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
                                      'SUB TASK',
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 14.sp),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
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
}
