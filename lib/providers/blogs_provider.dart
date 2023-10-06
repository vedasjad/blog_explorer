import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';

import '../features/home/services/home_services.dart';
import '../models/blog.dart';

class BlogsProvider extends ChangeNotifier {
  List<Blog> _blogsList = [];
  final Box<dynamic> blogsBox = Hive.box('blogs_box');

  Future<void> putBlogsInHive(BuildContext context) async {
    final HomeServices homeServices = HomeServices();
    _blogsList = await homeServices.fetchBlogs(context: context);
    for (int i = 0; i < blogsList.length; i++) {
      if (blogsBox.containsKey(blogsList[i].id)) {
        await blogsBox.delete(blogsList[i].id);
      }
      await blogsBox.put(blogsList[i].id, {
        'title': blogsList[i].title,
        'imageUrl': blogsList[i].imageUrl,
      });
    }
    notifyListeners();
  }

  void getBlogsFromHive(BuildContext context) async {
    if (blogsBox.isEmpty) {
      await Provider.of<BlogsProvider>(context).putBlogsInHive(context);
    }
    _blogsList = blogsBox.keys.map((key) {
      final item = blogsBox.get(key);
      return Blog(
        id: key,
        imageUrl: item['imageUrl'],
        title: item['title'],
      );
    }).toList();
    debugPrint("Blogs available in Local Storage");
    _blogsList.shuffle(Random.secure());
    notifyListeners();
  }

  List<Blog> get blogsList => _blogsList;
}
