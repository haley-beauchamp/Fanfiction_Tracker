import 'package:fanfiction_tracker_flutter/common/widgets/custom_button.dart';
import 'package:fanfiction_tracker_flutter/common/widgets/multiselect_rectangles.dart';
import 'package:fanfiction_tracker_flutter/common/widgets/star_rating.dart';
import 'package:fanfiction_tracker_flutter/constants/global_variables.dart';
import 'package:fanfiction_tracker_flutter/features/fanfic_related/models/fanfic_stats.dart';
import 'package:fanfiction_tracker_flutter/features/fanfic_related/models/fanfic_with_review.dart';
import 'package:fanfiction_tracker_flutter/features/fanfic_related/screens/edit_fanfic_screen.dart';
import 'package:fanfiction_tracker_flutter/features/fanfic_related/services/fanfic_service.dart';
import 'package:flutter/material.dart';

class FanficWithReviewDisplay extends StatefulWidget {
  static const String routeName = '/home/lists/fanficwithreview';
  const FanficWithReviewDisplay({super.key});

  @override
  State<FanficWithReviewDisplay> createState() =>
      _FanficWithReviewDisplayState();
}

class _FanficWithReviewDisplayState extends State<FanficWithReviewDisplay> {
  final FanficService fanficService = FanficService();

  void showConfirmationDialog(FanficWithReview fanfic) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Are you sure?'),
          content: const Text('Do you want to delete this review?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('No'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                fanficService.deleteFanficReview(
                  context: context,
                  fanficId: fanfic.fanficId,
                );
              },
              child: const Text('Yes'),
            ),
          ],
        );
      },
    );
  }

  void editReview(FanficWithReview fanfic) {
    Navigator.pushNamed(
      context,
      EditFanficScreen.routeName,
      arguments: fanfic,
    );
  }

  void viewStats(FanficWithReview fanfic) async {
    FanficStats? fanficStats = await fanficService.getFanficStats(
      context: context,
      fanficId: fanfic.fanficId,
    );

    if (fanficStats != null && context.mounted) {
      showStatsDialog(fanficStats);
    }
  }

  void showStatsDialog(FanficStats fanficStats) {
    if (context.mounted) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Stats for ${fanficStats.title}'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Average Rating'),
                StarRating(
                  isEditable: false,
                  initialRating: fanficStats.averageRating,
                  onRatingChanged: (double value) {},
                ),
                const SizedBox(height: 10),
                Text('Times Rated: ${fanficStats.timesRated}')
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Close'),
              ),
            ],
          );
        },
      );
    }
  }

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
                SizedBox(
                  width: double.infinity,
                  child: Text.rich(
                    TextSpan(
                      children: [
                        const TextSpan(
                          text: 'Summary: ',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        TextSpan(
                          text: fanfic.summary,
                          style: const TextStyle(fontSize: 16),
                        ),
                      ],
                    )
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: Text.rich(
                    TextSpan(
                      children: [
                        const TextSpan(
                          text: 'Review: ',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        TextSpan(
                          text: fanfic.review,
                          style: const TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: Text.rich(
                    TextSpan(
                      children: [
                        const TextSpan(
                          text: 'Favorite Moments: ',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        TextSpan(
                          text: fanfic.favoriteMoments,
                          style: const TextStyle(fontSize: 16),
                        ),
                      ],
                    )
                  ),
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
                ),
                const SizedBox(height: 10),
                CustomButton(
                  text: 'Edit Review',
                  onTap: () {
                    editReview(fanfic);
                  },
                ),
                const SizedBox(height: 10),
                CustomButton(
                  text: 'Delete Review',
                  onTap: () {
                    showConfirmationDialog(fanfic);
                  },
                ),
                const SizedBox(height: 10),
                CustomButton(
                  text: 'View Fanfic Stats',
                  onTap: () {
                    viewStats(fanfic);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
