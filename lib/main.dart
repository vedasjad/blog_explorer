import 'package:blog_explorer/common/colors.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';

import 'features/home/screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox("blogs_box");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Blog Explorer',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors().background),
        useMaterial3: true,
        platform: TargetPlatform.android,
      ),
      home: const HomeScreen(),
    );
  }
}
