import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';

import '../models/blog.dart';

class BookmarksProvider extends ChangeNotifier {
  List<Blog> _bookmarksList = [];
  final Box<dynamic> _bookmarksBox = Hive.box('bookmarksBox');

  void getBookmarksFromHive() {
    _bookmarksList = _bookmarksBox.keys.map((key) {
      final Blog item = _bookmarksBox.get(key);
      return Blog(
        id: key.toString(),
        imageUrl: item.imageUrl,
        title: item.title,
      );
    }).toList();
  }

  void bookmarkBlog(Blog blog) {
    _bookmarksList.add(blog);
    notifyListeners();
    _bookmarksBox.put(blog, blog);
  }

  void unMarkBlog(Blog blog) {
    _bookmarksList.remove(blog);
    notifyListeners();
    _bookmarksBox.delete(blog);
  }

  void clearBookmarks() {
    _bookmarksList.clear();
    notifyListeners();
    _bookmarksBox.clear();
  }

  List<Blog> get bookmarksList => _bookmarksList;
}
