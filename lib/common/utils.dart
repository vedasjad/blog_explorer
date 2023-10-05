import 'package:blog_explorer/common/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void showSnackBar(BuildContext context, String text) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        text,
        style: GoogleFonts.getFont(
          'Ubuntu',
          color: AppColors().secondary,
        ),
      ),
    ),
  );
}
