import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';

import '../../../common/colors.dart';
import '../../../models/blog.dart';
import '../widgets/bookmarked_widget.dart';

class BookmarkScreen extends StatefulWidget {
  const BookmarkScreen({super.key});

  @override
  State<BookmarkScreen> createState() => _BookmarkScreenState();
}

class _BookmarkScreenState extends State<BookmarkScreen> {
  List<Blog> bookmarkedList = [];
  final _blogsBox = Hive.box("blogs_box");
  @override
  void initState() {
    super.initState();
    _fillBlogList();
  }

  void _fillBlogList() {
    final blogList = _blogsBox.keys.map((key) {
      final blog = _blogsBox.get(key);
      return Blog(
        id: key,
        imageUrl: blog['imageUrl'],
        title: blog['title'],
        isFavourite: blog['isFavourite'],
      );
    }).toList();
    for (Blog blog in blogList) {
      if (blog.isFavourite == true) {
        setState(() {
          bookmarkedList.add(blog);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
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
            padding: const EdgeInsets.all(20.0),
            child: GestureDetector(
              onTap: () {},
              child: Icon(
                Icons.search,
                size: 25,
                color: AppColors().text,
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
                            duration: const Duration(milliseconds: 250),
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
                        bookmarkedList.removeAt(index);
                        await _blogsBox.delete(bookmarkedList[index].id);
                        await _blogsBox.put(bookmarkedList[index].id, {
                          'title': bookmarkedList[index].title,
                          'imageUrl': bookmarkedList[index].imageUrl,
                          'isFavourite': false,
                        });
                        setState(() {});
                      }
                    },
                    child: BookmarkedWidget(
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
                    fontSize: 30,
                    color: AppColors().text,
                  ),
                ),
              ),
      ),
    );
  }
}
