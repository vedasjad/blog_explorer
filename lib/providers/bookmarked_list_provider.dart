import 'package:flutter/cupertino.dart';

import '../models/blog.dart';

class BookmarkedListProvider extends ChangeNotifier {
  List<Blog?> _bookmarkedBlogsList = [];

  void bookmarkBlog(Blog blog) {
    _bookmarkedBlogsList.add(blog);
    notifyListeners();
  }

  void unMarkBlog(Blog blog) {
    _bookmarkedBlogsList.remove(blog);
    notifyListeners();
  }

  void clearBookmarks() {
    _bookmarkedBlogsList.clear();
    notifyListeners();
  }

  List<Blog?> get bookmarkedBlogsList => _bookmarkedBlogsList;
}
