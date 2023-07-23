import 'package:erick/features/onboarding/view/login.dart';
import 'package:erick/features/onboarding/viewmodel/loginviewmodel.dart';
import 'package:erick/features/tasks/viewmodel/calendarviewmodel.dart';
import 'package:erick/features/tasks/viewmodel/tasksviewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(768, 1024),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MultiProvider(
          providers: providers(context),
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'First Method',
            // You can use the library anywhere in the app even in theme
            theme: ThemeData(
              primarySwatch: Colors.blue,
              textTheme: Typography.englishLike2018.apply(fontSizeFactor: 1.sp),
            ),
            home: child,
          ),
        );
      },
      child: const LoginScreen(),
    );
  }
}

List<SingleChildWidget> providers(BuildContext context) {
  return [
    ChangeNotifierProvider<LoginViewModel>(create: (_) => LoginViewModel()),
    ChangeNotifierProvider<TaskViewModel>(create: (_) => TaskViewModel()),
    ChangeNotifierProvider<CalendarViewModel>(
        create: (_) => CalendarViewModel()),
  ];
}
