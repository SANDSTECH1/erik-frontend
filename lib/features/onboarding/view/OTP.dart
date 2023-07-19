import 'package:erick/features/onboarding/view/Confirmpass.dart';
import 'package:erick/features/onboarding/viewmodel/otpviewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/otp_text_field.dart';
import 'package:otp_text_field/style.dart';
import 'package:provider/provider.dart';

class otp extends StatelessWidget {
  final String data;
  const otp({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<OtpViewModel>(context);
    OtpFieldController optcontroller = OtpFieldController();

    return Scaffold(
        body: Row(
      children: [
        Container(
          width: 267.w,
          decoration: const BoxDecoration(color: Color(0xff163300)),
          child: Column(
            children: [
              137.verticalSpace,
              137.verticalSpace,
              Image.asset(
                'assets/icons/sidelogo.png',
                width: 191.w,
              ),
            ],
          ),
        ),
        Expanded(
            child: Column(
          children: [
            101.verticalSpace,
            Container(
              width: 100.w,
              height: 100.h,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: CircleAvatar(
                backgroundColor: Colors.white,
                child: Text(
                  'Logo Here',
                  style: TextStyle(
                    fontSize: 8.sp,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            57.verticalSpace,
            SizedBox(
              width: 549.w,
              child: Text(
                "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since .",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16.sp,
                  color: Colors.black,
                ),
              ),
            ),
            30.verticalSpace,
            SizedBox(
              width: 400.w,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "OTP",
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      fontSize: 24.sp,
                      color: Colors.black,
                    ),
                  ),
                  20.verticalSpace,
                  OTPTextField(
                      otpFieldStyle: OtpFieldStyle(),
                      controller: optcontroller,
                      length: 5,
                      width: MediaQuery.of(context).size.width,
                      textFieldAlignment: MainAxisAlignment.spaceAround,
                      fieldWidth: 54.w,
                      fieldStyle: FieldStyle.box,
                      outlineBorderRadius: 5.r,
                      style: TextStyle(fontSize: 17),
                      onChanged: (pin) {
                        print("Changed: " + pin);
                      },
                      onCompleted: (pin) {
                        print("Completed: " + pin);
                      }),
                ],
              ),
            ),
            25.verticalSpace,
            GestureDetector(
              onTap: () async {
                final controller =
                    Provider.of<OtpViewModel>(context, listen: false);
                controller.otp();
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Confirmpass()),
                );
              },
              child: Container(
                width: 447.w,
                decoration: BoxDecoration(
                    color: Color(0xff9FE870),
                    borderRadius: BorderRadius.all(Radius.circular(4.r))),
                child: Padding(
                  padding: EdgeInsets.all(9.w),
                  child: Center(
                    child: Text(
                      'CONTINUE',
                      style: TextStyle(color: Colors.white, fontSize: 14.sp),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ))
      ],
    ));
  }
}
