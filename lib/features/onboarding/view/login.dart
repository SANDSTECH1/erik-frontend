import 'package:erick/features/onboarding/viewmodel/loginviewmodel.dart';
import 'package:erick/features/onboarding/view/register.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<LoginViewModel>(context);

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
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  78.verticalSpace,
                  SizedBox(
                    width: 400.w,
                    child: Text(
                      "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since .",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.black, fontSize: 16.sp),
                    ),
                  ),
                  78.verticalSpace,
                  SizedBox(
                    width: 447.w,
                    child: TextField(
                      style: TextStyle(color: Colors.black),
                      controller: controller.useremailcontroller,
                      decoration: InputDecoration(
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
                            borderRadius:
                                BorderRadius.all(Radius.circular(4.r)),
                            borderSide: const BorderSide(
                              width: 1,
                            )),
                        errorBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(4.r)),
                            borderSide:
                                const BorderSide(width: 1, color: Colors.grey)),
                        focusedErrorBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(4.r)),
                            borderSide:
                                const BorderSide(width: 1, color: Colors.grey)),
                        hintText: "Name",
                        hintStyle: const TextStyle(
                            fontSize: 16, color: Color(0xFFB3B1B1)),
                      ),
                      obscureText: false,
                    ),
                  ),
                  30.verticalSpace,
                  SizedBox(
                    width: 447.w,
                    child: TextField(
                      style: TextStyle(color: Colors.black),
                      controller: controller.userpasswordcontroller,
                      decoration: InputDecoration(
                        suffixIcon: const Icon(Icons.visibility_outlined),
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
                            borderRadius:
                                BorderRadius.all(Radius.circular(4.r)),
                            borderSide: const BorderSide(
                              width: 1,
                            )),
                        errorBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(4.r)),
                            borderSide:
                                const BorderSide(width: 1, color: Colors.grey)),
                        focusedErrorBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(4.r)),
                            borderSide:
                                const BorderSide(width: 1, color: Colors.grey)),
                        hintText: "Password",
                        hintStyle: const TextStyle(
                            fontSize: 16, color: Color(0xFFB3B1B1)),
                      ),
                      obscureText: false,
                    ),
                  ),
                  30.verticalSpace,
                  SizedBox(
                    width: 447.w,
                    child: GestureDetector(
                      onTap: () {
                        // controller.login();
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const RegisterScreen()),
                        );
                      },
                      child: const Align(
                        alignment: Alignment.topRight,
                        child: Text(
                          'Forgot Password ?',
                          style: TextStyle(color: Color(0xff9FE870)),
                        ),
                      ),
                    ),
                  ),
                  30.verticalSpace,
                  GestureDetector(
                    onTap: () {
                      controller.login(context);
                    },
                    child: Container(
                      width: 447.w,
                      decoration: BoxDecoration(
                          color: const Color(0xff9FE870),
                          borderRadius: BorderRadius.all(Radius.circular(4.r))),
                      child: Padding(
                        padding: EdgeInsets.all(11.w),
                        child: Center(
                          child: Text(
                            'LOGIN',
                            style:
                                TextStyle(color: Colors.white, fontSize: 14.sp),
                          ),
                        ),
                      ),
                    ),
                  ),
                  30.verticalSpace,
                  Text(
                    'OR',
                    style: TextStyle(
                        fontSize: 16.sp,
                        color: Colors.black,
                        fontWeight: FontWeight.bold),
                  ),
                  30.verticalSpace,
                  Container(
                    width: 447.w,
                    decoration: BoxDecoration(
                        color: const Color(0xff9FE870),
                        borderRadius: BorderRadius.all(Radius.circular(4.r))),
                    child: Padding(
                      padding: EdgeInsets.all(9.w),
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/icons/apple.png',
                              color: Colors.white,
                              width: 15.w,
                            ),
                            5.horizontalSpace,
                            SizedBox(
                              width: 60.w,
                              child: Text(
                                'APPLE',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 14.sp),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  15.verticalSpace,
                  Container(
                    width: 447.w,
                    decoration: BoxDecoration(
                        color: const Color(0xff9FE870),
                        borderRadius: BorderRadius.all(Radius.circular(4.r))),
                    child: Padding(
                      padding: EdgeInsets.all(9.w),
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/icons/facebook.png',
                              color: Colors.white,
                              width: 15.w,
                            ),
                            5.horizontalSpace,
                            SizedBox(
                              width: 60.w,
                              child: Text(
                                'FACEBOOK',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 14.sp),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  15.verticalSpace,
                  Container(
                    width: 447.w,
                    decoration: BoxDecoration(
                        color: const Color(0xff9FE870),
                        borderRadius: BorderRadius.all(Radius.circular(4.r))),
                    child: Padding(
                      padding: EdgeInsets.all(9.w),
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/icons/google.png',
                              color: Colors.white,
                              width: 15.w,
                            ),
                            5.horizontalSpace,
                            SizedBox(
                              width: 60.w,
                              child: Text(
                                'GOOGLE',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 14.sp),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  30.verticalSpace,
                  SizedBox(
                    width: 447.w,
                    child: Align(
                      alignment: Alignment.topRight,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            "Don't you have an account ? ",
                            style:
                                TextStyle(color: Colors.black, fontSize: 16.sp),
                          ),
                          5.horizontalSpace,
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const RegisterScreen()),
                              );
                            },
                            child: Text(
                              'Create One',
                              style: TextStyle(
                                  color: const Color(0xff9FE870),
                                  fontSize: 16.sp),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
