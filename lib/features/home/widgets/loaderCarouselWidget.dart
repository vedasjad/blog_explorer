import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../../common/colors.dart';

class LoaderCarouselWidget extends StatelessWidget {
  const LoaderCarouselWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return ClipRRect(
      borderRadius: BorderRadius.circular(40),
      child: Card(
        color: Colors.transparent,
        child: Stack(
          alignment: Alignment.bottomLeft,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(30),
              child: SizedBox(
                width: screenWidth * 0.9,
                height: screenHeight * 0.35,
                child: Shimmer.fromColors(
                  baseColor: AppColors().background,
                  highlightColor: AppColors().lightBackground,
                  child: Container(
                    constraints: const BoxConstraints.expand(),
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(40),
                    ),
                  ),
                ),
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
            Padding(
              padding: const EdgeInsets.all(25.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 20,
                    width: 80,
                    color: Colors.white12,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: Container(
                      height: 20,
                      width: 200,
                      color: Colors.white12,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
