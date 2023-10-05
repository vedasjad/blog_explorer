import 'package:flutter/material.dart';
import 'package:flutter_inset_box_shadow/flutter_inset_box_shadow.dart'
    as inset;
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';

import '../../../common/colors.dart';
import '../../../models/blog.dart';
import '../../blog/screens/blog_screen.dart';

class CarouselWidget extends StatelessWidget {
  const CarouselWidget({
    super.key,
    required this.blog,
  });

  final Blog blog;
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BlogScreen(blog: blog),
          ),
        );
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: Card(
          color: Colors.transparent,
          child: Container(
            width: screenWidth * 0.75,
            height: screenHeight * 0.9,
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
                ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Image.network(
                    blog.imageUrl,
                    fit: BoxFit.cover,
                    width: screenWidth * 0.75,
                    height: screenHeight * 0.9,
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
                    blog.title,
                    style: GoogleFonts.getFont(
                      "Ubuntu",
                      color: AppColors().text,
                      fontSize: 15,
                    ),
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
