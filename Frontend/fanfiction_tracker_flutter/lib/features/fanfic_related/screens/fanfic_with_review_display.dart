import 'package:fanfiction_tracker_flutter/common/widgets/multiselect_rectangles.dart';
import 'package:fanfiction_tracker_flutter/common/widgets/star_rating.dart';
import 'package:fanfiction_tracker_flutter/constants/global_variables.dart';
import 'package:fanfiction_tracker_flutter/features/fanfic_related/models/fanfic_with_review.dart';
import 'package:flutter/material.dart';

class FanficWithReviewDisplay extends StatefulWidget {
  static const String routeName = '/home/lists/fanficwithreview';
  const FanficWithReviewDisplay({super.key});

  @override
  State<FanficWithReviewDisplay> createState() =>
      _FanficWithReviewDisplayState();
}

class _FanficWithReviewDisplayState extends State<FanficWithReviewDisplay> {
  @override
  Widget build(BuildContext context) {
    final FanficWithReview fanfic =
        ModalRoute.of(context)?.settings.arguments as FanficWithReview;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(50),
        child: AppBar(
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: GlobalVariables.appBarGradient,
            ),
          ),
          title: Text(fanfic.title),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Center(
              child: Column(
                children: [
                  Text(
                    'Fandom: ${fanfic.fandom}',
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Author: ${fanfic.author}',
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Summary: ${fanfic.summary}',
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Review: ${fanfic.review}',
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Favorite Moments: ${fanfic.favoriteMoments}',
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 10),
                  MultiselectRectangles(
                    displayList: fanfic.tags,
                    onSelectionChanged: (selectedTags) {
                      setState(() {});
                    },
                    isEditable: false,
                    favoritesDisplayList: fanfic.favoriteTags,
                  ),
                  const SizedBox(height: 10),
                  StarRating(
                    isEditable: false,
                    initialRating: fanfic.rating,
                    onRatingChanged: (double value) {},
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
