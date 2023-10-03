import 'package:flutter/material.dart';
import 'package:flutter_inset_box_shadow/flutter_inset_box_shadow.dart'
    as inset;
import 'package:google_fonts/google_fonts.dart';

import '../../../common/colors.dart';

class BlogWidget extends StatelessWidget {
  const BlogWidget({
    super.key,
    required this.imageUrl,
    required this.title,
  });

  final String imageUrl;
  final String title;
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return ClipRRect(
      borderRadius: BorderRadius.circular(15),
      child: Card(
        color: Colors.transparent,
        child: Container(
          width: screenWidth * 0.9,
          height: screenHeight * 0.27,
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
                color: AppColors().cream.withOpacity(0.1),
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
                  imageUrl,
                  fit: BoxFit.cover,
                  width: screenWidth * 0.9,
                  height: screenHeight * 0.27,
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
                  title,
                  style: GoogleFonts.getFont(
                    "Ubuntu",
                    color: AppColors().cream,
                    fontSize: 15,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
