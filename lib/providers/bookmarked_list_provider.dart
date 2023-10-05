import 'package:flutter/cupertino.dart';

import '../models/blog.dart';

class BookmarkedListProvider extends ChangeNotifier {
  List<Blog> _bookmarkedBlogsBox = [];
  // Box<Blog> _bookmarkedBlogsBox = Hive.box("bookmarkedBlogsBox");

  void bookmarkBlog(Blog blog) {
    _bookmarkedBlogsBox.add(blog);
    notifyListeners();
  }

  void unMarkBlog(Blog blog) {
    _bookmarkedBlogsBox.remove(blog);
    notifyListeners();
  }

  List<Blog> get bookmarkedBlogsList => _bookmarkedBlogsBox;
}
