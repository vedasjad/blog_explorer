import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import '../../../common/colors.dart';
import '../../../common/utils.dart';
import '../../../models/blog.dart';
import '../../../providers/bookmarks_provider.dart';
import '../services/blog_services.dart';

class BlogScreen extends StatefulWidget {
  const BlogScreen({
    super.key,
    required this.blog,
  });

  final Blog blog;

  @override
  State<BlogScreen> createState() => _BlogScreenState();
}

class _BlogScreenState extends State<BlogScreen> {
  final BlogServices blogServices = BlogServices();
  List<Blog> bookmarkedList = [];
  String blogText = '';

  @override
  void initState() {
    super.initState();
    getText();
  }

  Future<void> getText() async {
    blogText = await blogServices.getTextForBlog(
      context: context,
      prompt: widget.blog.title,
    );
    setState(() {});
  }

  toggleBookmark() {
    bookmarkedList.contains(widget.blog)
        ? Provider.of<BookmarksProvider>(context, listen: false)
            .unMarkBlog(widget.blog)
        : Provider.of<BookmarksProvider>(context, listen: false)
            .bookmarkBlog(widget.blog);
    if (bookmarkedList.contains(widget.blog)) {
      showSnackBar(context, 'Added to Bookmarks');
    } else {
      showSnackBar(context, 'Removed from Bookmarks');
    }
  }

  @override
  Widget build(BuildContext context) {
    bookmarkedList =
        Provider.of<BookmarksProvider>(context, listen: true).bookmarksList;
    return Scaffold(
        backgroundColor: AppColors().background,
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          scrolledUnderElevation: 3.0,
          elevation: 0,
          leading: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Icon(
              Icons.arrow_back_ios_rounded,
              size: 25,
              color: AppColors().text,
            ),
          ),
          title: const Text(
            'SCROLLERE',
          ),
          titleTextStyle: GoogleFonts.getFont(
            "Montserrat",
            color: AppColors().secondary,
          ),
          backgroundColor: AppColors().background,
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(15, 15, 15, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.blog.title,
                        textAlign: TextAlign.start,
                        style: GoogleFonts.getFont(
                          'Montserrat',
                          color: AppColors().text,
                          fontSize: 25,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Blog Written by TextCortex API",
                            textAlign: TextAlign.start,
                            style: GoogleFonts.getFont(
                              'Ubuntu',
                              color: AppColors().text.withOpacity(0.5),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                GestureDetector(
                                  onTap: toggleBookmark,
                                  child: Icon(
                                    (bookmarkedList.contains(widget.blog))
                                        ? Icons.bookmark_added_rounded
                                        : Icons.bookmark_add_outlined,
                                    color: AppColors().text,
                                    size: 30,
                                  ),
                                ),
                                const SizedBox(
                                  width: 20,
                                ),
                                Icon(
                                  Icons.share,
                                  color: AppColors().text,
                                  size: 30,
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                ClipRRect(
                  // borderRadius: const BorderRadius.only(
                  //   bottomRight: Radius.circular(50),
                  // ),
                  child: Image.network(
                    widget.blog.imageUrl,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Shimmer.fromColors(
                        baseColor: AppColors().background,
                        highlightColor: AppColors().lightBackground,
                        child: Container(
                          constraints: const BoxConstraints.expand(),
                          decoration: BoxDecoration(
                            color: Colors.transparent,
                            borderRadius: BorderRadius.circular(40),
                          ),
                        ),
                      );
                    },
                    errorBuilder: (context, child, loadingProgress) {
                      return Container(
                        constraints: const BoxConstraints.expand(),
                        color: AppColors().lightBackground,
                        child: Center(
                          child: Text(
                            'Image Not Found',
                            style: GoogleFonts.getFont(
                              'Montserrat',
                              fontSize: 30,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      (blogText != '')
                          ? Text(
                              blogText,
                              textAlign: TextAlign.justify,
                              style: GoogleFonts.getFont(
                                'Ubuntu',
                                color: AppColors().text,
                                fontSize: 15,
                                letterSpacing: 1,
                                height: 1.7,
                              ),
                            )
                          : Text(
                              'Sorry! It\'s taking some time',
                              textAlign: TextAlign.justify,
                              style: GoogleFonts.getFont(
                                'Ubuntu',
                                color: AppColors().text,
                                fontSize: 25,
                                letterSpacing: 1,
                                height: 1.7,
                              ),
                            ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
