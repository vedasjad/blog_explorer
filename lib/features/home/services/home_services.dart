import 'dart:convert';

import 'package:blog_explorer/models/blog.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../../common/error_handling.dart';
import '../../../common/utils.dart';

class HomeServices {
  Future<List<Blog>> fetchBlogs({
    required BuildContext context,
  }) async {
    List<Blog> blogList = [];
    const String url = 'https://intent-kit-16.hasura.app/api/rest/blogs';
    const String adminSecret =
        '32qR4KmXOIpsGPQKMqEJHGJS27G5s7HdSKO3gdtQd2kv5e852SiYwWNfxkZOBuQ6';
    try {
      http.Response res = await http.get(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'x-hasura-admin-secret': adminSecret,
        },
      );
      debugPrint(res.body);
      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          for (int i = 0; i < jsonDecode(res.body)["blogs"].length; i++) {
            blogList.add(
              Blog.fromJson(
                jsonEncode(
                  jsonDecode(res.body)["blogs"][i],
                ),
              ),
            );
          }
        },
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }
    return blogList;
  }
}
