import 'dart:convert';

import 'package:fanfiction_tracker_flutter/constants/error_handling.dart';
import 'package:fanfiction_tracker_flutter/constants/global_variables.dart';
import 'package:fanfiction_tracker_flutter/constants/utils.dart';
import 'package:fanfiction_tracker_flutter/features/fanfic_related/models/fanfic.dart';
import 'package:fanfiction_tracker_flutter/features/fanfic_related/models/fanfic_with_review.dart';
import 'package:fanfiction_tracker_flutter/features/fanfic_related/screens/add_fanfic_screen.dart';
import 'package:fanfiction_tracker_flutter/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

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
          final fanfic = Fanfic.fromJson(res.body);
          Navigator.pushNamed(
            context,
            AddFanficScreen.routeName,
            arguments: fanfic,
          );
        },
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  void addFanfic({
    required BuildContext context,
    required int fanficId,
    required String review,
    required double rating,
    required String favoriteMoments,
    required String assignedList,
  }) async {
    try {
      http.Response res = await http.post(
        Uri.parse('$uri/api/addfanfic'),
        body: jsonEncode({
          'userId': Provider.of<UserProvider>(context, listen: false).user.id,
          'fanficId': fanficId,
          'rating': rating,
          'review': review,
          'favoriteMoments': favoriteMoments,
          'assignedList': assignedList,
        }),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          showSnackBar(context, 'success');
        },
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  Future<List<FanficWithReview>> findFanficsByList({
    required BuildContext context,
    required String assignedList,
  }) async {
    List<FanficWithReview> fanfics = [];
    try {
      http.Response res = await http.post(
        Uri.parse('$uri/api/fanficsbylist'),
        body: jsonEncode({
          'userId': Provider.of<UserProvider>(context, listen: false).user.id,
          'assignedList': assignedList,
        }),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          fanfics = (jsonDecode(res.body) as List)
              .map((item) => FanficWithReview.fromMap(item))
              .toList();
        },
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }

    return fanfics;
  }
}
