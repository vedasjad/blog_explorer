import 'dart:math';

import 'package:blog_explorer/features/home/services/home_services.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';

import '../../../common/colors.dart';
import '../../../models/blog.dart';
import '../widgets/blog_widget.dart';
import '../widgets/carousel_widget.dart';

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
  final _blogsBox = Hive.box("blogs_box");
  @override
  void initState() {
    super.initState();
    _getItemsFromHive();
  }

  Future<void> fetchBlogs() async {
    blogList = await homeServices.fetchBlogs(context: context);
    bool doesContainBlog = _blogsBox.containsKey(blogList![0].id);
    bool isBlogFav = false;
    if (doesContainBlog) {
      isBlogFav = _blogsBox.get(blogList![0].id)['isFavourite'];
    }
    for (int i = 0; i < blogList!.length; i++) {
      await _blogsBox.delete(blogList![i].id);
      await _blogsBox.put(blogList![i].id, {
        'title': blogList![i].title,
        'imageUrl': blogList![i].imageUrl,
        'isFavourite': (doesContainBlog) ? isBlogFav : false,
      });
    }
    setState(() {});
  }

  void _getItemsFromHive() async {
    final data = _blogsBox.keys.map((key) {
      final item = _blogsBox.get(key);
      return Blog(
        id: key,
        imageUrl: item['imageUrl'],
        title: item['title'],
        isFavourite: item['isFavourite'],
      );
    }).toList();
    if (data.isEmpty) {
      await fetchBlogs();
    } else {
      debugPrint("Blogs available in Local Storage");
      setState(() {
        blogList = data.reversed.toList();
      });
    }
    blogList!.shuffle(Random.secure());
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Icon(
          Icons.bookmark,
          size: 25,
          color: AppColors().secondary,
        ),
      ),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        scrolledUnderElevation: 0,
        elevation: 0,
        title: Text(
          'SCROLLERE',
          style: GoogleFonts.getFont(
            "Ubuntu",
            color: appColors.secondary,
          ),
        ),
        backgroundColor: appColors.background,
        leading: Drawer(
          backgroundColor: Colors.transparent,
          child: Icon(
            Icons.menu,
            size: 25,
            color: appColors.text,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Icon(
              Icons.search,
              size: 25,
              color: appColors.text,
            ),
          ),
        ],
      ),
      backgroundColor: appColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Popular Today',
                  style: GoogleFonts.getFont(
                    "Ubuntu",
                    fontSize: 20,
                    color: appColors.text,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 8,
                  ),
                  child: CarouselSlider.builder(
                    itemCount: 5,
                    itemBuilder: (BuildContext context, index, x) {
                      return CarouselWidget(
                        imageUrl: blogList![index].imageUrl,
                        title: blogList![index].title,
                      );
                    },
                    options: CarouselOptions(
                      autoPlay: true,
                      enlargeCenterPage: true,
                    ),
                  ),
                ),
                Text(
                  'Explore',
                  style: GoogleFonts.getFont(
                    "Ubuntu",
                    fontSize: 20,
                    color: appColors.text,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.only(left: 25),
                    shrinkWrap: true,
                    itemCount: blogList!.length,
                    semanticChildCount: 10,
                    itemBuilder: (BuildContext context, index) {
                      if (index < 5) return const SizedBox();
                      return Container(
                        margin: const EdgeInsets.fromLTRB(0, 0, 0, 8),
                        child: BlogWidget(blog: blogList![index]),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
