import 'dart:convert';

import 'package:hive/hive.dart';

part 'blog.g.dart';

@HiveType(typeId: 1)
class Blog {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String imageUrl;
  @HiveField(2)
  final String title;
  @HiveField(3)
  Blog({
    required this.id,
    required this.imageUrl,
    required this.title,
  });
  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'id': id});
    result.addAll({'image_url': imageUrl});
    result.addAll({'title': title});

    return result;
  }

  factory Blog.fromMap(Map<String, dynamic> map) {
    return Blog(
      id: map["id"],
      imageUrl: map["image_url"],
      title: map["title"],
    );
  }

  String toJson() => json.encode(toMap());

  factory Blog.fromJson(String source) => Blog.fromMap(json.decode(source));
}
