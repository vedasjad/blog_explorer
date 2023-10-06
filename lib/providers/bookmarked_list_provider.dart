import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';

import '../models/blog.dart';

List<Blog> _getItemsFromHive() {
  final Box<dynamic> bookmarksBox = Hive.box('bookmarksBox');
  final data = bookmarksBox.keys.map((key) {
    final Blog item = bookmarksBox.get(key);
    return Blog(
      id: key.toString(),
      imageUrl: item.imageUrl,
      title: item.title,
    );
  }).toList();
  return data;
}

class BookmarksProvider extends ChangeNotifier {
  List<Blog> _bookmarksList = _getItemsFromHive();
  final Box<dynamic> _bookmarksBox = Hive.box('bookmarksBox');

  void bookmarkBlog(Blog blog) {
    _bookmarksList.add(blog);
    notifyListeners();
    _bookmarksBox.add(blog);
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

  List<Blog> get bookmarkedBlogsList => _bookmarksList;
}
