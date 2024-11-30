import 'package:fanfiction_tracker_flutter/common/widgets/custom_button.dart';
import 'package:fanfiction_tracker_flutter/common/widgets/custom_textfield.dart';
import 'package:fanfiction_tracker_flutter/common/widgets/multiselect_rectangles.dart';
import 'package:fanfiction_tracker_flutter/common/widgets/singleselect_rectangles.dart';
import 'package:fanfiction_tracker_flutter/common/widgets/star_rating.dart';
import 'package:fanfiction_tracker_flutter/constants/global_variables.dart';
import 'package:fanfiction_tracker_flutter/features/fanfic_related/models/fanfic_with_review.dart';
import 'package:fanfiction_tracker_flutter/features/fanfic_related/services/fanfic_service.dart';
import 'package:flutter/material.dart';

class EditFanficScreen extends StatefulWidget {
  static const String routeName = '/home/editfanfic';
  const EditFanficScreen({super.key});

  @override
  State<EditFanficScreen> createState() => _AddFanficScreenState();
}

class _AddFanficScreenState extends State<EditFanficScreen> {
  final _editFanficFormKey = GlobalKey<FormState>();
  final FanficService fanficService = FanficService();
  final TextEditingController _reviewController = TextEditingController();
  final TextEditingController _favoriteMomentsController =
      TextEditingController();

  double? fanficRating;
  List<String> selectedFanficTags = [];
  late FanficWithReview fanfic;
  String selectedDisplayList = 'Read';
  
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    fanfic = ModalRoute.of(context)?.settings.arguments as FanficWithReview;

    _reviewController.text = fanfic.review;
    _favoriteMomentsController.text = fanfic.favoriteMoments;
    fanficRating = fanfic.rating;
    selectedFanficTags = fanfic.favoriteTags;
    selectedDisplayList = fanfic.assignedList;
  }

  @override
  void dispose() {
    _reviewController.dispose();
    _favoriteMomentsController.dispose();
    super.dispose();
  }

  void editFanficReview(int fanficId) {
    fanficService.editFanficReview(
      context: context,
      fanficId: fanficId,
      review: _reviewController.text,
      rating: fanficRating,
      favoriteMoments: _favoriteMomentsController.text,
      assignedList: selectedDisplayList, //edit this to let the user pick
      selectedTags: selectedFanficTags,
    );
  }

  @override
  Widget build(BuildContext context) {
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
                Text(
                  'Summary: ${fanfic.summary}',
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 10),
                Form(
                  key: _editFanficFormKey,
                  child: Column(
                    children: [
                      CustomTextField(
                        controller: _reviewController,
                        hintText: 'Review',
                        isRequired: false,
                      ),
                      const SizedBox(height: 10),
                      CustomTextField(
                        controller: _favoriteMomentsController,
                        hintText: 'Favorite Moments',
                        isRequired: false,
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'Favorite Tags',
                        style: TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 10),
                      MultiselectRectangles(
                        displayList: fanfic.tags,
                        onSelectionChanged: (selectedTags) {
                          setState(() {
                            selectedFanficTags = selectedTags;
                          });
                        },
                        favoritesDisplayList: fanfic.favoriteTags,
                      ),
                      const SizedBox(height: 10),
                      StarRating(
                        initialRating: fanficRating,
                        onRatingChanged: (rating) {
                          setState(() {
                            fanficRating = rating;
                          });
                        },
                      ),
                      const SizedBox(height: 10),
                      SingleSelectRectangles(
                        displayList: const ['Read', 'To-Read'],
                        onSelectionChanged: (selectedList) {
                          setState(() {
                            selectedDisplayList = selectedList;
                          });
                        },
                        initialSelection: selectedDisplayList,
                      ),
                      const SizedBox(height: 10),
                      CustomButton(
                        text: 'Confirm Changes',
                        onTap: () {
                          if (_editFanficFormKey.currentState!.validate()) {
                            editFanficReview(fanfic.fanficId);
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
