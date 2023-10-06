import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import '../../../common/colors.dart';
import '../../../models/blog.dart';
import '../../../providers/bookmarks_provider.dart';
import '../../blog/screens/blog_screen.dart';

class BookmarkWidget extends StatefulWidget {
  const BookmarkWidget({
    super.key,
    required this.blog,
  });

  final Blog blog;

  @override
  State<BookmarkWidget> createState() => _BookmarkWidgetState();
}

class _BookmarkWidgetState extends State<BookmarkWidget> {
  List<Blog> bookmarkedList = [];
  @override
  Widget build(BuildContext context) {
    bookmarkedList =
        Provider.of<BookmarksProvider>(context, listen: true).bookmarksList;
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
            elevation: 10,
            color: Colors.transparent,
            child: Container(
              color: AppColors().background,
              width: screenWidth * 0.95,
              height: screenHeight * 0.14,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.fromLTRB(4, 4, 4, 4),
                    width: screenWidth * 0.3,
                    height: screenHeight * 0.2,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: Image.network(
                        widget.blog.imageUrl,
                        fit: BoxFit.fill,
                        width: screenWidth * 0.3,
                        height: screenHeight * 0.2,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Shimmer.fromColors(
                            baseColor: AppColors().background,
                            highlightColor: AppColors().lightBackground,
                            child: Container(
                              constraints: const BoxConstraints.expand(),
                              color: AppColors().lightBackground,
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
                                  fontSize: 10,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      physics: const NeverScrollableScrollPhysics(),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(15, 15, 0, 15),
                            child: Text(
                              widget.blog.title,
                              // overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.start,
                              softWrap: true,
                              style: GoogleFonts.getFont(
                                "Ubuntu",
                                color: AppColors().text,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
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
