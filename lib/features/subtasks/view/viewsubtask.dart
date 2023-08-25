import 'package:erick/features/subtasks/viewmodel/subtasksviewmodel.dart';
import 'package:erick/features/tasks/model/tasks.dart';
import 'package:erick/features/tasks/model/usermember.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:printing/printing.dart';

class ViewSubTasks extends StatelessWidget {
  final SubTasks subtasks;
  const ViewSubTasks({
    super.key,
    required this.subtasks,
  });

  @override
  Widget build(BuildContext context) {
    final subtaskcontroller = Provider.of<SubTaskViewModel>(context);
    return Material(
      child: SizedBox(
        width: 500.w,
        child: Column(
          children: [
            Container(
              width: 500.w,
              height: 60.h,
              decoration: const BoxDecoration(color: Color(0xff163300)),
              child: Padding(
                padding: EdgeInsets.only(left: 23.w, right: 23.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Task Title",
                      style: TextStyle(color: Colors.white, fontSize: 17.sp),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                        subtaskcontroller.clearSubTaskData();
                      },
                      child: CircleAvatar(
                        radius: 20.r,
                        backgroundColor: Colors.white,
                        child: Icon(
                          Icons.close,
                          size: 15.w,
                          color: Colors.green,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            SizedBox(
              width: 450.w,
              child: Column(
                children: [
                  20.verticalSpace,
                  SizedBox(
                    width: 450.w,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          subtaskcontroller.subtaskTitlecontroller.text,
                          style: TextStyle(color: Colors.grey, fontSize: 20.sp),
                        ),
                        Row(
                          children: [
                            ElevatedButton(
                              onPressed: () async {
                                final pdfContent = await generatePdfContent(
                                  subtaskcontroller,
                                );
                                if (pdfContent != null) {
                                  await Printing.layoutPdf(
                                      onLayout: (format) => pdfContent);
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                primary: Colors.white,
                              ),
                              child: Row(
                                children: const [
                                  Icon(
                                    Icons.print,
                                    color: Color(0xff163300),
                                  ),
                                  SizedBox(width: 2),
                                  Text(
                                    'Print',
                                    style: TextStyle(
                                      color: Color(0xff163300),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                  23.verticalSpace,
                  SizedBox(
                    width: 450.w,
                    child: TextField(
                      controller:
                          subtaskcontroller.subtaskDescriptioncontroller,
                      keyboardType: TextInputType.multiline,
                      minLines: 13, //Normal textInputField will be displayed
                      maxLines:
                          15, // when user presses enter it will adapt to it
                      enabled: false, // to trigger disabledBorder
                      decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10.r)),
                          borderSide: const BorderSide(
                              width: 1, color: Color(0xFFC9C9C9)),
                        ),
                        disabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10.r)),
                          borderSide: const BorderSide(
                              width: 1, color: Color(0xFFC9C9C9)),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10.r)),
                          borderSide: const BorderSide(
                              width: 1, color: Color(0xFFC9C9C9)),
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
                                width: 1, color: Color(0xFFC9C9C9))),
                        focusedErrorBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.r)),
                            borderSide: const BorderSide(
                                width: 1, color: Color(0xFFC9C9C9))),
                        hintText: "Your description...",
                        hintStyle: const TextStyle(
                            fontSize: 16, color: Color(0xFFC9C9C9)),
                      ),
                      obscureText: false,
                    ),
                  ),
                  SizedBox(
                    //width: 50.w,
                    height: 100.h,
                    child: Row(children: [
                      Icon(Icons.access_time_filled_sharp),
                      2.horizontalSpace,
                      const Text(
                        'Estimated Time :',
                        style: TextStyle(color: Color(0xff163300)),
                      ),
                      SizedBox(
                        width: 50.w,
                        height: 30.h,
                        child: TextField(
                          controller: subtaskcontroller.estimatedTimecontroller,
                          style:
                              TextStyle(color: Colors.black, fontSize: 15.sp),
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
                                borderRadius:
                                    BorderRadius.all(Radius.circular(4.r)),
                                borderSide: const BorderSide(
                                  width: 1,
                                )),
                            errorBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(4.r)),
                                borderSide: const BorderSide(
                                    width: 1, color: Colors.grey)),
                            focusedErrorBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(4.r)),
                                borderSide: const BorderSide(
                                    width: 1, color: Colors.grey)),
                            hintText: "",
                            hintStyle: const TextStyle(
                                fontSize: 16, color: Colors.black),
                          ),
                          obscureText: false,
                        ),
                      ),
                      SizedBox(
                        width: 150.w,
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
                          controller: subtaskcontroller.pricecontroller,
                          style:
                              TextStyle(color: Colors.black, fontSize: 15.sp),
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
                                borderRadius:
                                    BorderRadius.all(Radius.circular(4.r)),
                                borderSide: const BorderSide(
                                  width: 1,
                                )),
                            errorBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(4.r)),
                                borderSide: const BorderSide(
                                    width: 1, color: Colors.grey)),
                            focusedErrorBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(4.r)),
                                borderSide: const BorderSide(
                                    width: 1, color: Colors.grey)),
                            hintText: "",
                            hintStyle: const TextStyle(
                                fontSize: 16, color: Colors.black),
                          ),
                          obscureText: false,
                        ),
                      ),
                    ]),
                  ),
                  23.verticalSpace,
                  Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      'Assigned To',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 20.sp,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  23.verticalSpace,
                  Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: List.generate(
                        subtaskcontroller.filteredUsers.length,
                        (index) =>
                            AssignTo(subtaskcontroller.filteredUsers[index]),
                      ))
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

Widget AssignTo(userListData user) {
  return Container(
    width: 100.w,
    height: 50.h,
    decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(20.r)),
        border: Border.all(color: Colors.grey)),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          'assets/icons/erickpic.png',
          width: 15.w,
        ),
        4.horizontalSpace,
        Text(
          user.name.toString(),
          style: TextStyle(color: Colors.black, fontSize: 20.sp),
        ),
        6.horizontalSpace,
        const Icon(
          Icons.cancel,
          color: Colors.red,
          size: 20,
        )
      ],
    ),
  );
}
