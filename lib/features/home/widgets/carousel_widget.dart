import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import '../../../common/colors.dart';
import '../../../models/blog.dart';
import '../../../providers/bookmarked_list_provider.dart';
import '../../blog/screens/blog_screen.dart';

class CarouselWidget extends StatefulWidget {
  const CarouselWidget({
    super.key,
    required this.blog,
  });

  final Blog blog;

  @override
  State<CarouselWidget> createState() => _CarouselWidgetState();
}

class _CarouselWidgetState extends State<CarouselWidget> {
  List<Blog> bookmarkedList = [];

  @override
  Widget build(BuildContext context) {
    bookmarkedList = Provider.of<BookmarksProvider>(context, listen: true)
        .bookmarkedBlogsList;
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BlogScreen(blog: widget.blog),
          ),
        );
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(40),
        child: Card(
          color: Colors.transparent,
          child: Stack(
            alignment: Alignment.bottomLeft,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child: Image.network(
                  widget.blog.imageUrl,
                  fit: BoxFit.cover,
                  width: screenWidth * 0.9,
                  height: screenHeight * 0.35,
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
              Container(
                constraints: const BoxConstraints.expand(),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30.0),
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
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Align(
                    alignment: Alignment.topRight,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10.0),
                          child: IconButton(
                            onPressed: () {},
                            icon: Icon(
                              Icons.share_rounded,
                              size: 25,
                              color: AppColors().text,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: IconButton(
                            onPressed: () {
                              bookmarkedList.contains(widget.blog)
                                  ? Provider.of<BookmarksProvider>(context,
                                          listen: false)
                                      .unMarkBlog(widget.blog)
                                  : Provider.of<BookmarksProvider>(context,
                                          listen: false)
                                      .bookmarkBlog(widget.blog);
                            },
                            icon: Icon(
                              bookmarkedList.contains(widget.blog)
                                  ? Icons.bookmark_added_rounded
                                  : Icons.bookmark_add_outlined,
                              size: 25,
                              color: AppColors().text,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(25.0),
                    child: Text(
                      widget.blog.title,
                      style: GoogleFonts.getFont(
                        "Ubuntu",
                        color: AppColors().text,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
