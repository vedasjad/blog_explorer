import 'dart:convert';

class Blog {
  final String id;
  final String imageUrl;
  final String title;
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
