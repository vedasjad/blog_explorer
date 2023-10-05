import 'package:blog_explorer/features/blog/screens/blog_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inset_box_shadow/flutter_inset_box_shadow.dart'
    as inset;
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';

import '../../../common/colors.dart';
import '../../../models/blog.dart';
import '../../../providers/bookmarked_list_provider.dart';

class BlogWidget extends StatefulWidget {
  const BlogWidget({
    super.key,
    required this.blog,
  });

  final Blog blog;

  @override
  State<BlogWidget> createState() => _BlogWidgetState();
}

class _BlogWidgetState extends State<BlogWidget> {
  final blogsBox = Hive.box("blogs_box");
  List<Blog> bookmarkedList = [];

  void toggleBookmark() {
    bookmarkedList.contains(widget.blog)
        ? Provider.of<BookmarkedListProvider>(context, listen: false)
            .unMarkBlog(widget.blog)
        : Provider.of<BookmarkedListProvider>(context, listen: false)
            .bookmarkBlog(widget.blog);
  }

  @override
  Widget build(BuildContext context) {
    bookmarkedList = Provider.of<BookmarkedListProvider>(context, listen: true)
        .bookmarkedBlogsList;
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BlogScreen(blog: widget.blog),
            ),
          );
        },
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: Card(
            color: Colors.transparent,
            child: Container(
              width: screenWidth * 0.85,
              height: screenHeight * 0.2,
              decoration: BoxDecoration(
                boxShadow: [
                  const inset.BoxShadow(
                    color: Colors.black,
                    offset: Offset(4, 4),
                    blurRadius: 4.5,
                    spreadRadius: 2,
                    inset: true,
                  ),
                  inset.BoxShadow(
                    color: AppColors().text.withOpacity(0.1),
                    offset: const Offset(-4, -4),
                    blurRadius: 4.5,
                    spreadRadius: 2,
                    inset: false,
                  ),
                ],
              ),
              child: Stack(
                alignment: Alignment.bottomLeft,
                children: [
                  // ClipRRect(
                  //   borderRadius: BorderRadius.circular(15),
                  //   child: Image.network(
                  //     widget.blog.imageUrl,
                  //     fit: BoxFit.cover,
                  //     width: screenWidth * 0.85,
                  //     height: screenHeight * 0.2,
                  //     frameBuilder:
                  //         (context, child, i, wasSynchronouslyLoaded) {
                  //       if (wasSynchronouslyLoaded == false) return child;
                  //       return Shimmer.fromColors(
                  //         baseColor: AppColors().background,
                  //         highlightColor: AppColors().lightBackground,
                  //         child: Container(
                  //           constraints: const BoxConstraints.expand(),
                  //           color: AppColors().lightBackground,
                  //         ),
                  //       );
                  //     },
                  //     loadingBuilder: (context, child, loadingProgress) {
                  //       if (loadingProgress == null) return child;
                  //       return Shimmer.fromColors(
                  //         baseColor: AppColors().background,
                  //         highlightColor: AppColors().lightBackground,
                  //         child: Container(
                  //           constraints: const BoxConstraints.expand(),
                  //           color: AppColors().lightBackground,
                  //         ),
                  //       );
                  //     },
                  //     errorBuilder: (context, child, loadingProgress) {
                  //       return Container(
                  //         constraints: const BoxConstraints.expand(),
                  //         color: AppColors().lightBackground,
                  //         child: Text(
                  //           'Image Not Found',
                  //           style: GoogleFonts.getFont(
                  //             'Montserrat',
                  //             fontSize: 30,
                  //             color: Colors.grey,
                  //           ),
                  //         ),
                  //       );
                  //     },
                  //   ),
                  // ),
                  Container(
                    constraints: const BoxConstraints.expand(),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15.0),
                      gradient: const LinearGradient(
                        colors: [
                          Color.fromARGB(255, 0, 0, 0),
                          Color.fromARGB(185, 0, 0, 0),
                          Color.fromARGB(10, 255, 255, 255)
                        ],
                        begin: FractionalOffset.bottomCenter,
                        end: FractionalOffset.center,
                      ),
                      backgroundBlendMode: BlendMode.dstOut,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Text(
                      widget.blog.title,
                      style: GoogleFonts.getFont(
                        "Ubuntu",
                        color: AppColors().text,
                        fontSize: 15,
                      ),
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
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
                              ),
                            ),
                            const SizedBox(
                              width: 20,
                            ),
                            Icon(
                              Icons.share,
                              color: AppColors().text,
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
