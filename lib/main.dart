import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'res/colors/colors.dart';
import 'res/routes/routes.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: AppColors.scaffoldBackgroundColor,
        primaryColor: AppColors.primary,
        appBarTheme: AppBarTheme(color: AppColors.black),
      ),
      getPages: AppRoutes.appRoutes(),
    );
  }
}
