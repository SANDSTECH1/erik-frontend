import 'package:erick/features/onboarding/view/OTP.dart';
import 'package:erick/features/onboarding/view/login.dart';
import 'package:erick/features/onboarding/viewmodel/loginviewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:erick/features/onboarding/viewmodel/resetpassviewmodel.dart';
import 'package:provider/provider.dart';

class Confirmpass extends StatelessWidget {
  const Confirmpass({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<ResetPassViewModel>(context);
    return Scaffold(
      body: Row(
        children: [
          Container(
            width: 267.w,
            decoration: const BoxDecoration(color: Color(0xff163300)),
            child: Column(
              children: [
                137.verticalSpace,
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
                width: 400,
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
                width: 447.w,
                child: TextField(
                  controller: controller.passwordcontroller,
                  //enabled: false, // to trigger disabledBorder
                  decoration: InputDecoration(
                    suffixIcon: Icon(Icons.visibility_outlined),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(4.r)),
                      borderSide:
                          const BorderSide(width: 1, color: Colors.grey),
                    ),
                    disabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(4.r)),
                      borderSide:
                          const BorderSide(width: 1, color: Colors.grey),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(4.r)),
                      borderSide:
                          const BorderSide(width: 1, color: Colors.grey),
                    ),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(4.r)),
                        borderSide: const BorderSide(
                          width: 1,
                        )),
                    errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(4.r)),
                        borderSide:
                            const BorderSide(width: 1, color: Colors.grey)),
                    focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(4.r)),
                        borderSide:
                            const BorderSide(width: 1, color: Colors.grey)),
                    hintText: "Password",
                    hintStyle:
                        TextStyle(fontSize: 16, color: Color(0xFFB3B1B1)),
                  ),
                  obscureText: false,
                ),
              ),
              30.verticalSpace,
              SizedBox(
                width: 447.w,
                child: TextField(
                  //enabled: false,
                  controller: controller
                      .confirmpasswordcontroller, // to trigger disabledBorder
                  decoration: InputDecoration(
                    suffixIcon: Icon(Icons.visibility_outlined),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(4.r)),
                      borderSide:
                          const BorderSide(width: 1, color: Colors.grey),
                    ),
                    disabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(4.r)),
                      borderSide:
                          const BorderSide(width: 1, color: Colors.grey),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(4.r)),
                      borderSide:
                          const BorderSide(width: 1, color: Colors.grey),
                    ),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(4.r)),
                        borderSide: const BorderSide(
                          width: 1,
                        )),
                    errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(4.r)),
                        borderSide:
                            const BorderSide(width: 1, color: Colors.grey)),
                    focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(4.r)),
                        borderSide:
                            const BorderSide(width: 1, color: Colors.grey)),
                    hintText: "Confirm Password",
                    hintStyle:
                        TextStyle(fontSize: 16, color: Color(0xFFB3B1B1)),
                  ),
                  obscureText: false,
                ),
              ),
              30.verticalSpace,
              GestureDetector(
                onTap: () async {
                  await controller
                      .resetpass(); // Call the resetpass method from the view model
                  final userToken = controller
                      .userToken; // Get the userToken from the view model
                  if (userToken != null) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LoginScreen(
                          userToken:
                              userToken, // Pass the userToken to the LoginScreen
                        ),
                      ),
                    );
                  } else {
                    print('no token found');
                  }
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
      ),
    );
  }
}
