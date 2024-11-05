import 'package:fanfiction_tracker_flutter/common/widgets/custom_button.dart';
import 'package:fanfiction_tracker_flutter/common/widgets/custom_textfield.dart';
import 'package:fanfiction_tracker_flutter/common/widgets/multiselect_rectangles.dart';
import 'package:fanfiction_tracker_flutter/common/widgets/star_rating.dart';
import 'package:fanfiction_tracker_flutter/constants/global_variables.dart';
import 'package:fanfiction_tracker_flutter/features/fanfic_related/models/fanfic.dart';
import 'package:fanfiction_tracker_flutter/features/fanfic_related/services/fanfic_service.dart';
import 'package:flutter/material.dart';

class AddFanficScreen extends StatefulWidget {
  static const String routeName = '/home/addfanfic';
  const AddFanficScreen({super.key});

  @override
  State<AddFanficScreen> createState() => _AddFanficScreenState();
}

class _AddFanficScreenState extends State<AddFanficScreen> {
  final _addFanficFormKey = GlobalKey<FormState>();
  final FanficService fanficService = FanficService();
  final TextEditingController _reviewController = TextEditingController();
  final TextEditingController _favoriteMomentsController =
      TextEditingController();

  double fanficRating = 0.0;
  List<String> selectedFanficTags = [];

  @override
  void dispose() {
    _reviewController.dispose();
    _favoriteMomentsController.dispose();
    super.dispose();
  }

  void addFanfic(int fanficId) {
    fanficService.addFanfic(
      context: context,
      fanficId: fanficId,
      review: _reviewController.text,
      rating: fanficRating,
      favoriteMoments: _favoriteMomentsController.text,
      assignedList: 'Read', //edit this to let the user pick
      selectedTags: selectedFanficTags,
    );
  }

  @override
  Widget build(BuildContext context) {
    final Fanfic fanfic = ModalRoute.of(context)?.settings.arguments as Fanfic;

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
                  key: _addFanficFormKey,
                  child: Column(
                    children: [
                      CustomTextField(
                        controller: _reviewController,
                        hintText: 'Review',
                      ),
                      const SizedBox(height: 10),
                      CustomTextField(
                        controller: _favoriteMomentsController,
                        hintText: 'Favorite Moments',
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
                            selectedFanficTags = selectedTags; // Update selected tags
                          });
                        },
                      ),
                      const SizedBox(height: 10),
                      StarRating(
                        onRatingChanged: (rating) {
                          setState(() {
                            fanficRating = rating;
                          });
                        },
                      ),
                      const SizedBox(height: 10),
                      CustomButton(
                        text: 'Add Fanfic',
                        onTap: () {
                          if (_addFanficFormKey.currentState!.validate()) {
                            addFanfic(fanfic.id);
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
