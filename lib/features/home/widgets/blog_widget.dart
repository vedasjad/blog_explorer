import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';

import '../../../common/colors.dart';
import '../../../models/blog.dart';
import '../../blog/screens/blog_screen.dart';

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
  @override
  Widget build(BuildContext context) {
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
                        frameBuilder:
                            (context, child, i, wasSynchronouslyLoaded) {
                          if (wasSynchronouslyLoaded == false) return child;
                          return Shimmer.fromColors(
                            baseColor: AppColors().background,
                            highlightColor: AppColors().lightBackground,
                            child: Container(
                              constraints: const BoxConstraints.expand(),
                              color: AppColors().lightBackground,
                            ),
                          );
                        },
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
                            child: Text(
                              'Image Not Found',
                              style: GoogleFonts.getFont(
                                'Montserrat',
                                fontSize: 10,
                                color: Colors.grey,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Text(
                        widget.blog.title,
                        style: GoogleFonts.getFont(
                          "Ubuntu",
                          color: AppColors().text,
                          fontSize: 16,
                        ),
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
