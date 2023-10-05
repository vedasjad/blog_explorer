import 'package:blog_explorer/common/colors.dart';
import 'package:blog_explorer/providers/bookmarked_list_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:provider/provider.dart';

import 'features/home/screens/home_screen.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox("blogs_box");
  await DotEnv().load(fileName: '.env');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<BookmarkedListProvider>(
      create: (context) => BookmarkedListProvider(),
      child: MaterialApp(
        title: 'Scrollere',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: AppColors().background),
          useMaterial3: true,
          platform: TargetPlatform.android,
        ),
        home: const HomeScreen(),
      ),
    );
  }
}
