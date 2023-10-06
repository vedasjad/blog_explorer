import 'dart:math';

import 'package:blog_explorer/features/home/services/home_services.dart';
import 'package:blog_explorer/features/home/widgets/carousel_widget.dart';
import 'package:blog_explorer/providers/blogs_provider.dart';
import 'package:blog_explorer/providers/bookmarks_provider.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../../common/colors.dart';
import '../../../models/blog.dart';
import '../../bookmark/screens/bookmark_screen.dart';
import '../widgets/blog_widget.dart';
import '../widgets/loaderBlogWidget.dart';
import '../widgets/loaderCarouselWidget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Blog> blogList = [];
  List<Blog> bookmarkList = [];
  final HomeServices homeServices = HomeServices();
  final AppColors appColors = AppColors();

  int limit = 10;
  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (blogList.isEmpty && bookmarkList.isEmpty) {
      Provider.of<BlogsProvider>(context).getBlogsFromHive(context);
      Provider.of<BookmarksProvider>(context).getBookmarksFromHive();
      blogList = Provider.of<BlogsProvider>(context).blogsList;
      bookmarkList = Provider.of<BookmarksProvider>(context).bookmarksList;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Icon(
          Icons.messenger_outline_rounded,
          size: 27,
          color: AppColors().background,
        ),
      ),
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
            padding: const EdgeInsets.only(right: 16.0),
            child: IconButton.outlined(
              style: ButtonStyle(
                shape: MaterialStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                side: MaterialStatePropertyAll(
                    BorderSide(color: AppColors().secondary.withOpacity(0.5))),
              ),
              onPressed: () {},
              icon: Icon(
                Icons.notifications_none_outlined,
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
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 25.0,
                    horizontal: 45,
                  ),
                  child: Text(
                    'Most Popular!',
                    style: GoogleFonts.getFont(
                      "Ubuntu",
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      color: appColors.text,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 8,
                  ),
                  child: CarouselSlider.builder(
                    itemCount: 5,
                    options: CarouselOptions(
                      viewportFraction: 0.82,
                      aspectRatio: 3 / 2,
                      autoPlay: true,
                      enlargeCenterPage: true,
                      scrollPhysics: const BouncingScrollPhysics(),
                    ),
                    itemBuilder: (BuildContext context, index, x) {
                      return (blogList.isNotEmpty)
                          ? CarouselWidget(
                              blog: blogList[index],
                            )
                          : const LoaderCarouselWidget();
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(
                    45,
                    15,
                    45,
                    10,
                  ),
                  child: Text(
                    'Recent Blogs',
                    style: GoogleFonts.getFont(
                      "Ubuntu",
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      color: appColors.text,
                    ),
                  ),
                ),
                if (blogList.isNotEmpty)
                  ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.fromLTRB(15, 8, 15, 8),
                    shrinkWrap: true,
                    itemCount: min(limit, blogList.length),
                    semanticChildCount: 10,
                    itemBuilder: (BuildContext context, index) {
                      return (blogList.isNotEmpty)
                          ? (index < 5)
                              ? const SizedBox()
                              : BlogWidget(
                                  blog: blogList[index],
                                )
                          : const LoaderBlogWidget();
                    },
                  ),
                if (limit < blogList.length)
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        if (limit + 10 < blogList.length) {
                          setState(() {
                            limit += 10;
                          });
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Text(
                          'Show more',
                          style: GoogleFonts.getFont(
                            'Ubuntu',
                            fontSize: 18,
                            color: AppColors().background,
                          ),
                        ),
                      ),
                    ),
                  ),
                const SizedBox(
                  height: 10,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
