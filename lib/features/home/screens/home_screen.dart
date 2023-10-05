import 'dart:math';

import 'package:blog_explorer/features/home/services/home_services.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';

import '../../../common/colors.dart';
import '../../../models/blog.dart';
import '../../bookmark/screens/bookmark_screen.dart';
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
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        scrolledUnderElevation: 3.0,
        elevation: 0,
        title: const Text('SCROLLERE'),
        titleTextStyle: GoogleFonts.getFont(
          "Montserrat",
          color: appColors.secondary,
        ),
        backgroundColor: appColors.background,
        actions: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const BookmarkScreen(),
                  ),
                );
              },
              child: Icon(
                Icons.bookmark_border_rounded,
                size: 25,
                color: appColors.text,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: GestureDetector(
              onTap: () {},
              child: Icon(
                Icons.search,
                size: 25,
                color: appColors.text,
              ),
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
                        blog: blogList![index],
                      );
                    },
                    options: CarouselOptions(
                      autoPlay: true,
                      enlargeCenterPage: true,
                      scrollPhysics: const BouncingScrollPhysics(),
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
                ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(25, 8, 25, 8),
                  shrinkWrap: true,
                  itemCount: blogList!.length,
                  semanticChildCount: 10,
                  itemBuilder: (BuildContext context, index) {
                    if (index < 5) return const SizedBox();
                    return BlogWidget(blog: blogList![index]);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
