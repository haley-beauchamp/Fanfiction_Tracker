import 'package:fanfiction_tracker_flutter/common/widgets/custom_button.dart';
import 'package:fanfiction_tracker_flutter/common/widgets/multiselect_rectangles.dart';
import 'package:fanfiction_tracker_flutter/common/widgets/star_rating.dart';
import 'package:fanfiction_tracker_flutter/constants/global_variables.dart';
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
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('No'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
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
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
