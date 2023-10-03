import 'package:blog_explorer/features/home/services/home_services.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../common/colors.dart';
import '../../../models/blog.dart';
import '../widgets/blog_widget.dart';

class HomeScreen extends StatefulWidget {
  static const String routeName = '/home';
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Blog>? blogList;
  final HomeServices homeServices = HomeServices();
  final AppColors appColors = AppColors();
  @override
  void initState() {
    super.initState();
    fetchBlogs();
  }

  fetchBlogs() async {
    blogList = await homeServices.fetchBlogs(context: context);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'SUBSPACE',
          style: GoogleFonts.getFont(
            "Ubuntu",
            color: appColors.green,
          ),
        ),
        backgroundColor: Colors.transparent,
        leading: Drawer(
          backgroundColor: Colors.transparent,
          child: Icon(
            Icons.menu,
            size: 25,
            color: appColors.green,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Icon(
              Icons.search,
              size: 25,
              color: appColors.green,
            ),
          ),
        ],
      ),
      backgroundColor: appColors.black,
      body: SafeArea(
        child: Column(
          children: [
            Center(
              child: SizedBox(
                width: screenWidth * 0.9,
                height: screenHeight * 0.9,
                child: ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  itemCount: blogList!.length,
                  itemBuilder: (BuildContext context, index) {
                    return Container(
                      margin: const EdgeInsets.only(bottom: 5),
                      child: BlogWidget(
                        imageUrl: blogList![index].imageUrl,
                        title: blogList![index].title,
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
