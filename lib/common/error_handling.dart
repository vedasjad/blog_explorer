import 'dart:convert';

import 'package:blog_explorer/common/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

import '../models/response.dart';

void httpErrorHandle({
  required http.Response response,
  required BuildContext context,
  required VoidCallback onSuccess,
}) {
  switch (response.statusCode) {
    case 200:
      onSuccess();
      break;
    case 400:
      showSnackBar(context, jsonDecode(response.body)['msg']);
      break;
    case 500:
      showSnackBar(context, jsonDecode(response.body)['error']);
      break;
    default:
      showSnackBar(context, response.body);
  }
}

void httpClientErrorHandle({
  required Response response,
  required BuildContext context,
  required VoidCallback onSuccess,
}) {
  switch (response.statusCode) {
    case 200:
      onSuccess();
      break;
    case 400:
      showSnackBar(
          context,
          jsonDecode(response.body)['msg'] +
              '\nCouldn\'t generate blog from Title');
      break;
    case 500:
      showSnackBar(
          context,
          jsonDecode(response.body)['error'] +
              '\nCouldn\'t generate blog from Title');
      break;
    default:
      showSnackBar(
          context, '${response.body}\nCouldn\'t generate blog from Title');
  }
}
