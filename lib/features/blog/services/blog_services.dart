import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../../../common/error_handling.dart';
import '../../../common/utils.dart';
import '../../../models/response.dart';

Future<Response> apiRequest(String url, Map jsonMap, String apiKey) async {
  HttpClient httpClient = HttpClient();
  HttpClientRequest request = await httpClient.postUrl(Uri.parse(url));
  request.headers.set('Content-Type', 'application/json');
  request.headers.set('Authorization', 'Bearer $apiKey');
  request.add(utf8.encode(json.encode(jsonMap)));
  HttpClientResponse response = await request.close();
  int statusCode = response.statusCode;
  String reply = await response.transform(utf8.decoder).join();
  Response res = Response(statusCode: statusCode, body: reply);
  httpClient.close();
  return res;
}

class BlogServices {
  Future<String> getTextForBlog({
    required BuildContext context,
    required String prompt,
  }) async {
    await dotenv.load();
    String textForBlog = '';
    const String url = 'https://api.textcortex.com/v1/texts/expansions';
    String apiKey = dotenv.get('CONTENTAPIKEY');
    Map<String, dynamic> jsonMap = {
      "max_tokens": 512,
      "model": "chat-sophos-1",
      "n": 1,
      "source_lang": "en",
      "target_lang": "en",
      "temperature": 0.7,
      "text": "Generate 3 paragraphs for a blog titled $prompt"
    };
    try {
      // http.Response res = await http.post(
      //   Uri.parse(url),
      //   headers: <String, String>{
      //     "Content-Type": "application/json",
      //     "Authorization": "Bearer $apiKey"
      //   },
      //   body: jsonEncode(<String, dynamic>{
      //     "max_tokens": 512,
      //     "model": "chat-sophos-1",
      //     "n": 1,
      //     "source_lang": "en",
      //     "target_lang": "en",
      //     "temperature": 0.7,
      //     "text": "Generate 3 paragraphs about Javascript"
      //   }),
      // );

      //SAMPLE HTTPCLIENT RESPONSE
      // var res = jsonEncode({
      //   "data": {
      //     "outputs": [
      //       {
      //         "index": 0,
      //         "text": "A beautiful sentence hand crafted by TextCortex."
      //       }
      //     ],
      //     "remaining_credits": 0
      //   },
      //   "status": "success"
      // });

      //SAMPLE MODIFIED RESPONSE
      // Response res = Response(
      //   statusCode: 200,
      //   body: jsonEncode({
      //     "data": {
      //       "outputs": [
      //         {
      //           "index": 0,
      //           "text": "A beautiful sentence hand crafted by TextCortex."
      //         }
      //       ],
      //       "remaining_credits": 0
      //     },
      //     "status": "success"
      //   }),
      // );

      var res = await apiRequest(url, jsonMap, apiKey);
      // debugPrint(apiKey);
      // debugPrint(res.body);
      httpClientErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          textForBlog = jsonDecode(res.body)['data']['outputs'][0]['text'];
          // debugPrint(textForBlog);
        },
      );
    } catch (e) {
      // debugPrint(e.toString());
      showSnackBar(context, e.toString());
    }
    return textForBlog;
  }
}
