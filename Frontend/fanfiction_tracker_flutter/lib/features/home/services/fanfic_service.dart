import 'dart:convert';

import 'package:fanfiction_tracker_flutter/constants/error_handling.dart';
import 'package:fanfiction_tracker_flutter/constants/global_variables.dart';
import 'package:fanfiction_tracker_flutter/constants/utils.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class FanficService {
  void findFanfic({
    required BuildContext context,
    required String fanficLink,
  }) async {
    try {
      http.Response res = await http.post(
        Uri.parse('$uri/api/findfanfic'),
        body: jsonEncode({
          'link': fanficLink,
        }),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          showSnackBar(
            context,
            'Fanfic Found',
          );
        },
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }
}
