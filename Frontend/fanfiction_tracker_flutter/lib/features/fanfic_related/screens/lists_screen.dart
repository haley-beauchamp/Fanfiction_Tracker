import 'package:fanfiction_tracker_flutter/constants/global_variables.dart';
import 'package:fanfiction_tracker_flutter/features/fanfic_related/models/fanfic_with_review.dart';
import 'package:fanfiction_tracker_flutter/features/fanfic_related/screens/fanfic_with_review_display.dart';
import 'package:fanfiction_tracker_flutter/features/fanfic_related/services/fanfic_service.dart';
import 'package:flutter/material.dart';

class ListsScreen extends StatefulWidget {
  static const String routeName = '/home/lists';
  const ListsScreen({super.key});

  @override
  State<ListsScreen> createState() => _ListsScreenState();
}

class _ListsScreenState extends State<ListsScreen> {
  final FanficService fanficService = FanficService();
  List<FanficWithReview> fanfics = [];

  @override
  void initState() {
    super.initState();
    getFanfics();
  }

  Future<void> getFanfics() async {
    List<FanficWithReview> fetchedFanfics =
        await fanficService.findFanficsByList(
      context: context,
      assignedList: 'Read', // Replace with the actual list you want to fetch
    );
    setState(() {
      fanfics = fetchedFanfics;
    });
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
          title: const Text('Read list'),
        ),
      ),
      body: ListView.builder(
        itemCount: fanfics.length,
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () {
              Navigator.pushNamed(
              context,
              FanficWithReviewDisplay.routeName,
              arguments: fanfics[index],
          );
            },
            child: ListTile(
              title: Center(
                child: Text(
                  fanfics[index].title,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
