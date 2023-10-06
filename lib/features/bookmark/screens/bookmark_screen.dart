import 'dart:math';

import 'package:blog_explorer/providers/bookmarks_provider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../../common/colors.dart';
import '../../../models/blog.dart';
import '../widgets/bookmark_widget.dart';

class BookmarkScreen extends StatefulWidget {
  const BookmarkScreen({super.key});

  @override
  State<BookmarkScreen> createState() => _BookmarkScreenState();
}

class _BookmarkScreenState extends State<BookmarkScreen> {
  List<Blog> bookmarkedList = [];
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bookmarkedList =
        Provider.of<BookmarksProvider>(context, listen: true).bookmarksList;
    bookmarkedList = bookmarkedList.reversed.toList();
    return Scaffold(
      backgroundColor: AppColors().background,
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        scrolledUnderElevation: 3.0,
        elevation: 0,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(
            Icons.arrow_back_ios_rounded,
            size: 25,
            color: AppColors().text,
          ),
        ),
        title: Text(
          'Bookmarks',
          style: GoogleFonts.getFont(
            "Montserrat",
            color: AppColors().secondary,
          ),
        ),
        backgroundColor: AppColors().background,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: IconButton.outlined(
              style: ButtonStyle(
                shape: MaterialStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                side: MaterialStatePropertyAll(
                    BorderSide(color: AppColors().text.withOpacity(0.5))),
              ),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) =>
                      const DeleteBookmarksDialog(),
                );
              },
              icon: Icon(
                Icons.delete_forever_outlined,
                size: 25,
                color: AppColors().secondary,
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: (bookmarkedList.isNotEmpty)
            ? ListView.builder(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(25, 8, 25, 8),
                shrinkWrap: true,
                itemCount: bookmarkedList.length,
                semanticChildCount: min(10, bookmarkedList.length),
                itemBuilder: (BuildContext context, index) {
                  Key key = UniqueKey();
                  return Dismissible(
                    key: key,
                    resizeDuration: const Duration(seconds: 1),
                    background: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Icon(
                            Icons.delete,
                            size: 30,
                            color: AppColors().text,
                          ),
                        ),
                      ],
                    ),
                    confirmDismiss: (direction) async {
                      if (direction == DismissDirection.endToStart) {
                        bool delete = true;
                        final snackBarController =
                            ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            backgroundColor: AppColors().secondary,
                            content:
                                Text('Removed ${bookmarkedList[index].title}'),
                            duration: const Duration(milliseconds: 300),
                            action: SnackBarAction(
                              label: 'Undo',
                              onPressed: () => delete = false,
                            ),
                          ),
                        );
                        await snackBarController.closed;
                        return delete;
                      }
                      return null;
                    },
                    onDismissed: (direction) async {
                      if (direction == DismissDirection.endToStart) {
                        Provider.of<BookmarksProvider>(context, listen: false)
                            .unMarkBlog(bookmarkedList[index]);
                      }
                    },
                    child: BookmarkWidget(
                      blog: bookmarkedList[index],
                    ),
                  );
                },
              )
            : Center(
                child: Text(
                  "No Bookmarks Added",
                  style: GoogleFonts.getFont(
                    "Montserrat",
                    fontSize: 27,
                    color: AppColors().text,
                  ),
                ),
              ),
      ),
    );
  }
}

class DeleteBookmarksDialog extends StatelessWidget {
  const DeleteBookmarksDialog({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors().lightBackground,
      icon: const Icon(
        Icons.delete_forever_outlined,
        size: 30,
      ),
      iconColor: AppColors().secondary,
      title: const Text(
        'Clear Bookmarks!',
      ),
      titleTextStyle: GoogleFonts.getFont(
        'Montserrat',
        color: AppColors().secondary,
        fontSize: 15,
        fontWeight: FontWeight.w600,
      ),
      content: const Text(
        'All the bookmarks will be removed permanently',
        textAlign: TextAlign.center,
      ),
      contentTextStyle: GoogleFonts.getFont(
        'Montserrat',
        fontSize: 12,
        color: AppColors().text,
      ),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  'Cancel',
                  style: GoogleFonts.getFont(
                    'Montserrat',
                    fontSize: 15,
                    color: Colors.green,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  Provider.of<BookmarksProvider>(context, listen: false)
                      .clearBookmarks();
                  Navigator.pop(context);
                },
                child: Text(
                  'Ok',
                  style: GoogleFonts.getFont(
                    'Montserrat',
                    fontSize: 15,
                    color: AppColors().secondary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        )
      ],
    );
  }
}
