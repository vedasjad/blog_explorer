import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../../common/colors.dart';

class LoaderBlogWidget extends StatelessWidget {
  const LoaderBlogWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: Card(
          elevation: 10,
          color: Colors.transparent,
          child: Container(
            color: AppColors().background,
            width: screenWidth * 0.95,
            height: screenHeight * 0.14,
            child: Stack(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.fromLTRB(4, 4, 4, 4),
                      width: screenWidth * 0.3,
                      height: screenHeight * 0.2,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: Shimmer.fromColors(
                          baseColor: AppColors().background,
                          highlightColor: AppColors().lightBackground,
                          child: Container(
                            constraints: const BoxConstraints.expand(),
                            color: AppColors().lightBackground,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              height: 20,
                              width: 100,
                              color: Colors.white12,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 10.0),
                              child: Container(
                                height: 20,
                                width: 150,
                                color: Colors.white12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
